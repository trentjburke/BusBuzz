import SwiftUI
import GoogleMaps
import CoreLocation
import Firebase

class BusOperatorMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var busLocation: CLLocationCoordinate2D?
    @Published var polylinePath: GMSPath?
    @Published var currentBusStop: String? // Current bus stop name
    
    private var locationManager = CLLocationManager()
    private var googleMapView: GMSMapView?
    
    // Timer for location updates (every 15 seconds)
    private var locationUpdateTimer: Timer?
    
    // Hardcoded routes with coordinates for bus stops
    private let busRoutes: [String: [(name: String, location: CLLocationCoordinate2D)]] = [
        "119 Dehiwala - Maharagama": [
            ("Maharagama", CLLocationCoordinate2D(latitude: 6.846004, longitude: 79.926111)),
            ("Boralesgamuwa lake", CLLocationCoordinate2D(latitude: 6.842679, longitude: 79.916113)),
            ("Embillawatta", CLLocationCoordinate2D(latitude: 6.842843, longitude: 79.912515)),
            ("Pirivena Junction", CLLocationCoordinate2D(latitude: 6.842021, longitude: 79.908512)),
            ("Boralesgamuwa", CLLocationCoordinate2D(latitude: 6.840506, longitude: 79.900605)),
            ("Dewalamulla", CLLocationCoordinate2D(latitude: 6.840362, longitude: 79.897837)),
            ("Bellanwila", CLLocationCoordinate2D(latitude: 6.845176, longitude: 79.889709)),
            ("Belantota", CLLocationCoordinate2D(latitude: 6.848021, longitude: 79.885879)),
            ("Nikape", CLLocationCoordinate2D(latitude: 6.849500, longitude: 79.882735)),
            ("Nedimala", CLLocationCoordinate2D(latitude: 6.849621, longitude: 79.878496)),
            ("Karagampitiya", CLLocationCoordinate2D(latitude: 6.850165, longitude: 79.872634)),
            ("Hillstreet", CLLocationCoordinate2D(latitude: 6.851187, longitude: 79.866501)),
            ("Dehiwala", CLLocationCoordinate2D(latitude: 6.851253, longitude: 79.865038))
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

    // Start tracking the bus and load the route's polyline on the map
    func startTrackingBus(for selectedRoute: String?) {
        locationManager.startUpdatingLocation()
        
        // Set the route's polyline
        if let selectedRoute = selectedRoute {
            loadRouteOnMap(route: selectedRoute)
        }
        
        // Start updating location every 15 seconds
        startLocationUpdateTimer()
    }

    // Start the timer to update the location every 15 seconds
    private func startLocationUpdateTimer() {
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            self?.saveBusLocationToFirebase()  // Save location to Firebase
            self?.updateCurrentBusStop() // Update current bus stop
        }
    }

    // Save bus location to Firebase
    private func saveBusLocationToFirebase() {
        guard let busLocation = busLocation else { return }
        
        // Firebase reference
        let dbRef = Database.database().reference().child("busLocations").childByAutoId()
        
        // Saving bus location to Firebase
        let locationData: [String: Any] = [
            "latitude": busLocation.latitude,
            "longitude": busLocation.longitude,
            "timestamp": Int(Date().timeIntervalSince1970)
        ]
        
        dbRef.setValue(locationData) { error, _ in
            if let error = error {
                print("Failed to save bus location: \(error.localizedDescription)")
            } else {
                print("Bus location saved successfully!")
            }
        }
    }

    // Load the route's polyline on the map based on the selected route
    func loadRouteOnMap(route: String) {
        guard let mapView = googleMapView else { return }
        
        if let routeCoordinates = busRoutes[route]?.map({ $0.location }) {
            let path = GMSPath(fromEncodedPath: encodePath(coordinates: routeCoordinates))
            polylinePath = path
            
            let polyline = GMSPolyline(path: polylinePath)
            polyline.strokeColor = .green
            polyline.strokeWidth = 3
            polyline.map = mapView
        }
    }

    // Update the current bus stop based on bus's location
    private func updateCurrentBusStop() {
        guard let busLocation = busLocation, let selectedRoute = busRoutes["119 Dehiwala - Maharagama"] else { return }
        
        // Convert the busLocation to CLLocation to use the distance method
        let currentLocation = CLLocation(latitude: busLocation.latitude, longitude: busLocation.longitude)
        
        // Find the nearest bus stop
        let nearestStop = selectedRoute.min(by: { currentLocation.distance(from: CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude)) < currentLocation.distance(from: CLLocation(latitude: $1.location.latitude, longitude: $1.location.longitude)) })
        
        DispatchQueue.main.async {
            self.currentBusStop = nearestStop?.name
        }
    }

    // Center the map on the bus location
    func centerMapOnBus() {
        guard let location = busLocation, let mapView = googleMapView else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        mapView.animate(to: camera)
    }

    func setGoogleMapView(_ mapView: GMSMapView) {
        self.googleMapView = mapView
    }

    // Real-time updates when the bus moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.busLocation = latestLocation.coordinate
            self.centerMapOnBus()
        }
    }

    // Helper function to encode coordinates into a polyline string (Google Maps format)
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
}
