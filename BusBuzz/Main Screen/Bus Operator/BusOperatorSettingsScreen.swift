import SwiftUI
import Firebase
import CoreLocation
import FirebaseAuth

class BusOperatorSettingsViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var busLocation: CLLocationCoordinate2D?
    @Published var isOnline: Bool = false
    @Published var isRouteInterchangeActive: Bool = false
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    private var locationUpdateTimer: Timer?
    
    // Update the bus location to Firebase when toggled online
    private func updateLocationToFirebase(for busOperatorId: String) {
        guard let location = locationManager.location?.coordinate else { return }
        
        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators/\(busOperatorId).json"
        
        guard let url = URL(string: databaseURL) else {
            print("Error: Invalid Firebase Database URL")
            return
        }
        
        let locationData: [String: Any] = [
            "latitude": location.latitude,
            "longitude": location.longitude,
            "timestamp": Int(Date().timeIntervalSince1970)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: locationData)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error: Failed to update bus location: \(error.localizedDescription)")
            } else {
                print("Sucess: Updated bus location in Firebase.")
            }
        }.resume()
    }
    
    // Enable or disable online status and start/stop location updates
    func toggleOnlineStatus(isOnline: Bool) {
        self.isOnline = isOnline
        
        guard let userId = UserDefaults.standard.string(forKey: "user_uid") else {
            print("Error: No user_id found in UserDefaults. User must log in.")
            return
        }
        
        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators.json"
        
        guard let url = URL(string: databaseURL) else {
            print("Error: Invalid Firebase Database URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Failed to fetch bus operators: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Error: Failed to parse bus operators response.")
                return
            }
            
            var matchingBusOperatorId: String? = nil
            for (key, value) in json {
                if let operatorData = value as? [String: Any],
                   let storedUserId = operatorData["user_id"] as? String,
                   storedUserId == userId {
                    matchingBusOperatorId = key
                    break
                }
            }
            
            guard let busOperatorId = matchingBusOperatorId else {
                print("Error: No matching bus operator found for user_id: \(userId)")
                return
            }
            
            print("Sucess: Found bus operator: \(busOperatorId)")
            
            // Sucess: Start or stop updating location every 10 seconds
            DispatchQueue.main.async {
                if isOnline {
                    self.startLocationUpdateTimer(for: busOperatorId)
                } else {
                    self.stopLocationUpdateTimer()
                }
            }
            
            self.updateBusOperatorStatus(busOperatorId: busOperatorId, isOnline: isOnline)
        }.resume()
    }
    private func startLocationUpdateTimer(for busOperatorId: String) {
        stopLocationUpdateTimer()  // Ensure we don't start multiple timers
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateLocationToFirebase(for: busOperatorId)
        }
    }
    
    private func stopLocationUpdateTimer() {
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    private func updateBusOperatorStatus(busOperatorId: String, isOnline: Bool) {
        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators/\(busOperatorId).json"
        
        guard let url = URL(string: databaseURL) else {
            print("Error: Invalid Firebase Database URL")
            return
        }
        
        var updateData: [String: Any] = ["isOnline": isOnline]
        
        if isOnline {
            locationManager.startUpdatingLocation()
            updateData["timestamp"] = Int(Date().timeIntervalSince1970)
            
            if let location = locationManager.location?.coordinate {
                updateData["latitude"] = location.latitude
                updateData["longitude"] = location.longitude
            }
        } else {
            locationManager.stopUpdatingLocation()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: updateData)
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error: Failed to update online status in Firebase: \(error.localizedDescription)")
            } else {
                print("Sucess: Successfully updated online status in Firebase: \(isOnline)")
            }
        }.resume()
    }
    
    func fetchCurrentOnlineStatus() {
        guard let userId = UserDefaults.standard.string(forKey: "user_uid") else {
            print("Error: No user_uid found in UserDefaults.")
            return
        }

        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators.json"

        guard let url = URL(string: databaseURL) else {
            print("Error: Invalid Firebase Database URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Failed to fetch bus operators: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Error: Failed to parse bus operators response.")
                return
            }

            for (_, value) in json {
                if let operatorData = value as? [String: Any],
                   let storedUserId = operatorData["user_id"] as? String,
                   storedUserId == userId,
                   let isOnline = operatorData["isOnline"] as? Bool {
                    DispatchQueue.main.async {
                        self.isOnline = isOnline
                    }
                    print("Sucess: Current online status fetched: \(isOnline)")
                    return
                }
            }

            print("Error: No matching bus operator found for user_uid.")
        }.resume()
    }
    
    func fetchCurrentRouteInterchangeStatus() {
        guard let userId = UserDefaults.standard.string(forKey: "user_uid") else {
            print("Error: No user_uid found in UserDefaults.")
            return
        }

        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators.json"

        guard let url = URL(string: databaseURL) else {
            print("Error: Invalid Firebase Database URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Failed to fetch bus operators: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Error: Failed to parse bus operators response.")
                return
            }

            for (_, value) in json {
                if let operatorData = value as? [String: Any],
                   let storedUserId = operatorData["user_id"] as? String,
                   storedUserId == userId,
                   let routeInterchange = operatorData["routeInterchange"] as? Bool {
                    DispatchQueue.main.async {
                        self.isRouteInterchangeActive = routeInterchange
                    }
                    print("Sucess: Current route interchange status fetched: \(routeInterchange)")
                    return
                }
            }

            print("Error: No matching bus operator found for user_uid.")
        }.resume()
    }
    // Function to update route interchange status in Firebase
    func updateRouteInterchangeStatus(isActive: Bool) {
        // Get the user ID from UserDefaults
        guard let userId = UserDefaults.standard.string(forKey: "user_uid") else {
            print("Error: No user_id found in UserDefaults. User must log in.")
            return
        }
        
        // Construct the URL for the Firebase database reference
        let databaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators/\(userId).json"
        guard let url = URL(string: databaseURL) else {
            print("Error: Invalid Firebase Database URL")
            return
        }
        
        // Prepare the data to update the route interchange status
        let updateData: [String: Any] = [
            "routeInterchange": isActive  // Save the toggle status as true or false
        ]
        
        // Create the request to update the database
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"  // Use PATCH to update specific fields
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: updateData)
        
        // Make the API call to update the data in Firebase
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error: Failed to update route interchange status: \(error.localizedDescription)")
            } else {
                print("Sucess: Route interchange status updated successfully in Firebase.")
            }
        }.resume()
    }

}


