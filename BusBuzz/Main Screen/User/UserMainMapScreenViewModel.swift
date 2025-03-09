import SwiftUI
import GoogleMaps
import CoreLocation
import FirebaseDatabase
import Firebase
import FirebaseAuth

class UserMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var polylinePath: GMSPath?
    @Published var filteredBusOperators: [String: CLLocationCoordinate2D] = [:]  // Filtered bus operators based on route
    
    private var locationManager = CLLocationManager()
    private var googleMapView: GMSMapView?
    
    private let googleMapsAPIKey = "AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4"
    
    private var onlineBusTimer: Timer?
    private var selectedRoute: BusRoute?
    
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
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Start the timer for observing online bus operators
    private func startOnlineBusTimer() {
        onlineBusTimer?.invalidate() // Stop existing timer
        
        guard let selectedRoute = selectedRoute else { return } // Ensure route is selected
        
        onlineBusTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.observeOnlineBusOperators(selectedRoute: selectedRoute)
        }
    }
    func updateSelectedRoute(_ route: BusRoute) {
        self.selectedRoute = route
        observeOnlineBusOperators(selectedRoute: route)
        startOnlineBusTimer() // Restart timer with new route
    }
    
    // Load polyline based on the selected route
    func loadPolyline(for route: BusRoute) {
        let coordinates = route.stops.map { $0.location }
        polylinePath = GMSPath(fromEncodedPath: encodePath(coordinates: coordinates))
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
        if let location = userLocation {
            let camera = GMSCameraPosition.camera(
                withLatitude: location.latitude,
                longitude: location.longitude,
                zoom: 15.0
            )
            self.googleMapView?.animate(to: camera)
        }
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
    
    // Fetch and filter online bus operators from Firebase based on the selected route
    func observeOnlineBusOperators(selectedRoute: BusRoute) {
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
                               let busRoute = busData["busRoute"] as? String {
                                
                                let routeInterchange = busData["routeInterchange"] as? Bool ?? false // Default to false if missing
                                
                                // ✅ Correct filtering logic
                                if selectedRoute.routeNumber == busRoute {
                                    if (selectedRoute.isReverse && routeInterchange) ||
                                        (!selectedRoute.isReverse && (!routeInterchange || busData["routeInterchange"] == nil)) {
                                        
                                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        updatedOperators[busID] = location
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.filteredBusOperators = updatedOperators
                            self.updateMapWithFilteredBusOperators()
                        }
                    }
                } catch {
                    print("❌ Error decoding Firebase JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // Update the map with filtered bus operators based on the selected route and reverse status
    private func updateMapWithFilteredBusOperators() {
        guard let mapView = googleMapView else { return }
        mapView.clear()  // Clear previous markers
        
        // Add markers for the filtered bus operators
        for (licensePlateNumber, location) in filteredBusOperators {
            let marker = GMSMarker(position: location)
            
            if let busIcon = UIImage(named: "BusIconBlue") {
                let scaledBusIcon = resizeImage(image: busIcon, targetSize: CGSize(width: 40, height: 40))  // Adjust size as needed
                marker.icon = scaledBusIcon
            }
            
            marker.title = "Bus \(licensePlateNumber)"
            marker.map = mapView
        }
    }
    
    // Helper function to resize image
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
struct BusOperator: Identifiable {
    var id: String
    var busRoute: String
    var busType: String
    var email: String
    var isOnline: Bool
    var latitude: Double
    var longitude: Double
    var licensePlateNumber: String
    var routeInterchange: Bool
    var timestamp: Int
}
