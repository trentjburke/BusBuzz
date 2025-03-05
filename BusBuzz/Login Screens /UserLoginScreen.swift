import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct UserLoginScreen: View {
    @State private var userID: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var emailError: Bool = false
    @State private var passwordError: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToMainScreen = false
    @State private var navigateToSignUpScreen = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack {
                    // Logo
                    Image("BusBuzz_Logo_Without_Slogan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 300)
                        .padding(.top, -90)
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
                        TextField("Enter Email", text: $userID)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(emailError ? Color.red : Color.clear, lineWidth: 2)
                            )
                            .onChange(of: userID) { newValue in
                                emailError = newValue.isEmpty
                            }
                            .padding(.horizontal, 20)
                            .frame(height: 55)

                        HStack(spacing: 0) {
                            ZStack(alignment: .leading) {
                                if showPassword {
                                    TextField("Enter Password", text: $password)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .onChange(of: password) { newValue in
                                            passwordError = newValue.isEmpty
                                        }
                                } else {
                                    SecureField("Enter Password", text: $password)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .onChange(of: password) { newValue in
                                            passwordError = newValue.isEmpty
                                        }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)

                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                                    .frame(width: 40, height: 45)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(passwordError ? Color.red : Color.clear, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .frame(height: 55)
                    }

                    // Forgot Password Section
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

                    // Sign In Button
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

                    // Navigation to the Main Screen
                    NavigationLink(destination: UserMainScreenContentView(), isActive: $navigateToMainScreen) {
                        EmptyView()
                    }

                    // Don’t Have an Account + Sign Up Section
                    HStack {
                        Text("Don’t have an account?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)

                        Button(action: {
                            navigateToSignUpScreen = true
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(AppColors.buttonGreen)
                        }
                    }
                    .padding(.top, 5)

                    // Navigation to Sign-Up Screen
                    NavigationLink(
                        destination: UserSignUpScreen()
                            .navigationBarBackButtonHidden(true),
                        isActive: $navigateToSignUpScreen
                    ) {
                        EmptyView()
                    }

                    // "Or" Text
                    Text("Or")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, 5)

                    // Google Sign-In Button
                    Button(action: {
                        handleGoogleSignIn()
                    }) {
                        HStack {
                            // Spacer to center content
                            Spacer()

                            // Google Icon
                            Image("GoogleIcon")
                                .resizable()
                                .frame(width: 44, height: 24)

                            // Spacing between the icon and the text
                            Text("Sign In with Google")
                                .font(.headline)
                                .foregroundColor(.black)

                            // Spacer to balance content
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                    NavigationLink(destination: LaunchScreen().navigationBarBackButtonHidden(true)) {
                        Text("Are you a Bus Operator?")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(AppColors.buttonGreen)
                    }

                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Login Error"),
                    message: Text("⚠️ \(alertMessage)"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationBarBackButtonHidden(true)
        }
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
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
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
            
            if let userId = json["localId"] as? String,
               let idToken = json["idToken"] as? String {
                UserDefaults.standard.set(userId, forKey: "user_uid")
                UserDefaults.standard.set(idToken, forKey: "user_id_token")
                UserDefaults.standard.set("user", forKey: "user_type")
                print("✅ UID Saved: \(userId)")
                print("✅ ID Token Saved: \(idToken)")
            }


            DispatchQueue.main.async {
                self.navigateToMainScreen = true
            }
        }.resume()
    }

    private func handleGoogleSignIn() {
        let clientID = "554442860556-7tkuf6qvlrbruqm5rn9567dj06nfqkrh.apps.googleusercontent.com"
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()!) { signInResult, error in
            if let error = error {
                self.alertMessage = "Google Sign-In failed: \(error.localizedDescription)"
                self.showAlert = true
                return
            }

            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                self.alertMessage = "Failed to retrieve Google ID token."
                self.showAlert = true
                return
            }

            self.authenticateWithGoogleIDToken(idToken: idToken)
        }
    }

    private func authenticateWithGoogleIDToken(idToken: String) {
        let apiKey = "AIzaSyArDIXE2RlOom_9Zx5Dfy5BtVrDJ2zsLos"
        let url = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=\(apiKey)")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "postBody": "id_token=\(idToken)&providerId=google.com",
            "requestUri": "http://localhost",
            "returnSecureToken": true
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.alertMessage = "Firebase authentication failed: \(error.localizedDescription)"
                self.showAlert = true
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                self.alertMessage = "Failed to parse Firebase response."
                self.showAlert = true
                return
            }

            if let error = json["error"] as? [String: Any] {
                self.alertMessage = error["message"] as? String ?? "An unknown error occurred."
                self.showAlert = true
                return
            }

            DispatchQueue.main.async {
                self.navigateToMainScreen = true
            }
        }.resume()
    }

    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = scene.windows.first?.rootViewController else {
            return nil
        }
        return rootViewController
    }
}
struct UserLoginScreen_Previews: PreviewProvider {
        static var previews: some View {
            UserLoginScreen()
        }
    }
