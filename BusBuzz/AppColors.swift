import SwiftUI

struct color {
    static let background = Color(hex: "#01122E") // Deep blue background
    static let buttonGreen = Color(hex: "#34A062") // Green for buttons and icons
}

    extension Color {
        init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red = Double((rgb >> 16) & 0xFF) / 255.0
            let green = Double((rgb >> 8) & 0xFF) / 255.0
            let blue = Double(rgb & 0xFF) / 255.0
            
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
        }
    }
