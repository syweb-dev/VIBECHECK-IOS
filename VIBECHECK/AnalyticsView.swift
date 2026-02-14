import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var records: [AccountingRecord] = []
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Background from image seems white/black/dark
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(localizationManager.localize("app_name"))
                        .font(.system(size: 24, weight: .black))
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 5) {
                        Image(systemName: "cellularbars")
                        Image(systemName: "wifi")
                        Image(systemName: "battery.100")
                    }
                    .foregroundColor(.white)
                }
                .padding()
                .background(Color.black)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Happiness ROI Chart
                        VStack(alignment: .leading) {
                            Text(localizationManager.localize("happiness_roi"))
                                .neoText(size: 16, color: .white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(NeoColors.green)
                                .cornerRadius(8)
                            
                            Chart {
                                ForEach(records) { record in
                                    PointMark(
                                        x: .value("Investment", (record.price as NSDecimalNumber).doubleValue),
                                        y: .value("Happiness", moodScore(for: record.moodEmoji))
                                    )
                                    .symbol {
                                        Text(record.moodEmoji)
                                            .font(.system(size: 20))
                                    }
                                }
                            }
                            .chartYScale(domain: 0...6)
                            .chartXAxisLabel(localizationManager.localize("return_on_investment"))
                            .chartYAxisLabel(localizationManager.localize("high") + " / " + localizationManager.localize("low"))
                            .frame(height: 200)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        }
                        .padding(.horizontal)
                        
                        // Stupidity Tax (Pie Chart)
                        VStack(alignment: .leading) {
                            Text(localizationManager.localize("stupidity_tax"))
                                .neoText(size: 16, color: .black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(NeoColors.yellow)
                                .cornerRadius(8)
                            
                            if #available(iOS 17.0, *) {
                                Chart(calculateStupidityData(), id: \.category) { item in
                                    SectorMark(
                                        angle: .value("Amount", item.amount),
                                        innerRadius: .ratio(0.5),
                                        angularInset: 1.5
                                    )
                                    .foregroundStyle(item.color)
                                    .annotation(position: .overlay) {
                                        Text("\(Int(item.percentage * 100))%")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                                .chartLegend(position: .bottom, spacing: 20)
                                .frame(height: 250) // Increased height for legend
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            } else {
                                Text(localizationManager.localize("pie_chart_ios17"))
                                    .frame(height: 200)
                                    .background(Color.white)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Spending vs Stability
                        VStack(alignment: .leading) {
                            Text(localizationManager.localize("spending_vs_stability"))
                                .neoText(size: 16, color: .white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(NeoColors.purple)
                                .cornerRadius(8)
                            
                            Chart {
                                ForEach(calculateDailyData(), id: \.date) { item in
                                    LineMark(
                                        x: .value("Date", item.date, unit: .day),
                                        y: .value("Spending", item.totalSpending)
                                    )
                                    .foregroundStyle(NeoColors.yellow)
                                    .symbol(by: .value("Type", localizationManager.localize("spending")))
                                    
                                    LineMark(
                                        x: .value("Date", item.date, unit: .day),
                                        y: .value("Stability", item.avgMood * 20) // Scale up for visibility
                                    )
                                    .foregroundStyle(NeoColors.blue)
                                    .symbol(by: .value("Type", localizationManager.localize("emotional_stability")))
                                }
                            }
                            .chartForegroundStyleScale([
                                localizationManager.localize("spending"): NeoColors.yellow,
                                localizationManager.localize("emotional_stability"): NeoColors.blue
                            ])
                            .frame(height: 200)
                            .padding()
                            .background(Color(hex: "222222")) // Dark background
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            loadAll()
        }
        .onReceive(NotificationCenter.default.publisher(for: AccountingFileStore.recordsChangedNotification)) { _ in
            loadAll()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text(localizationManager.localize("missing_info")), message: Text(errorMessage), dismissButton: .default(Text(localizationManager.localize("ok"))))
        }
    }
    
    struct PieData {
        let category: String
        let amount: Double
        let color: Color
        var percentage: Double = 0
    }
    
    func calculateStupidityData() -> [PieData] {
        let expenses = records.filter { $0.type == .expense }
        let total = expenses.reduce(Decimal.zero) { $0 + $1.price }
        guard total > 0 else { return [] }
        
        let badSpending = expenses
            .filter { moodScore(for: $0.moodEmoji) < 3 }
            .reduce(Decimal.zero) { $0 + $1.price }
        let goodSpending = total - badSpending
        
        return [
            PieData(category: localizationManager.localize("stupidity_tax"), amount: (badSpending as NSDecimalNumber).doubleValue, color: NeoColors.pink, percentage: (badSpending as NSDecimalNumber).doubleValue / (total as NSDecimalNumber).doubleValue),
            PieData(category: localizationManager.localize("good_vibes"), amount: (goodSpending as NSDecimalNumber).doubleValue, color: NeoColors.blue, percentage: (goodSpending as NSDecimalNumber).doubleValue / (total as NSDecimalNumber).doubleValue)
        ]
    }
    
    struct DailyData {
        let date: Date
        let totalSpending: Double
        let avgMood: Double
    }
    
    func calculateDailyData() -> [DailyData] {
        // Simplified grouping by day
        let grouped = Dictionary(grouping: records) { Calendar.current.startOfDay(for: $0.timestamp) }
        return grouped.map { (date, rs) in
            let spending = rs.filter { $0.type == .expense }.reduce(Decimal.zero) { $0 + $1.price }
            let avgMood = rs.isEmpty ? 0 : (Double(rs.reduce(0) { $0 + moodScore(for: $1.moodEmoji) }) / Double(rs.count))
            return DailyData(date: date, totalSpending: (spending as NSDecimalNumber).doubleValue, avgMood: avgMood)
        }.sorted { $0.date < $1.date }
    }

    func moodScore(for emoji: String) -> Int {
        Mood.allCases.first(where: { $0.emoji == emoji })?.score ?? 3
    }
    
    func loadAll() {
        do {
            records = try AccountingFileStore.shared.readAllRecords()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}
