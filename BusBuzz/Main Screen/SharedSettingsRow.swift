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
                    .foregroundColor(AppColors.background) // App background color for text

                Spacer()

                // Arrow indicator
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray) // Arrow color adjusted to gray
            }
            .padding(12) // Padding inside the row
            .frame(maxWidth: .infinity) // Full width for rows
            .background(AppColors.grayBackground) // Solid gray background without opacity
            .cornerRadius(8) // Rounded corners for rows
            .padding(.horizontal) // Horizontal padding around rows
        }
    }
}
