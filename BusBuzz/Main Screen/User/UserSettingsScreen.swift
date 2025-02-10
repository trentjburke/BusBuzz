import SwiftUI

struct UserSettingsScreen: View {
    @State private var navigateToLogin = false

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                AppColors.background
                    .edgesIgnoringSafeArea(.top)

                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image("User profile icon")
                            .resizable()
                            .frame(width: 90, height: 100)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, -30)

                    // Settings List
                    VStack(spacing: 10) {
                        NavigationLink(destination: ApplicationInfoView()) {
                            SettingsRow(iconName: "Application info", title: "Application Info") {}
                        }

                        NavigationLink(destination: UserManualPDFView()) {
                            SettingsRow(iconName: "User Manual", title: "User Manual") {}
                        }

                        NavigationLink(destination: AuthoritiesPDFView()) {
                            SettingsRow(iconName: "Authorities", title: "Contact Authorities") {}
                        }

                        NavigationLink(destination: ContactUsView()) {
                            SettingsRow(iconName: "Contact us", title: "Contact Us") {}
                        }

                        NavigationLink(destination: PrivacyPolicyPDFView()) {
                            SettingsRow(iconName: "Privacy policy icon", title: "Privacy Policy") {}
                        }

                        Button(action: {
                            navigateToLogin = true
                        }) {
                            SettingsRow(iconName: "Logout Icon", title: "Logout") {}
                        }
                    }
                    Spacer()
                }
                .padding(.top, 20)
            }

            NavigationLink(destination: UserLoginScreen().navigationBarBackButtonHidden(true), isActive: $navigateToLogin) {
                EmptyView()
            }
        }
    }
}
