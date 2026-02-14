import Foundation

enum AccountingRecordType: String {
    case expense = "支出"
    case income = "收入"
}

struct AccountingRecord: Identifiable, Equatable {
    var id: String { "\(timestamp)|\(type.rawValue)|\(priceString)|\(note)|\(moodEmoji)" }
    let timestamp: Date
    let type: AccountingRecordType
    let price: Decimal
    let note: String
    let moodEmoji: String
    
    var timestampString: String {
        AccountingFileStore.timestampFormatter.string(from: timestamp)
    }
    
    var priceString: String {
        AccountingFileStore.priceFormatter.string(from: price as NSDecimalNumber) ?? "0.00"
    }
}

enum AccountingFileError: LocalizedError {
    case cannotAccessDocumentsDirectory
    case cannotCreateDirectory(underlying: Error)
    case cannotCreateFile(underlying: Error)
    case cannotReadFile(underlying: Error)
    case cannotWriteFile(underlying: Error)
    case invalidAmount
    case invalidType
    
    var errorDescription: String? {
        switch self {
        case .cannotAccessDocumentsDirectory:
            return "无法访问本地存储目录。"
        case .cannotCreateDirectory(let underlying):
            return "无法创建本地存储文件夹：\(underlying.localizedDescription)"
        case .cannotCreateFile(let underlying):
            return "无法创建记账文件：\(underlying.localizedDescription)"
        case .cannotReadFile(let underlying):
            return "无法读取记账文件：\(underlying.localizedDescription)"
        case .cannotWriteFile(let underlying):
            return "无法写入记账文件：\(underlying.localizedDescription)"
        case .invalidAmount:
            return "价格不是有效数字。"
        case .invalidType:
            return "类型字段必须为“支出”或“收入”。"
        }
    }
}

final class AccountingFileStore {
    static let shared = AccountingFileStore()
    static let recordsChangedNotification = Notification.Name("AccountingFileStore.recordsChanged")
    
    static let fixedFileName = "accounting_records.txt"
    static let headerLine = "时间|类型|价格|备注|心情"
    
    static let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    private let ioQueue = DispatchQueue(label: "AccountingFileStore.ioQueue")
    
    private init() {}
    
    func folderURL() throws -> URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw AccountingFileError.cannotAccessDocumentsDirectory
        }
        return documentsURL.appendingPathComponent("MyAccounting", isDirectory: true)
    }
    
    func fileURL() throws -> URL {
        try folderURL().appendingPathComponent(Self.fixedFileName, isDirectory: false)
    }
    
    func ensureFileExists() throws {
        let folder = try folderURL()
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        } catch {
            throw AccountingFileError.cannotCreateDirectory(underlying: error)
        }
        
        let file = try fileURL()
        guard !FileManager.default.fileExists(atPath: file.path) else { return }
        
        let initial = Self.headerLine + "\n"
        do {
            try initial.write(to: file, atomically: true, encoding: .utf8)
        } catch {
            throw AccountingFileError.cannotCreateFile(underlying: error)
        }
    }
    
    func appendRecord(timestamp: Date, type: AccountingRecordType, price: Decimal, note: String, moodEmoji: String) throws {
        try ensureFileExists()
        
        let sanitizedNote = note
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            .replacingOccurrences(of: "|", with: "/")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let emoji = String(moodEmoji.prefix(1))
        let line = "\(Self.timestampFormatter.string(from: timestamp))|\(type.rawValue)|\(Self.priceFormatter.string(from: price as NSDecimalNumber) ?? "0.00")|\(sanitizedNote)|\(emoji)\n"
        
        try ioQueue.sync {
            let file = try fileURL()
            do {
                let existing = (try? String(contentsOf: file, encoding: .utf8)) ?? ""
                let updated = existing + line
                let temp = file.deletingLastPathComponent().appendingPathComponent(".tmp_\(UUID().uuidString).txt")
                try updated.write(to: temp, atomically: true, encoding: .utf8)
                _ = try FileManager.default.replaceItemAt(file, withItemAt: temp)
            } catch {
                throw AccountingFileError.cannotWriteFile(underlying: error)
            }
        }
        
        NotificationCenter.default.post(name: Self.recordsChangedNotification, object: nil)
    }
    
    func readLastRecords(limit: Int) throws -> [AccountingRecord] {
        try ensureFileExists()
        
        return try ioQueue.sync {
            let file = try fileURL()
            do {
                let content = try String(contentsOf: file, encoding: .utf8)
                let lines = content
                    .split(whereSeparator: \.isNewline)
                    .map(String.init)
                
                let dataLines = lines.dropFirst()
                let tail = dataLines.suffix(max(0, limit))
                return tail.compactMap { parseLine($0) }.reversed()
            } catch {
                throw AccountingFileError.cannotReadFile(underlying: error)
            }
        }
    }
    
    func readAllRecords() throws -> [AccountingRecord] {
        try ensureFileExists()
        
        return try ioQueue.sync {
            let file = try fileURL()
            do {
                let content = try String(contentsOf: file, encoding: .utf8)
                let lines = content
                    .split(whereSeparator: \.isNewline)
                    .map(String.init)
                let dataLines = lines.dropFirst()
                return dataLines.compactMap { parseLine($0) }
            } catch {
                throw AccountingFileError.cannotReadFile(underlying: error)
            }
        }
    }
    
    func resetFile() throws {
        let file = try fileURL()
        try ensureFileExists()
        try ioQueue.sync {
            do {
                try (Self.headerLine + "\n").write(to: file, atomically: true, encoding: .utf8)
            } catch {
                throw AccountingFileError.cannotWriteFile(underlying: error)
            }
        }
        NotificationCenter.default.post(name: Self.recordsChangedNotification, object: nil)
    }
    
    private func parseLine(_ line: String) -> AccountingRecord? {
        let parts = line.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
        guard parts.count >= 5 else { return nil }
        
        let timestampString = parts[0]
        let typeString = parts[1]
        let priceString = parts[2]
        let note = parts[3]
        let moodEmoji = parts[4]
        
        guard let timestamp = Self.timestampFormatter.date(from: timestampString) else { return nil }
        guard let type = AccountingRecordType(rawValue: typeString) else { return nil }
        
        let normalizedPrice = priceString.replacingOccurrences(of: ",", with: "")
        guard let decimal = Decimal(string: normalizedPrice, locale: Locale(identifier: "en_US_POSIX")) else { return nil }
        
        return AccountingRecord(timestamp: timestamp, type: type, price: decimal, note: note, moodEmoji: moodEmoji)
    }
}

