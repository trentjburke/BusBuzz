import SwiftUI
import GoogleMaps
import CoreLocation
import FirebaseDatabase
import Firebase
import FirebaseAuth

class UserMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var polylinePath: GMSPath?
    @Published var onlineBusOperators: [String: CLLocationCoordinate2D] = [:]

    private var locationManager = CLLocationManager()
    private var googleMapView: GMSMapView?

    private let googleMapsAPIKey = "AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4"
    
    // Hardcoded polyline data for the routes
    private let routePolylines: [String: [CLLocationCoordinate2D]] = [
        "119": [
            CLLocationCoordinate2D(latitude: 6.846004, longitude: 79.926111), // Maharagama
            CLLocationCoordinate2D(latitude: 6.851253, longitude: 79.865038)  // Dehiwala
        ],
        "120": [
            CLLocationCoordinate2D(latitude: 6.8001, longitude: 79.9415),  // Kesbewa
            CLLocationCoordinate2D(latitude: 6.9488, longitude: 79.9930)  // Colombo
        ],
        "Ex01": [
            CLLocationCoordinate2D(latitude: 6.8391, longitude: 79.9763),  // Makumbura
            CLLocationCoordinate2D(latitude: 6.0324, longitude: 80.2149)  // Galle
        ]
    ]
    private var onlineBusTimer: Timer?

    private func startOnlineBusTimer() {
        onlineBusTimer?.invalidate() // Stop existing timer if running
        onlineBusTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.observeOnlineBusOperators()
        }
    }

    override init() {
        super.init()
        setupLocationManager()
        startOnlineBusTimer()  // ✅ Keep refreshing every 10 seconds
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // Load polyline based on the selected route
     func loadPolyline(for route: BusRoute) {
         let coordinates = route.stops.map { $0.location }  // Extract coordinates from route
         polylinePath = GMSPath(fromEncodedPath: encodePath(coordinates: coordinates))  // Encode to polyline
     }

     // Helper function to encode coordinates into a polyline string
    private func encodePath(coordinates: [CLLocationCoordinate2D]) -> String {
        var encodedString = ""
        var prevLat: Int = 0
        var prevLng: Int = 0
        
        for coordinate in coordinates {
            let lat = Int(coordinate.latitude * 1e5)
            let lng = Int(coordinate.longitude * 1e5)
            var deltaLat = lat - prevLat
            var deltaLng = lng - prevLng
            
            encodedString += encodeCoordinate(deltaLat)
            encodedString += encodeCoordinate(deltaLng)
            
            prevLat = lat
            prevLng = lng
        }
        return encodedString
    }


    // Centers the map on the user's location
    func centerMapOnUser() {
        guard let location = userLocation, let mapView = googleMapView else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        mapView.animate(to: camera)
    }

    // Sets the Google Map view when it's ready
    func setGoogleMapView(_ mapView: GMSMapView) {
        self.googleMapView = mapView
        self.googleMapView?.isMyLocationEnabled = true
        self.googleMapView?.settings.myLocationButton = true
        self.googleMapView?.settings.zoomGestures = true
        self.googleMapView?.settings.scrollGestures = true
        self.googleMapView?.settings.rotateGestures = true
        self.googleMapView?.settings.tiltGestures = true
    }
    
    
    // Helper function to encode a single coordinate
     private func encodeCoordinate(_ coordinate: Int) -> String {
         var coord = coordinate
         coord <<= 1
         if coordinate < 0 {
             coord = ~coord
         }

         var encoded = ""
         while coord >= 0x20 {
             let nextValue = (0x20 | (coord & 0x1f)) + 63
             encoded.append(Character(UnicodeScalar(nextValue)!))
             coord >>= 5
         }
         encoded.append(Character(UnicodeScalar(coord + 63)!))

         return encoded
     }
    // Updates the user's location when the location manager detects a change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
                self.userLocation = latestLocation.coordinate
                self.googleMapView?.isMyLocationEnabled = true
                
                let camera = GMSCameraPosition.camera(
                    withLatitude: latestLocation.coordinate.latitude,
                    longitude: latestLocation.coordinate.longitude,
                    zoom: 15.0
                )
                self.googleMapView?.animate(to: camera)
            }
    }
    func enableMyLocation() {
        DispatchQueue.main.async {
            self.googleMapView?.isMyLocationEnabled = true
            self.googleMapView?.settings.myLocationButton = true
        }
    }
    
    func observeOnlineBusOperators() {
        guard let firebaseURL = URL(string: "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators.json") else {
            print("❌ Invalid Firebase URL")
            return
        }

        var request = URLRequest(url: firebaseURL)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Failed to fetch bus operators: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("❌ No data received from Firebase")
                return
            }

            // ✅ Process data in the background
            DispatchQueue.global(qos: .background).async {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        var updatedOperators: [String: CLLocationCoordinate2D] = [:]

                        for (busID, details) in json {
                            if let busData = details as? [String: Any],
                               let isOnline = busData["isOnline"] as? Bool,
                               isOnline,
                               let latitude = busData["latitude"] as? Double,
                               let longitude = busData["longitude"] as? Double,
                               let licensePlateNumber = busData["licensePlateNumber"] as? String {

                                let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                
                                updatedOperators[licensePlateNumber] = location
                            }
                        }

                        // ✅ Update UI on the main thread
                        DispatchQueue.main.async {
                            self.onlineBusOperators = updatedOperators
                            self.updateMapWithBusOperators()
                        }
                    }
                } catch {
                    print("❌ Error decoding Firebase JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func updateMapWithBusOperators() {
        guard let mapView = googleMapView else { return }
        mapView.clear()  // ✅ Clear previous markers

        for (licensePlateNumber, location) in onlineBusOperators {
            let marker = GMSMarker(position: location)

            if let busIcon = UIImage(named: "BusIconBlue") {
                let scaledBusIcon = resizeImage(image: busIcon, targetSize: CGSize(width: 40, height: 40)) // Adjust size as needed
                marker.icon = scaledBusIcon
            }

            marker.title = "Bus \(licensePlateNumber)"
            marker.map = mapView
        }
    }

    // 🔹 Helper function to resize image
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

// DirectionsResponse Struct (to fix the missing struct error)
struct DirectionsResponse: Codable {
    let routes: [Route]?
}

struct Route: Codable {
    let overview_polyline: OverviewPolyline
}

struct OverviewPolyline: Codable {
    let points: String
}
