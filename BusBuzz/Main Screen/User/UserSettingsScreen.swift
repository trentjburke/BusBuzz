import SwiftUI

struct UserSettingsScreen: View {
    @State private var showLoginScreen = false 

    var body: some View {
        NavigationView {
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
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 75, height: 75)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.top, -30)

                        // Settings List
                        VStack(spacing: 10) {
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
                }
            }
        }
        .fullScreenCover(isPresented: $showLoginScreen) {
            UserLoginScreen()
                .navigationBarBackButtonHidden(true)
        }
    }
}
struct UserSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsScreen()
    }
}
