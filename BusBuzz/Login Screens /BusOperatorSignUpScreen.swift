import SwiftUI

struct BusOperatorSignUpScreen: View {
    @State private var userID: String = ""
    @State private var licensePlateNumber: String = ""
    @State private var busType: String? = nil
    @State private var selectedRoute: String? = nil
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var userIDError: Bool = false
    @State private var licensePlateError: Bool = false
    @State private var busTypeError: Bool = false
    @State private var busRouteError: Bool = false
    @State private var passwordError: Bool = false
    @State private var confirmPasswordError: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var showToast: Bool = false
    @State private var navigateToLogin: Bool = false
    
    let busTypes = ["Government Bus", "Private Bus", "Highway Bus"]
    let busRoutes = [
        "120",
        "119",
        "Ex-01"
    ]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 05) {
                
                Image("BusBuzz_Logo_Without_Slogan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 300)
                    .padding(.top, -12)
                
                
                Text("Create Bus Operator Account")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                
                VStack(spacing: 8) {
                    
                    InputField(
                        title: "Enter Email address",
                        text: $userID,
                        error: $userIDError
                    )
                    
                    
                    DropdownField(
                        title: "Select Bus Type",
                        selectedOption: $busType,
                        error: $busTypeError,
                        options: busTypes
                    )
                    
                    
                    InputField(
                        title: "License Plate Number",
                        text: $licensePlateNumber,
                        error: $licensePlateError
                    )
                    
                    
                    DropdownField(
                        title: "Select Bus Route",
                        selectedOption: $selectedRoute,
                        error: $busRouteError,
                        options: busRoutes
                    )
                    
                
                    SecureInputField(
                        title: "Create Password",
                        text: $password,
                        showText: $showPassword,
                        error: $passwordError
                    )
                    
                    
                    SecureInputField(
                        title: "Confirm Password",
                        text: $confirmPassword,
                        showText: $showConfirmPassword,
                        error: $confirmPasswordError
                    )
                }
                
                
                Button(action: {
                    handleSignUp()
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .frame(height: 55)
                        .background(AppColors.buttonGreen)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 10)
                
                
                               NavigationLink(destination: BusOperatorLoginScreen().navigationBarBackButtonHidden(true), isActive: $navigateToLogin) {
                                   EmptyView()
                               }
                
                HStack {
                    Text("Already have an Account?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: BusOperatorLoginScreen().navigationBarBackButtonHidden(true)) {
                        Text("Sign in")
                            .font(.subheadline)
                            .foregroundColor(AppColors.buttonGreen)
                            .bold()
                    }
                }
                .padding(.top, 5)
                
                Spacer()
            }
            .padding(.top, -55)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning: Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
    }

    private func handleSignUp() {
        
        userIDError = userID.isEmpty
        licensePlateError = licensePlateNumber.isEmpty
        busTypeError = busType == nil
        busRouteError = selectedRoute == nil
        passwordError = password.isEmpty
        confirmPasswordError = confirmPassword.isEmpty

        if userIDError || licensePlateError || busTypeError || busRouteError || passwordError || confirmPasswordError {
            alertMessage = "Please fill in all the fields correctly."
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }

        let apiKey = "AIzaSyArDIXE2RlOom_9Zx5Dfy5BtVrDJ2zsLos"
        let authURL = URL(string: "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=\(apiKey)")!

        var authRequest = URLRequest(url: authURL)
        authRequest.httpMethod = "POST"
        authRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let authPayload: [String: Any] = [
            "email": userID,
            "password": password,
            "returnSecureToken": true
        ]

        authRequest.httpBody = try? JSONSerialization.data(withJSONObject: authPayload)

        URLSession.shared.dataTask(with: authRequest) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Network error: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let localId = json["localId"] as? String else {
                DispatchQueue.main.async {
                    alertMessage = "Failed to register. Try again."
                    showAlert = true
                }
                return
            }

            
            if let idToken = json["idToken"] as? String {
                UserDefaults.standard.set(localId, forKey: "user_uid")
                UserDefaults.standard.set(idToken, forKey: "user_id_token")
                UserDefaults.standard.set("bus_operator", forKey: "user_type")
                print("Sucess: UID Saved: \(localId)")
                print("Sucess: Token Saved: \(idToken)")
            }

        
            self.saveBusOperatorInfo(localId: localId)
        }.resume()
    }
    
    private func saveBusOperatorInfo(localId: String) {
        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators/\(localId).json"

        guard let url = URL(string: databaseURL) else { return }

        let busOperatorData: [String: Any] = [
            "user_id": localId, 
            "email": userID,
            "licensePlateNumber": licensePlateNumber,
            "busType": busType ?? "",
            "busRoute": selectedRoute ?? "",
            "timestamp": Int(Date().timeIntervalSince1970)
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: busOperatorData)

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Error saving data: \(error.localizedDescription)"
                    showAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    showToast = true

                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showToast = false
                        navigateToLogin = true
                    }
                }
            }
        }.resume()
    }
    
    
    struct InputField: View {
        var title: String
        @Binding var text: String
        @Binding var error: Bool
        
        var body: some View {
            TextField(title, text: $text)
                .onChange(of: text) { _ in
                    error = text.isEmpty
                }
                .padding()
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error ? Color.red : Color.clear, lineWidth: 2)
                )
                .padding(.horizontal, 20)
        }
    }
    
    struct DropdownField: View {
        var title: String
        @Binding var selectedOption: String?
        @Binding var error: Bool
        var options: [String]
        
        var body: some View {
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                        error = false
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selectedOption ?? title)
                        .foregroundColor(selectedOption == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(error ? Color.red : Color.clear, lineWidth: 2)
                ) 
                .padding(.horizontal, 20)
            }
        }
    }
    struct SecureInputField: View {
        var title: String
        @Binding var text: String
        @Binding var showText: Bool
        @Binding var error: Bool
        
        var body: some View {
            HStack {
                if showText {
                    TextField(title, text: $text)
                        .onChange(of: text) { _ in
                            error = text.isEmpty
                        }
                } else {
                    SecureField(title, text: $text)
                        .onChange(of: text) { _ in
                            error = text.isEmpty
                        }
                }
                Button(action: {
                    showText.toggle()
                }) {
                    Image(systemName: showText ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(error ? Color.red : Color.clear, lineWidth: 2)
            )
            .padding(.horizontal, 20)
        }
    }
    
    struct BusOperatorSignUpScreen_Previews: PreviewProvider {
        static var previews: some View {
            BusOperatorSignUpScreen()
        }
    }
}
