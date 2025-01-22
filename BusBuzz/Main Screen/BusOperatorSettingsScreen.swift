import SwiftUI

struct BusOperatorSettingsScreen: View {
    @State private var isOnline: Bool = true // State for the Online/Offline switch

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
                    Image("Bus_Driver_Icon_Trial") // Custom icon for the user profile
                        .resizable()
                        .frame(width: 85, height: 85) // Reduced size for profile icon
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top, -30)

                // List of Settings
                VStack(spacing: 10) { // Reduced spacing between rows
                    HStack {
                        Image("Offline & Online Settings Icon") // Custom icon for Online/Offline
                            .resizable()
                            .frame(width: 35, height: 35) // Adjust size
                            .padding(.trailing, 10)

                        Text("Online/Offline")
                            .font(.system(size: 16, weight: .medium)) // Adjusted font size for text
                            .foregroundColor(.white)

                        Spacer()

                        Toggle("", isOn: $isOnline)
                            .labelsHidden() // Hides the default label of the toggle
                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.horizontal)

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
struct BusOperatorSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorSettingsScreen()
    }
}
