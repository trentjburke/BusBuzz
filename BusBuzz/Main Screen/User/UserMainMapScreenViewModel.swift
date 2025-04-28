import SwiftUI
import GoogleMaps
import CoreLocation
import FirebaseDatabase
import Firebase
import FirebaseAuth

class UserMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var polylinePath: GMSPath?
    struct BusInfo {
        var location: CLLocationCoordinate2D
        var busType: String
        var licensePlateNumber: String
    }

    @Published var filteredBusOperators: [String: BusInfo] = [:]
    
    private var locationManager = CLLocationManager()
    private var googleMapView: GMSMapView?
    
    private let googleMapsAPIKey = "AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4"
    
    private var onlineBusTimer: Timer?
    private var selectedBusTimer: Timer?
    private var selectedRoute: BusRoute?
    @Published var selectedBusId: String?
    @Published var selectedBusLocation: CLLocationCoordinate2D?
    @Published var etaText: String = "ETA: Calculating..."
    private var etaUpdateTimer: Timer?
    
    @Published var selectedBusType: String = ""
    @Published var selectedLicensePlate: String = ""
    
    
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
    
    
    private func startOnlineBusTimer() {
        onlineBusTimer?.invalidate()
        
        guard let selectedRoute = selectedRoute else { return }
        
        onlineBusTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            self.observeOnlineBusOperators(selectedRoute: selectedRoute)
        }
    }
    
    func startTrackingSelectedBus(busId: String) {
        selectedBusId = busId
        selectedBusTimer?.invalidate()
        etaUpdateTimer?.invalidate()
        
        
        fetchSelectedBusLocation { [weak self] location in
            guard let self = self, let busLocation = location else { return }
            
            DispatchQueue.main.async {
                self.selectedBusLocation = busLocation
                self.updateCameraForUserAndBus()
                self.updateETA()
            }
            
            // Start tracking with a timer
            self.selectedBusTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.observeSelectedBusLocation()
            }
            
            // Start ETA update timer
            self.etaUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                self.updateETA()
            }
        }
    }
    
    private func fetchSelectedBusLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        guard let selectedBusId = selectedBusId else {
            completion(nil)
            return
        }
        
        let firebaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators/\(selectedBusId).json"
        
        guard let url = URL(string: firebaseURL) else {
            print("Error: Invalid Firebase URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Failed to fetch selected bus: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error: No data received from Firebase")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let isOnline = json["isOnline"] as? Bool, isOnline,
                   let latitude = json["latitude"] as? Double,
                   let longitude = json["longitude"] as? Double {
                    
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    completion(location)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error: Error decoding Firebase JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    private func updateCameraForUserAndBus() {
        guard let mapView = googleMapView, let busLocation = selectedBusLocation, let userLocation = userLocation else { return }
        
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(busLocation)
        bounds = bounds.includingCoordinate(userLocation)
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        mapView.animate(with: update)
    }
    
    func updateSelectedRoute(_ route: BusRoute) {
        self.selectedRoute = route
        self.selectedBusId = nil  // Sucess: Reset selected bus
        self.selectedBusLocation = nil  // Sucess: Reset selected bus location
        etaText = "ETA: N/A"  // Sucess: Reset ETA display
        etaUpdateTimer?.invalidate() // Sucess: Stop ETA updates
        
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
    
    
    func setGoogleMapView(_ mapView: GMSMapView) {
        self.googleMapView = mapView
        self.googleMapView?.delegate = self
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
            print("Error: Invalid Firebase URL")
            return
        }
        
        var request = URLRequest(url: firebaseURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Failed to fetch bus operators: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Error: No data received from Firebase")
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        var updatedOperators: [String: BusInfo] = [:]
                        
                        for (busID, details) in json {
                            if let busData = details as? [String: Any],
                               let isOnline = busData["isOnline"] as? Bool,
                               isOnline,
                               let latitude = busData["latitude"] as? Double,
                               let longitude = busData["longitude"] as? Double,
                               let busRoute = busData["busRoute"] as? String {
                                
                                let routeInterchange = busData["routeInterchange"] as? Bool ?? false // Default to false if missing
                                
                                // Sucess: Correct filtering logic
                                if selectedRoute.routeNumber == busRoute {
                                    if (selectedRoute.isReverse && routeInterchange) ||
                                        (!selectedRoute.isReverse && (!routeInterchange || busData["routeInterchange"] == nil)) {
                                        
                                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                        let busType = busData["busType"] as? String ?? "Unknown Type"
                                        let licensePlate = busData["licensePlateNumber"] as? String ?? "Unknown Plate"
                                        updatedOperators[busID] = BusInfo(location: location, busType: busType, licensePlateNumber: licensePlate)
                                    }
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.filteredBusOperators = updatedOperators
                            self.updateMapWithFilteredBusOperators()
                            self.updateETA()
                        }
                    }
                } catch {
                    print("Error: Error decoding Firebase JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    private func updateMapWithFilteredBusOperators() {
        guard let mapView = googleMapView else { return }
        mapView.clear()  // Clear previous markers
        
        for (busId, busInfo) in filteredBusOperators {
            let marker = GMSMarker(position: busInfo.location) // Sucess: use busInfo.location
            marker.title = "Bus \(busId)"
            
            if busId == selectedBusId {
                marker.icon = getColoredBusIcon(color: .green)
            } else {
                marker.icon = getColoredBusIcon(color: .blue)
            }
            
            marker.map = mapView
            marker.userData = busId
        }
    }
    
    private func getColoredBusIcon(color: Color, size: CGSize = CGSize(width: 35, height: 35)) -> UIImage? {
        guard let busIcon = UIImage(named: "busIcon") else {
            print("Error: Error: Could not load busIcon image")
            return nil
        }
        
        let uiColor = UIColor(color) // Convert SwiftUI Color to UIColor
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            uiColor.setFill()
            context.cgContext.translateBy(x: 0, y: size.height)
            context.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            let rect = CGRect(origin: .zero, size: size)
            if let cgImage = busIcon.cgImage {
                context.cgContext.clip(to: rect, mask: cgImage)
                context.cgContext.fill(rect)
            } else {
                print("Error: Error: Could not get CGImage from busIcon")
            }
        }
    }
    
    // Helper function to resize image
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func observeSelectedBusLocation() {
        guard let selectedBusId = selectedBusId else { return }
        
        let firebaseURL = "https://busbuzz-5571f-default-rtdb.asia-southeast1.firebasedatabase.app/busOperators/\(selectedBusId).json"
        
        guard let url = URL(string: firebaseURL) else {
            print("Error: Invalid Firebase URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: Failed to fetch selected bus: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Error: No data received from Firebase")
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let isOnline = json["isOnline"] as? Bool, isOnline,
                       let latitude = json["latitude"] as? Double,
                       let longitude = json["longitude"] as? Double {
                        
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        
                        DispatchQueue.main.async {
                            self.selectedBusLocation = location
                            self.updateSelectedBusMarker(location: location)
                            self.updateETA()
                        }
                    }
                } catch {
                    print("Error: Error decoding Firebase JSON: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    private func updateSelectedBusMarker(location: CLLocationCoordinate2D) {
        guard let mapView = googleMapView else { return }
        
        // Clear only the previous selected bus marker, NOT all markers
        mapView.clear()
        
        // Sucess: Add back all buses with their original colors
        for (busId, busInfo) in filteredBusOperators {
            let busMarker = GMSMarker(position: busInfo.location)
            busMarker.title = "Bus \(busId)"
            
            // Sucess: Check if this is the selected bus
            if busId == selectedBusId {
                busMarker.icon = getColoredBusIcon(color: .green) // Selected bus in green
            } else {
                busMarker.icon = getColoredBusIcon(color: .blue) // Other buses in blue
            }
            
            busMarker.map = mapView
            busMarker.userData = busId // Store bus ID for selection tracking
        }
        
        // Sucess: Create and update the selected bus marker
        let selectedBusMarker = GMSMarker(position: location)
        selectedBusMarker.title = "Tracking Bus"
        
        // Sucess: Ensure selected bus stays green
        selectedBusMarker.icon = getColoredBusIcon(color: .green)
        selectedBusMarker.map = mapView
        
        //Adjust camera to fit both selected bus and user location
        var bounds = GMSCoordinateBounds()
        bounds = bounds.includingCoordinate(location) // Selected bus location
        
        if let userLocation = userLocation {
            bounds = bounds.includingCoordinate(userLocation) // User location
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 80) // Adjust padding
        mapView.animate(with: update)
    }
    
    func findNearestStop(to location: CLLocationCoordinate2D, in route: BusRoute) -> (name: String, location: CLLocationCoordinate2D)? {
        guard !route.stops.isEmpty else { return nil }
        
        return route.stops.min(by: {
            let distance1 = distanceBetween(coord1: location, coord2: $0.location)
            let distance2 = distanceBetween(coord1: location, coord2: $1.location)
            return distance1 < distance2
        })
    }
    
    func calculateETA(busLocation: CLLocationCoordinate2D, stopLocation: CLLocationCoordinate2D) -> String {
        guard let selectedRoute = selectedRoute else { return "ETA: N/A" }
        
        guard let busIndex = selectedRoute.stops.firstIndex(where: { distanceBetween(coord1: busLocation, coord2: $0.location) < 500 }),
              let userIndex = selectedRoute.stops.firstIndex(where: { distanceBetween(coord1: stopLocation, coord2: $0.location) < 500 }) else {
            return "ETA: N/A"
        }
        
        // Check direction based on routeInterchange
        let isReverse = selectedRoute.isReverse

        let isValidDirection: Bool
        if isReverse {
            isValidDirection = busIndex >= userIndex
        } else {
            isValidDirection = busIndex <= userIndex
        }
        
        if !isValidDirection {
            return "ETA: N/A" // Error: Bus already passed the user
        }
        
        // Sucess: Bus is coming toward the user, calculate ETA normally
        let distanceMeters = distanceBetween(coord1: busLocation, coord2: stopLocation)
        let speedMetersPerSecond: Double = 8.33 // ~30 km/h in meters per second
        
        // Find stops between bus and target stop
        let stopsBetween = stopsBetweenBusAndStop(busLocation: busLocation, stopLocation: stopLocation, route: selectedRoute)
        
        // Calculate travel time
        let etaSeconds = (distanceMeters / speedMetersPerSecond) + (Double(stopsBetween) * 30) // Add 30s per stop
        let etaMinutes = Int(etaSeconds / 60)
        
        return etaMinutes > 0 ? "\(etaMinutes) min" : "< 1 min"
    }
    func stopsBetweenBusAndStop(busLocation: CLLocationCoordinate2D, stopLocation: CLLocationCoordinate2D, route: BusRoute) -> Int {
        guard let busIndex = route.stops.firstIndex(where: { distanceBetween(coord1: busLocation, coord2: $0.location) < 200 }) else { return 0 }
        guard let stopIndex = route.stops.firstIndex(where: { distanceBetween(coord1: stopLocation, coord2: $0.location) < 200 }) else { return 0 }
        
        return abs(stopIndex - busIndex) // Number of stops in between
    }
    
    // Haversine formula to calculate distance
    func distanceBetween(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return loc1.distance(from: loc2) // Returns distance in meters
    }
    
    // Function to update and display ETA on UI
    func updateETA() {
        guard let busLocation = selectedBusLocation,
              let userLocation = userLocation,
              let route = selectedRoute else {
            etaText = "ETA: N/A"
            return
        }
        
        // Find the closest stop to the user
        guard let closestStop = findClosestStop(to: userLocation, in: route) else {
            etaText = "ETA: N/A"
            return
        }
        
        // Fetch latest bus location before updating ETA
        fetchSelectedBusLocation { [weak self] location in
            guard let self = self, let latestBusLocation = location else { return }
            
            DispatchQueue.main.async {
                self.selectedBusLocation = latestBusLocation  // Sucess: Ensure latest bus location is used
                self.etaText = self.calculateETA(busLocation: latestBusLocation, stopLocation: closestStop.location)
            }
        }
    }
    
    private func findClosestStop(to location: CLLocationCoordinate2D, in route: BusRoute) -> (name: String, location: CLLocationCoordinate2D)? {
        return route.stops.min { stop1, stop2 in
            distanceBetween(coord1: location, coord2: stop1.location) < distanceBetween(coord1: location, coord2: stop2.location)
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
extension UserMainMapScreenViewModel: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let busId = marker.userData as? String {
            print("Sucess: Selected Bus: \(busId)")
            selectedBusId = busId // Sucess: Store selected bus
            if let busLocation = filteredBusOperators[busId] {
                selectedBusType = busLocation.busType  // 👈 You need to extend your `filteredBusOperators` to store more
                selectedLicensePlate = busLocation.licensePlateNumber
            }
            startTrackingSelectedBus(busId: busId)
            updateMapWithFilteredBusOperators()  // Sucess: Refresh to apply correct color
        }
        return true
    }
}
