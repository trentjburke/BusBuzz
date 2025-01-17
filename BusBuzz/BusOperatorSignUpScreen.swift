import SwiftUI

struct BusOperatorSignUpScreen: View {
    @State private var userID: String = "" // Create User ID input
    @State private var licensePlateNumber: String = "" // License Plate Number input
    @State private var busType: String? = nil // Selected Bus Type
    @State private var busRoute: String = "" // Bus Route input
    @State private var password: String = "" // Create User Password input
    @State private var confirmPassword: String = "" // Confirm User Password input
    @State private var isDropdownVisible: Bool = false // Controls dropdown visibility

    @Environment(\.presentationMode) var presentationMode // Environment variable to manage view presentation

    let busTypes = ["Government Bus", "Private Bus", "Highway Bus"] // Dropdown options for Bus Type

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
                    .frame(width: 400, height: 250)
                    .padding(.top, -10)

                // Title
                Text("Create Bus Operator Account")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, -18)

                // Input Fields
                VStack(spacing: 15) {
                    TextField("Create User ID", text: $userID)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    TextField("License plate number", text: $licensePlateNumber)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)

                    // Styled Picker for Bus Type
                    Button(action: {
                        withAnimation {
                            isDropdownVisible.toggle()
                        }
                    }) {
                        HStack {
                            Text(busType ?? "Bus Type") // Placeholder text if no option selected
                                .foregroundColor(busType == nil ? Color.gray : Color.black)
                            Spacer()
                            Image(systemName: "chevron.down") // Dropdown arrow
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)

                    TextField("Bus Route", text: $busRoute)
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
                    print("Selected Bus Type: \(busType ?? "None")") // Debugging selected bus type
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
                        .font(.subheadline)
                        .foregroundColor(.white)

                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Navigate back to BusOperatorLoginScreen
                    }) {
                        Text("Sign in")
                            .font(.subheadline)
                            .foregroundColor(AppColors.buttonGreen)
                            .bold()
                    }
                }
                .padding(.top, 10)

                Spacer()
            }

            // Dropdown Options Popup
            if isDropdownVisible {
                ZStack {
                    // Transparent background to detect taps outside the dropdown
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isDropdownVisible = false // Close dropdown if background is tapped
                            }
                        }

                    // Dropdown options
                    VStack(spacing: 0) {
                        ForEach(busTypes, id: \.self) { type in
                            Button(action: {
                                busType = type // Update selected bus type
                                withAnimation {
                                    isDropdownVisible = false // Hide dropdown
                                }
                            }) {
                                Text(type)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width - 40) // Match dropdown to text fields width
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                }
                .zIndex(2) // Ensure dropdown appears above everything else
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Navigate back to BusOperatorLoginScreen
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

struct BusOperatorSignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BusOperatorSignUpScreen()
        }
    }
}