struct BusOperatorSettingsScreen: View {
    @State private var isOnline: Bool = false
    @State private var showLoginScreen = false
    @State private var isRouteActive: Bool = false
    @StateObject private var viewModel = BusOperatorSettingsViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    
                    // Online/Offline Toggle Row
                    VStack(spacing: 10) {
                        HStack {
                            Image("Offline & online Settings Icon")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .padding(.trailing, 10)
                            Text("Online/Offline")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.background)
                            Spacer()
                            Toggle("", isOn: $viewModel.isOnline)
                                .labelsHidden()
                                .onChange(of: viewModel.isOnline) { value in
                                    viewModel.toggleOnlineStatus(isOnline: value)
                                }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.buttonGreen))
                        .padding(12)
                        .background(AppColors.grayBackground)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        HStack {
                            // Route Interchange Label
                            Image("RouteInterchange") // Your icon image
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 20)
                            
                            Text("Route Interchange")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.background)
                                .padding(.trailing, 10)
                            
                            Spacer()
                            // Toggle for Route Interchange
                            Toggle("", isOn: $viewModel.isRouteInterchangeActive)
                                .labelsHidden()
                                .onChange(of: viewModel.isRouteInterchangeActive) { value in
                                    viewModel.updateRouteInterchangeStatus(isActive: value)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: AppColors.buttonGreen))
                                .background(AppColors.grayBackground)
                                .cornerRadius(8)
                            
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
                    .onAppear {
                        viewModel.fetchCurrentOnlineStatus()
                        viewModel.fetchCurrentRouteInterchangeStatus()
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
    
    // Function to handle logout
    private func handleLogout() {
        guard let uid = UserDefaults.standard.string(forKey: "user_uid") else { return }
        
        let dbRef = Database.database().reference().child("busOperators").child(uid)
        dbRef.updateChildValues(["isOnline": false]) { error, _ in
            if let error = error {
                print("Error: Failed to go offline during logout: \(error.localizedDescription)")
            } else {
                print("Sucess: User set to offline in Firebase.")
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "user_uid")
        print("Sucess: UID removed. User is logged out.")
        
        showLoginScreen = true
    }
}

struct BusOperatorSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorSettingsScreen()
    }
}
