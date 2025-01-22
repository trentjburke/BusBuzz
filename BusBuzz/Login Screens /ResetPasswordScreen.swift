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
                    .frame(width: 400, height: 275)
                    .padding(.top, -40)

                // Title
                Text("Enter new password")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, -40)
                
                // Subtitle
                Text("Please enter a new password to login to your existing account")
                    .font(.system(size: 16, weight: .regular))
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
                .padding(.top, 10)

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
                .padding(.top, 0)

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
