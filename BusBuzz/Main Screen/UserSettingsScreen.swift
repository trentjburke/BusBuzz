import SwiftUI

struct UserSettingsScreen: View {
    var body: some View {
        ZStack {
            // Background color
            AppColors.background
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) { // Reduced spacing between rows
                // Header
                HStack {
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold)) // Adjusted font size for header
                        .foregroundColor(.white)
                    Spacer()
                    Image("User profile icon") // Custom icon for the user profile
                        .resizable()
                        .frame(width: 90, height: 100) // Reduced size for profile icon
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top, -30)

                // List of Settings
                VStack(spacing: 10) { // Reduced spacing between rows
                    SettingsRow(iconName: "Application info", title: "Application info") {
                        print("Application info tapped")
                    }
                    SettingsRow(iconName: "User Manual", title: "User Manual") {
                        print("User Manual tapped")
                    }
                    SettingsRow(iconName: "Authorities", title: "Contact Authorities") {
                        print("Contact Authorities tapped")
                    }
                    SettingsRow(iconName: "Contact us", title: "Contact Us") {
                        print("Contact Us tapped")
                    }
                    SettingsRow(iconName: "Privacy policy icon", title: "Private Policy") {
                        print("Private Policy tapped")
                    }
                    SettingsRow(iconName: "Logout Icon", title: "Logout") {
                        print("Logout tapped")
                    }
                }

                Spacer()
            }
            .padding(.top, 20)
        }
    }
}

// Preview
struct UserSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsScreen()
    }
}
