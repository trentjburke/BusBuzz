import SwiftUI

struct VerificationCodeScreen: View {
    @State private var code1: String = "" // First box input
    @State private var code2: String = "" // Second box input
    @State private var code3: String = "" // Third box input
    @State private var code4: String = "" // Fourth box input

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
                Text("Verification Code")
                    .font(.custom("Righteous-Regular", size: 30))
                    .foregroundColor(.white)

                // Subtitle
                Text("Please check your email and confirm the verification code received")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Input Fields for Verification Code
                HStack(spacing: 15) {
                    TextField("", text: $code1)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.none)

                    TextField("", text: $code2)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.none)

                    TextField("", text: $code3)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.none)

                    TextField("", text: $code4)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.none)
                }
                .padding(.top, 20)

                // Confirm Verification Code Button
                NavigationLink(destination: ResetPasswordScreen().navigationBarBackButtonHidden(true)) {
                    Text("Confirm verification code")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonGreen)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 20)

                // Resend Code Section
                HStack {
                    Text("Did not receive verification code?")
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Button(action: {
                        print("Resend Code Tapped")
                    }) {
                        Text("Resend")
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

struct VerificationCodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        VerificationCodeScreen()
    }
}
