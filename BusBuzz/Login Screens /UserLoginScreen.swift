import SwiftUI

struct UserLoginScreen: View {
    @State private var userID: String = "" // User ID input
    @State private var password: String = "" // Password input
    @State private var rememberMe: Bool = false // State for "Remember Me"
    @Environment(\.presentationMode) var presentationMode // Environment variable to manage view presentation

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
                    .frame(width: 400, height: 300)
                    .padding(.top, -30)
                    .offset(y: 30)

                // Login title
                HStack(alignment: .center, spacing: -60) {
                    Image("User_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .padding(.leading, -125)

                    Text("User Login")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                }
                .padding(.top, 10)

                // User ID and Password Fields
                VStack(spacing: 15) {
                    TextField("Enter User ID", text: $userID)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    SecureField("Enter User Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 10)

                // Remember Me and Forgot Password Section
                HStack {
                    Toggle(isOn: $rememberMe) {
                        Text("Remember Me?")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .toggleStyle(CheckboxToggleStyle())
                    .padding(.leading, 40)

                    Spacer()

                    // NavigationLink for Forgot Password
                    NavigationLink(destination: ForgotPasswordScreen().navigationBarBackButtonHidden(true)) {
                        Text("Forgot Password?")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding(.trailing, 40)
                }

                // Sign In and Sign Up Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        print("Sign In Tapped")
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.buttonGreen)
                            .cornerRadius(15)
                            .padding(.horizontal, 40)
                    }

                    // NavigationLink for Sign Up
                    NavigationLink(destination: UserSignUpScreen()) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.buttonGreen)
                            .cornerRadius(15)
                            .padding(.horizontal, 40)
                    }
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back to LaunchScreen
                }) {
                    HStack {
                        Image(systemName: "chevron.left") // Back arrow icon
                        Text("Back")
                    }
                    .foregroundColor(.white) // Customize the color as needed
                }
            }
        }
    }
}

struct UserLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserLoginScreen()
        }
    }
}
