import SwiftUI

struct AppColors {
    static let background = Color(hex: "#01122E")
    static let busBlue = Color(hex: "#01122E")
    static let buttonGreen = Color(hex: "#34A062")
    static let busGreen = Color(hex: "#34A062")
    static let grayBackground = Color(hex: "#D6D6D6")
}

extension Color {
    init(hex: String) {
        let hexSanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb), hexSanitized.count == 6 else {
            self.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 1.0)
            return
        }
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
