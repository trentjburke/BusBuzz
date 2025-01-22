import SwiftUI

struct UserSignUpScreen: View {
    @State private var userID: String = "" // Create User ID input
    @State private var password: String = "" // Create Password input
    @State private var confirmPassword: String = "" // Confirm Password input
    @Environment(\.presentationMode) var presentationMode // Environment variable to manage presentation

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
                    .padding(.top, -10)

                // Title
                Text("Create User Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, -18)

                // Input Fields
                VStack(spacing: 15) {
                    TextField("Create User ID", text: $userID)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    SecureField("Create User Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    SecureField("Confirm User Password", text: $confirmPassword)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }

                // Sign-Up Button
                Button(action: {
                    print("Sign-Up Button Tapped")
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.buttonGreen)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                .padding(.top, -5)

                // Already Have an Account Section
                HStack {
                    Text("Already have an Account?")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Sign in")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.buttonGreen)
                    }

                }
                .padding(.top, 10)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

struct UserSignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserSignUpScreen()
    }
}
