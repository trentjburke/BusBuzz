import SwiftUI

struct BusOperatorLoginScreen: View {
    @State private var userID: String = "" // User ID input
    @State private var password: String = "" // Password input
    @State private var showPassword: Bool = false // Toggle for password visibility
    @State private var emailError: Bool = false // Error state for email input
    @State private var passwordError: Bool = false // Error state for password input
    @State private var showAlert: Bool = false // State for showing alerts
    @State private var alertMessage: String = "" // Alert message content
    @State private var navigateToMainScreen = false // Navigation trigger to MainScreenContentView

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: 15) {
                    // Logo
                    Image("BusBuzz_Logo_Without_Slogan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 300)
                        .padding(.top, -190)

                    // Login title
                    HStack(alignment: .center, spacing: 10) {
                        Image("Bus_Driver_Icon_Trial")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)

                        Text("Bus Operator Login")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading, 5)
                    }
                    .padding(.top, -40)

                    // User ID and Password Fields
                    VStack(spacing: 10) {
                        TextField("Enter Email", text: $userID)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .frame(height: 55)
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(emailError ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .onChange(of: userID) { newValue in
                                emailError = newValue.isEmpty
                            }
                            .padding(.horizontal, 20)

                        HStack {
                            if showPassword {
                                TextField("Enter Password", text: $password)
                                    .padding()
                                    .frame(height: 60)
                                    .onChange(of: password) { newValue in
                                        passwordError = newValue.isEmpty
                                    }
                            } else {
                                SecureField("Enter Password", text: $password)
                                    .padding()
                                    .frame(height: 60)
                                    .onChange(of: password) { newValue in
                                        passwordError = newValue.isEmpty
                                    }
                            }

                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .frame(width: 40, height: 40)
                            }
                            .padding(.trailing, 10)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(passwordError ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                    }

                    HStack {
                        Spacer()
                        NavigationLink(destination: ForgotPasswordScreen().navigationBarBackButtonHidden(true)) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 40)
                    }
                    .padding(.top, 5)

                    Button(action: {
                        handleSignIn(email: userID, password: password)
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

                    NavigationLink(destination: BusOperatorMainMapScreen(), isActive: $navigateToMainScreen) {
                        EmptyView()
                    }

                    HStack {
                        Text("Don’t have an account?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)

                        NavigationLink(destination: BusOperatorSignUpScreen().navigationBarBackButtonHidden(true)) {
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppColors.buttonGreen)
                        }
                    }
                    .padding(.top, 5)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Error"),
                    message: Text("⚠️ \(alertMessage)"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarBackButtonHidden(true) // Hides the back button
            .navigationBarHidden(true) // Completely hides the navigation bar
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures consistent navigation
    }
    private func handleSignIn(email: String, password: String) {
        emailError = email.isEmpty
        passwordError = password.isEmpty

        if emailError || passwordError {
            alertMessage = "Email and Password cannot be empty."
            showAlert = true
            return
        }

        // Firebase REST API
        let apiKey = "AIzaSyArDIXE2RlOom_9Zx5Dfy5BtVrDJ2zsLos"
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "email": email,
            "password": password,
            "returnSecureToken": true
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Login failed: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                DispatchQueue.main.async {
                    self.alertMessage = "Failed to parse server response."
                    self.showAlert = true
                }
                return
            }

            if let error = json["error"] as? [String: Any] {
                DispatchQueue.main.async {
                    self.alertMessage = error["message"] as? String ?? "An unknown error occurred."
                    self.showAlert = true
                }
                return
            }

            DispatchQueue.main.async {
                self.navigateToMainScreen = true
            }
        }.resume()
    }
}

struct BusOperatorLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BusOperatorLoginScreen()
        }
    }
}
