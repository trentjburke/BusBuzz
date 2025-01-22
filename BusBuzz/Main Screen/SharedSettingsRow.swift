import SwiftUI

struct SettingsRow: View {
    var iconName: String // Name of the custom icon
    var title: String
    var action: () -> Void // Closure for handling button tap

    var body: some View {
        Button(action: action) {
            HStack {
                // Use custom icons
                Image(iconName)
                    .resizable()
                    .frame(width: 35, height: 35) // Adjusted icon size
                    .padding(.trailing, 10) // Added padding for spacing

                Text(title)
                    .font(.system(size: 16, weight: .medium)) // Adjusted font size for text
                    .foregroundColor(.white)

                Spacer()

                // Arrow indicator
                Image(systemName: "chevron.right")
                    .foregroundColor(.white) // Arrow color
            }
            .padding(12) // Reduced padding for compact rows
            .background(Color.gray.opacity(0.5)) // Slightly transparent background
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
}
