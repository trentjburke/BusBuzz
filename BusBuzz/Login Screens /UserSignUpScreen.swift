import SwiftUI

struct UserSignUpScreen: View {
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showToast: Bool = false
    @State private var userIDError: Bool = false
    @State private var passwordError: Bool = false
    @State private var confirmPasswordError: Bool = false
    @State private var navigateToSignIn: Bool = false

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
                    .padding(.top, -10)

                // Title
                Text("Create User Account")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                // Input Fields
                VStack(spacing: 15) {
                    // User ID Field
                    TextField("Enter Email Address", text: $userID)
                        .onChange(of: userID) { _ in
                            userIDError = userID.isEmpty
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(userIDError ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)

                    // Create Password Field
                    HStack {
                        Group {
                            if showPassword {
                                TextField("Create Password", text: $password)
                                    .onChange(of: password) { _ in
                                        passwordError = password.isEmpty
                                    }
                            } else {
                                SecureField("Create Password", text: $password)
                                    .onChange(of: password) { _ in
                                        passwordError = password.isEmpty
                                    }
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                                .frame(width: 30, height: 22)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(passwordError ? Color.red : Color.clear, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .frame(height: 50)

                    // Confirm Password Field
                    HStack {
                        if showConfirmPassword {
                            TextField("Confirm Password", text: $confirmPassword)
                                .onChange(of: confirmPassword) { _ in
                                    confirmPasswordError = confirmPassword.isEmpty
                                }
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .onChange(of: confirmPassword) { _ in
                                    confirmPasswordError = confirmPassword.isEmpty
                                }
                        }
                        Button(action: {
                            showConfirmPassword.toggle()
                        }) {
                            Image(systemName: showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(confirmPasswordError ? Color.red : Color.clear, lineWidth: 2)
                    )
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                }

                // Sign-Up Button
                Button(action: {
                    handleSignUp()
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

                // Already Have an Account Section
                HStack {
                    Text("Already have an Account?")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)

                    NavigationLink(destination: UserLoginScreen().navigationBarBackButtonHidden(true), isActive: $navigateToSignIn) {
                        Text("Sign in")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.buttonGreen)
                    }
                }

                Spacer()
            }

            // Toast Message for Success
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("🎉 Successfully registered your account with BusBuzz! 🚌")
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(AppColors.buttonGreen)
                            .cornerRadius(10)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .transition(.slide)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                        navigateToSignIn = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("⚠️ Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Handle Sign-Up
    private func handleSignUp() {
        userIDError = userID.isEmpty
        passwordError = password.isEmpty
        confirmPasswordError = confirmPassword.isEmpty

        if userIDError || passwordError || confirmPasswordError {
            alertMessage = "Username or password is empty."
            showAlert = true
            return
        }

        guard isValidEmail(userID) else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

        let apiKey = "AIzaSyArDIXE2RlOom_9Zx5Dfy5BtVrDJ2zsLos"
        let url = URL(string:"https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "email": userID,
            "password": password,
            "returnSecureToken": true
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  json["idToken"] as? String != nil else {
                DispatchQueue.main.async {
                    alertMessage = "Email already exists or invalid. Try again."
                    showAlert = true
                }
                return
            }

            sendEmailVerification()
        }.resume()
    }

    private func sendEmailVerification() {
        DispatchQueue.main.async {
            showToast = true
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
}

struct UserSignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserSignUpScreen()
        }
    }
}
