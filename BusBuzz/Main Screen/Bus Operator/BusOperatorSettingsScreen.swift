import SwiftUI

struct BusOperatorSettingsScreen: View {
    @State private var isOnline: Bool = true // State for the Online/Offline switch

    var body: some View {
        ZStack {
            // Background color
            AppColors.background
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Settings")
                        .font(.system(size: 40, weight: .bold)) // Adjusted font size for header
                        .foregroundColor(.white) // Keep "Settings" in white
                    Spacer()
                    Image("Bus_Driver_Icon_Trial")
                        .resizable()
                        .frame(width: 85, height: 85)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top, -30)

                // List of Settings
                VStack(spacing: 10) {
                    // Online/Offline Toggle Row
                    HStack {
                        Image("Offline & Online Settings Icon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 10)

                        Text("Online/Offline")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.background)

                        Spacer()

                        Toggle("", isOn: $isOnline)
                            .labelsHidden() // Hides the default label of the toggle
                    }
                    .padding(12)
                    .background(AppColors.grayBackground) // Solid gray background
                    .cornerRadius(8)
                    .padding(.horizontal)

                    // Settings Rows
                    SettingsRow(iconName: "Application info", title: "Application Info", textColor: AppColors.background, destination: AnyView(ApplicationInfoView()))

                    SettingsRow(iconName: "User Manual", title: "User Manual", textColor: AppColors.background) {
                        print("User Manual tapped")
                    }

                    SettingsRow(iconName: "Contact us", title: "Contact Us", textColor: AppColors.background) {
                        print("Contact Us tapped")
                    }

                    SettingsRow(iconName: "Privacy policy icon", title: "Privacy Policy", textColor: AppColors.background) {
                        print("Privacy Policy tapped")
                    }

                    SettingsRow(iconName: "Logout Icon", title: "Logout", textColor: AppColors.background) {
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
