import SwiftUI

struct LaunchScreen: View {
    @State private var navigateToBusOperatorMainScreen = false
    @State private var navigateToUserMainScreen = false
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                Color.black.ignoresSafeArea()
            } else if navigateToBusOperatorMainScreen {
                BusOperatorMainScreenContentView()
            } else if navigateToUserMainScreen {
                UserMainScreenContentView()
            } else {
                // If UID is not found, display the launch screen
                NavigationStack {
                    ZStack {
                        AppColors.background
                            .ignoresSafeArea()

                        VStack(spacing: 20) {
                            // Welcome Text
                            Text("Welcome to")
                                .font(Font.custom("Righteous-Regular", size: 35))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top, 40)
                                .multilineTextAlignment(.center)

                            // Logo
                            Image("BusBuzz_Logo_With_Background")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)

                            Text("Are you a")
                                .font(.custom("Righteous-Regular", size: 30))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 30)

                            // Two Buttons: Bus Operator and User
                            HStack(spacing: 50) {
                                // Bus Operator Button
                                NavigationLink(destination: BusOperatorLoginScreen().navigationBarBackButtonHidden(true)) {
                                    VStack {
                                        Image("Bus_Driver_Icon_Trial")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(AppColors.buttonGreen, lineWidth: 5))
                                        Text("Bus Operator")
                                            .font(.system(size: 25, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .offset(x: -23)
                                }

                                // User Button
                                NavigationLink(destination: UserLoginScreen().navigationBarBackButtonHidden(true)) {
                                    VStack {
                                        Image("User_icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 120, height: 120)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(AppColors.buttonGreen, lineWidth: 5))
                                        Text("Commuter")
                                            .font(.system(size: 25, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.bottom, 40)

                            Spacer()
                        }
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            // Sucess: Check for stored UID before displaying anything
            if let storedUID = UserDefaults.standard.string(forKey: "user_uid") {
                if UserDefaults.standard.string(forKey: "user_type") == "bus_operator" {
                    navigateToBusOperatorMainScreen = true
                    navigateToUserMainScreen = false
                }
                else {
                    navigateToBusOperatorMainScreen = false
                    navigateToUserMainScreen = true
                }
                print("Sucess: User already signed in: \(storedUID)")
            } else {
                print("Error: No stored UID, user must log in.")
            }
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isLoading = false
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
