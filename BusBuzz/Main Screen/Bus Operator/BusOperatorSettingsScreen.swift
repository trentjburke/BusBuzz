import SwiftUI
import FirebaseDatabase
import Firebase
import FirebaseAuth
import CoreLocation

struct BusOperatorSettingsScreen: View {
    @State private var isOnline: Bool = true // State for the Online/Offline switch
    @State private var showLoginScreen = false // For showing login screen when logout is tapped
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                AppColors.background
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                        Image("Bus_Driver_Icon_Trial")
                            .resizable()
                            .frame(width: 85, height: 85)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, -30)

                    // List of Settings
                    VStack(spacing: 10) {
                        // Online/Offline Toggle Row
                        HStack {
                            Image("Offline & Online Settings Icon")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(.trailing, 10)

                            Text("Online/Offline")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.background)

                            Spacer()

                            Toggle("", isOn: $isOnline)
                                .labelsHidden()
                                .onChange(of: isOnline) { value in
                                    if !value {
                                        stopSharingLocation()
                                    } else {
                                        startSharingLocation()
                                    }
                                }
                        }
                        .padding(12)
                        .background(AppColors.grayBackground)
                        .cornerRadius(8)
                        .padding(.horizontal)

                        // Settings Rows
                        SettingsRow(iconName: "Application info", title: "Application Info", textColor: AppColors.background, destination: AnyView(ApplicationInfoView()))

                        SettingsRow(iconName: "User Manual", title: "User Manual", textColor: AppColors.background, destination: AnyView(UserManualPDFView()))

                        SettingsRow(iconName: "Contact us", title: "Contact Us", textColor: AppColors.background, destination: AnyView(ContactUsView()))

                        SettingsRow(iconName: "Privacy policy icon", title: "Privacy Policy", textColor: AppColors.background, destination: AnyView(PrivacyPolicyPDFView()))

                        SettingsRow(iconName: "Logout Icon", title: "Logout", textColor: AppColors.background) {
                            handleLogout()
                        }
                    }

                    Spacer()
                }
                .padding(.top, 20)

                // Gray background for the bottom tab view
                VStack {
                    Spacer()
                    AppColors.grayBackground
                        .frame(height: 83)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .fullScreenCover(isPresented: $showLoginScreen) {
                BusOperatorLoginScreen()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }

    // Function to stop location sharing
    private func stopSharingLocation() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let dbRef = Database.database().reference().child("busOperators").child(uid)
        dbRef.updateChildValues(["isOnline": false]) { error, _ in
            if let error = error {
                print("Failed to go offline: \(error.localizedDescription)")
            } else {
                print("Bus operator is now offline.")
            }
        }
    }

    // Function to start location sharing (Go Online)
    private func startSharingLocation() {
        if Auth.auth().currentUser == nil {
            print("❌ User is NOT authenticated. Cannot write to Firebase.")
        } else {
            print("✅ User is authenticated: \(Auth.auth().currentUser?.uid ?? "Unknown UID")")
        }
        guard let uid = Auth.auth().currentUser?.uid else {
                print("❌ No authenticated user found. User must log in.")
                return
            }

        let dbRef = Database.database().reference().child("busOperators").child(uid)

        if let location = locationManager.userLocation {
            let locationData: [String: Any] = [
                "isOnline": true,
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
            
            dbRef.updateChildValues(locationData) { error, _ in
                if let error = error {
                    print("❌ Failed to go online: \(error.localizedDescription)")
                } else {
                    print("✅ Bus operator is now online.")
                }
            }
        } else {
            print("❌ Location not available.")
        }
    }
    // Function to handle logout
    private func handleLogout() {
        guard let uid = UserDefaults.standard.string(forKey: "user_uid") else { return }
        
        // Set the bus operator as offline in Firebase
        let dbRef = Database.database().reference().child("busOperators").child(uid)
        dbRef.updateChildValues(["isOnline": false]) { error, _ in
            if let error = error {
                print("❌ Failed to go offline during logout: \(error.localizedDescription)")
            } else {
                print("✅ User set to offline in Firebase.")
            }
        }

        // Clear stored UID so the session doesn't persist
        UserDefaults.standard.removeObject(forKey: "user_uid")
        print("✅ UID removed. User is logged out.")

        // Navigate back to the login screen
        showLoginScreen = true
    }
}

struct BusOperatorSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorSettingsScreen()
    }
}
