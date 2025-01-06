import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Background color
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
                    HStack(spacing: 45) {
                        // Bus Operator Button
                        NavigationLink(destination: BusOperatorLoginScreen()) {
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
                        }
                        
                        // User Button
                        NavigationLink(destination: UserLoginScreen()) {
                            VStack {
                                Image("User_icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(AppColors.buttonGreen, lineWidth: 5))
                                Text("User")
                                    .font(.system(size: 25, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()
                }
            }
        }
    }
}

// Preview
struct LaunchPage_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
