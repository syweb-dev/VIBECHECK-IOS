import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var showAddEntry: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content
            Group {
                switch selectedTab {
                case 0:
                    DashboardView()
                case 1:
                    AnalyticsView()
                case 2:
                    SettingsView()
                default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                TabButton(icon: "house.fill", color: NeoColors.green, isSelected: selectedTab == 0) {
                    selectedTab = 0
                }
                
                TabButton(icon: "chart.bar.fill", color: NeoColors.yellow, isSelected: selectedTab == 1) {
                    selectedTab = 1
                }
                
                TabButton(icon: "gearshape.fill", color: NeoColors.blue, isSelected: selectedTab == 2) {
                    selectedTab = 2
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 26))
            .padding(4)
            .background(Color.white)
            .cornerRadius(30)
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 3))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            // Floating Action Button for Add Entry (Optional, but in image it's in the header, 
            // but usually a FAB is good. The image has a + in the top right of Dashboard/AddEntry.
            // I'll stick to the button in the DashboardView header or AddEntryView logic.)
            // Actually, the Image 1 IS the Add Entry screen, and Image 2 has no explicit + button 
            // except maybe implied or I should add one. 
            // Let's add a FAB just in case, or rely on a button in Dashboard.
            // I'll add a FAB above the tab bar for quick access.
            
            Button(action: { showAddEntry = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .black))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color.black)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 4)
            }
            .offset(y: -80)
            .padding(.trailing, 20)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .sheet(isPresented: $showAddEntry) {
            AddEntryView()
        }
    }
}

struct TabButton: View {
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(color)
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
            }
        }
        .frame(height: 50)
        .overlay(
            Rectangle()
                .stroke(Color.black, lineWidth: 1)
        )
    }
}
