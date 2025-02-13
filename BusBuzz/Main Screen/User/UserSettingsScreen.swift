import SwiftUI

struct UserSettingsScreen: View {
    @State private var showLoginScreen = false

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
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, -30)

                    // Settings List
                    VStack(spacing: 10) {
                        // Settings Rows
                        SettingsRow(iconName: "Application info", title: "Application Info", textColor: AppColors.background, destination: AnyView(ApplicationInfoView()))

                        SettingsRow(iconName: "User Manual", title: "User Manual", textColor: AppColors.background, destination: AnyView(UserManualPDFView()))

                        SettingsRow(iconName: "Authorities", title: "Contact Authorities", textColor: AppColors.background, destination: AnyView(AuthoritiesPDFView()))

                        SettingsRow(iconName: "Contact us", title: "Contact Us", textColor: AppColors.background, destination: AnyView(ContactUsView()))

                        SettingsRow(iconName: "Privacy policy icon", title: "Privacy Policy", textColor: AppColors.background, destination: AnyView(PrivacyPolicyPDFView()))

                        SettingsRow(iconName: "Logout Icon", title: "Logout", textColor: AppColors.background, action: {
                            showLoginScreen = true
                        })
                    }

                    Spacer()
                }
                .padding(.top, 20)

                // Gray background for the bottom tab view
                VStack {
                    Spacer()
                    AppColors.grayBackground
                        .frame(height: 83) // Adjusted height for the bottom tab area
                        .edgesIgnoringSafeArea(.horizontal) // Ensure it stretches across the bottom
                }
                .edgesIgnoringSafeArea(.bottom) // Keep the bottom area covered and prevent gaps
            }
            
            // Full Screen Login
            .fullScreenCover(isPresented: $showLoginScreen) {
                UserLoginScreen()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct UserSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsScreen()
    }
}
