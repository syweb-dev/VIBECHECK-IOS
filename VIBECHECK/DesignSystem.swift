import SwiftUI

struct NeoColors {
    static let yellow = Color(hex: "FFE600")
    static let pink = Color(hex: "FF69B4")
    static let blue = Color(hex: "0096FF")
    static let green = Color(hex: "00FF00")
    static let purple = Color(hex: "A020F0")
    static let orange = Color(hex: "FFA500")
    static let white = Color.white
    static let black = Color.black
    static let background = Color(hex: "FF69B4") // Main pink background
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Modifiers

struct NeoCardModifier: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 12
    var borderThickness: CGFloat = 3
    var shadowOffset: CGFloat = 4
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: borderThickness)
            )
            .shadow(color: .black, radius: 0, x: shadowOffset, y: shadowOffset)
            .padding(.bottom, shadowOffset) // Prevent clipping
            .padding(.trailing, shadowOffset)
    }
}

struct NeoButtonModifier: ViewModifier {
    var backgroundColor: Color
    var cornerRadius: CGFloat = 12
    var isPressed: Bool = false
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.black, lineWidth: 3)
            )
            .offset(x: isPressed ? 4 : 0, y: isPressed ? 4 : 0)
            .shadow(color: .black, radius: 0, x: isPressed ? 0 : 4, y: isPressed ? 0 : 4)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
    }
}

extension View {
    func neoCard(color: Color = NeoColors.white, radius: CGFloat = 12) -> some View {
        self.modifier(NeoCardModifier(backgroundColor: color, cornerRadius: radius))
    }
    
    func neoButton(color: Color = NeoColors.blue, isPressed: Bool = false) -> some View {
        self.modifier(NeoButtonModifier(backgroundColor: color, isPressed: isPressed))
    }
    
    // Simple bold text style
    func neoText(size: CGFloat = 16, color: Color = .black) -> some View {
        self.font(.system(size: size, weight: .black, design: .rounded))
            .foregroundColor(color)
    }
}
