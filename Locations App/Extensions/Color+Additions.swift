import SwiftUI

extension Color {
    init(hex: String) {
        var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")
        
        // Helpers
        var rgb: UInt64 = 0
        var r: Double = 0.0
        var g: Double = 0.0
        var b: Double = 0.0
        var a: Double = 1.0
        let length = hexNormalized.count
        
        Scanner(string: hexNormalized).scanHexInt64(&rgb)
        
        if length == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = Double((rgb & 0xFF000000) >> 24) / 255.0
            g = Double((rgb & 0x00FF0000) >> 16) / 255.0
            b = Double((rgb & 0x0000FF00) >> 8) / 255.0
            a = Double(rgb & 0x000000FF) / 255.0
        } else {
            r = 1
            g = 1
            b = 1
            a = 1
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
    
    func hexForTag() -> String {
        Color.tagColors[self]!
    }
}

extension Color {
    static let tagColors = [
        Color("berryRed") : "berryRed",
        Color("charcoal") : "charcoal",
        Color("limeGreen") : "limeGreen",
        Color("salmon") : "salmon",
        Color("skyBlue") : "skyBlue"
    ]
}
