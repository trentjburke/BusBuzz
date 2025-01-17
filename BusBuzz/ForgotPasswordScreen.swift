import SwiftUI

struct ForgotPasswordScreen: View {
    @State private var email: String = "" // State for email input

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
                    .padding(.top, -40)

                // Title
                Text("Forgot your password?")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, -50)

                // Subtitle
                Text("Enter your registered email and we will send you a verification code to your registered email")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Email TextField
                TextField("Enter email address", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                // Send Verification Code Button
                NavigationLink(destination: VerificationCodeScreen().navigationBarBackButtonHidden(true)) {
                    Text("Send verification code")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonGreen)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 10)

                // Remember Password Section
                HStack {
                    Text("Remember your password?")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    NavigationLink(destination: LaunchScreen().navigationBarBackButtonHidden(true)) {
                        Text("Sign in")
                            .font(.subheadline)
                            .foregroundColor(AppColors.buttonGreen)
                            .bold()
                    }
                }
                .padding(.top, 10)

                Spacer()
            }
        }
    }
}

struct ForgotPasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordScreen()
    }
}
