import SwiftUI

struct ResetPasswordScreen: View {
    @State private var newPassword: String = "" // New password input
    @State private var confirmPassword: String = "" // Confirm password input

    var body: some View {
        ZStack {
            // Background color
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Logo
                Image("BusBuzz_Logo_Without_Slogan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 350)

                // Title
                Text("Enter new password")
                    .font(.custom("Righteous-Regular", size: 30))
                    .foregroundColor(.white)

                // Subtitle
                Text("Please enter a new password to login to your existing account")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Password Input Fields
                VStack(spacing: 15) {
                    SecureField("Enter new password", text: $newPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    SecureField("Confirm new password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)

                // Update Password Button
                Button(action: {
                    print("Update Password Tapped")
                }) {
                    Text("Update password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonGreen)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)

                Spacer()
            }
        }
    }
}

struct ResetPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordScreen()
    }
}
