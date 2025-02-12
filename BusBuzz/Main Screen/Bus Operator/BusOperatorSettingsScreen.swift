import SwiftUI

struct BusOperatorSettingsScreen: View {
    @State private var isOnline: Bool = true // State for the Online/Offline switch
    @State private var showLoginScreen = false // For showing login screen when logout is tapped

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                AppColors.background
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white) 
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
                                .labelsHidden()
                                .onChange(of: isOnline) { value in
                                    if !value {
                                        stopSharingLocation()
                                    } else {
                                        startSharingLocation()
                                    }
                                }
                        }
                        .padding(12)
                        .background(AppColors.grayBackground)
                        .cornerRadius(8)
                        .padding(.horizontal)

                        // Settings Rows
                        SettingsRow(iconName: "Application info", title: "Application Info", textColor: AppColors.background, destination: AnyView(ApplicationInfoView()))

                        SettingsRow(iconName: "User Manual", title: "User Manual", textColor: AppColors.background, destination: AnyView(UserManualPDFView()))

                        SettingsRow(iconName: "Contact us", title: "Contact Us", textColor: AppColors.background, destination: AnyView(ContactUsView()))

                        SettingsRow(iconName: "Privacy policy icon", title: "Privacy Policy", textColor: AppColors.background, destination: AnyView(PrivacyPolicyPDFView()))

                        SettingsRow(iconName: "Logout Icon", title: "Logout", textColor: AppColors.background) {
                            showLoginScreen = true
                        }
                    }

                    Spacer()
                }
                .padding(.top, 20)
            }
            .fullScreenCover(isPresented: $showLoginScreen) {
                BusOperatorLoginScreen()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    // Function to stop location sharing
    private func stopSharingLocation() {
        // Logic to stop sharing the bus operator's location
        print("Location sharing stopped.")
    }

    // Function to start location sharing
    private func startSharingLocation() {
        // Logic to resume sharing the bus operator's location
        print("Location sharing resumed.")
    }
}
struct BusOperatorSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorSettingsScreen()
    }
}
