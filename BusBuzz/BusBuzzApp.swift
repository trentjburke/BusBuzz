
import SwiftUI
import Firebase
import GoogleSignIn
import GoogleMaps
import FirebaseAuth

@main
struct BusBuzzApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
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
        
        // Set the Google Maps API key directly
        let apiKey = "AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4"
        GMSServices.provideAPIKey(apiKey)
        
        // Sucess: Attempt to restore Firebase session
        restoreFirebaseSession()
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
            Messaging.messaging().token { token, error in
                if let error = error {
                    print("Error: Error fetching FCM token: \(error.localizedDescription)")
                } else if let token = token {
                    print("Sucess: FCM Token: \(token)")
                    // Store token in Firestore or Realtime Database
                }
            }
        }
    
    // Sucess: Function to restore Firebase session
    private func restoreFirebaseSession() {
        if let uid = UserDefaults.standard.string(forKey: "user_uid") {
            print("🔄 Checking Firebase session for UID: \(uid)")

            let currentUser = Auth.auth().currentUser

            if let user = currentUser {
                print("Sucess: Firebase session already active for UID: \(user.uid)")
            } else {
                print("Warning: No active Firebase session. Attempting re-authentication.")

                // Fetch the latest ID token and refresh if needed
                Auth.auth().signIn(withEmail: "your_email@example.com", password: "your_password") { authResult, error in
                    if let error = error {
                        print("Error: Re-authentication failed: \(error.localizedDescription)")
                    } else if let user = authResult?.user {
                        print("Sucess: Firebase session restored for UID: \(user.uid)")
                    }
                }
            }
        } else {
            print("Error: No stored UID. User must log in.")
        }
    }
}
