import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var records: [AccountingRecord] = []
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            NeoColors.pink.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(localizationManager.localize("app_name"))
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.black)
                    Spacer()
                    HStack(spacing: 5) {
                        Image(systemName: "cellularbars")
                        Image(systemName: "wifi")
                        Image(systemName: "battery.100")
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.black)
                }
                .padding()
                .background(NeoColors.pink)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Summary Cards
                        VStack(spacing: 12) {
                            HStack {
                                Text("\(localizationManager.localize("net_happiness")): 😀 +\(calculateNetHappiness())")
                                    .neoText(size: 18)
                                Spacer()
                            }
                            .padding()
                            .background(NeoColors.yellow)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            
                            HStack {
                                Text("\(localizationManager.localize("net_spending")): 👋 \(formatCurrency(calculateNetSpending()))")
                                    .neoText(size: 18)
                                Spacer()
                            }
                            .padding()
                            .background(Color(hex: "00C896")) // Teal/Green
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        }
                        .padding(.horizontal)
                        
                        // Recent Transactions Header
                        HStack {
                            Text(localizationManager.localize("recent_transactions"))
                                .neoText(size: 22)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Transaction List
                        LazyVStack(spacing: 12) {
                            ForEach(records) { record in
                                RecordRow(record: record)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 80) // Space for tab bar
                }
            }
        }
        .onAppear {
            loadRecent()
        }
        .onReceive(NotificationCenter.default.publisher(for: AccountingFileStore.recordsChangedNotification)) { _ in
            loadRecent()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text(localizationManager.localize("missing_info")), message: Text(errorMessage), dismissButton: .default(Text(localizationManager.localize("ok"))))
        }
    }
    
    func calculateNetHappiness() -> Int {
        // Simplified logic: Sum of scores of today's transactions
        let today = Calendar.current.startOfDay(for: Date())
        return records
            .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
            .reduce(0) { $0 + moodScore(for: $1.moodEmoji) }
    }
    
    func calculateNetSpending() -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        let sum = records
            .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
            .reduce(Decimal.zero) { partial, record in
                let signed = record.type == .expense ? -record.price : record.price
                return partial + signed
            }
        return (sum as NSDecimalNumber).doubleValue
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    func moodScore(for emoji: String) -> Int {
        Mood.allCases.first(where: { $0.emoji == emoji })?.score ?? 3
    }
    
    func loadRecent() {
        do {
            records = try AccountingFileStore.shared.readLastRecords(limit: 10)
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}

struct RecordRow: View {
    let record: AccountingRecord
    
    var body: some View {
        HStack {
            // Icon
            ZStack {
                Text(record.moodEmoji)
                    .font(.system(size: 24))
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading) {
                Text(record.note.isEmpty ? "—" : record.note)
                    .neoText(size: 18)
                Text("\(formatDate(record.timestamp))")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black.opacity(0.7))
            }
            
            Spacer()
            
            Text(record.type == .expense ? "-\(formatCurrency(record.price))" : "+\(formatCurrency(record.price))")
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(getColorForAmount())
                .shadow(color: .black, radius: 0, x: 1, y: 1)
        }
        .padding()
        .background(getBackgroundColor())
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
        .shadow(color: .black, radius: 0, x: 4, y: 4)
    }
    
    func formatCurrency(_ amount: Decimal) -> String {
        AccountingFileStore.priceFormatter.string(from: amount as NSDecimalNumber) ?? "0.00"
    }
    
    func formatDate(_ date: Date) -> String {
        AccountingFileStore.timestampFormatter.string(from: date)
    }
    
    func getBackgroundColor() -> Color {
        if record.moodEmoji == Mood.regretlessJoy.emoji { return NeoColors.yellow }
        if record.moodEmoji == Mood.impulseTax.emoji { return NeoColors.purple.opacity(0.7) }
        if record.moodEmoji == Mood.revengeSpending.emoji { return NeoColors.pink }
        if record.moodEmoji == Mood.happy.emoji { return NeoColors.green }
        return NeoColors.white
    }
    
    func getColorForAmount() -> Color {
        return record.type == .expense ? NeoColors.yellow : NeoColors.black
    }
}
