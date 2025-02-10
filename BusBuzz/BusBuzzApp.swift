
import SwiftUI
import Firebase
import GoogleSignIn
import GoogleMaps // Import Google Maps SDK

@main
struct BusBuzzApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LaunchScreen() // Your Launch Screen
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()

        // Configure Google Sign-In
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            fatalError("Unable to retrieve CLIENT_ID from Firebase configuration.")
        }
        
        // Set the Google Maps API key directly (no need for conditional binding)
        let apiKey = "AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4" // Your Google Maps API Key here
        GMSServices.provideAPIKey(apiKey) // Initialize Google Maps with the API key
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
