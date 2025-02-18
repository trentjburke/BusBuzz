import SwiftUI
import GoogleMaps
import CoreLocation

class UserMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var polylinePath: GMSPath?

    private var locationManager = CLLocationManager()
    private var googleMapView: GMSMapView?

    private let googleMapsAPIKey = "AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4"

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // Fetches the route polyline based on the selected route
    func fetchSelectedRoute(for route: BusRoute) {
        var origin: CLLocationCoordinate2D
        var destination: CLLocationCoordinate2D

        // Check which route is selected and set origin and destination accordingly
        switch route.routeNumber {
        case "119":
            origin = CLLocationCoordinate2D(latitude: 6.8461, longitude: 79.9261)  // Maharagama
            destination = CLLocationCoordinate2D(latitude: 6.8512, longitude: 79.8650) // Dehiwala
        case "120":
            origin = CLLocationCoordinate2D(latitude: 6.8001, longitude: 79.9415)  // Kesbewa
            destination = CLLocationCoordinate2D(latitude: 6.9345, longitude: 79.8546) // Pettah
        case "Ex01":
            origin = CLLocationCoordinate2D(latitude: 6.8391, longitude: 79.9763) // Makumbura
            destination = CLLocationCoordinate2D(latitude: 6.0324, longitude: 80.2149) // Galle
        default:
            return
        }

        fetchRoute(from: origin, to: destination)
    }

    // Fetches the polyline for the selected route using Google's Directions API
    private func fetchRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&key=\(googleMapsAPIKey)"
        
        guard let url = URL(string: directionsURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print("Error fetching route: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                let directionsResponse = try decoder.decode(DirectionsResponse.self, from: data)
                if let routes = directionsResponse.routes, let route = routes.first {
                    DispatchQueue.main.async {
                        self.decodePolyline(encodedPolyline: route.overview_polyline.points)
                        self.centerMapOnRoute()
                    }
                }
            } catch {
                print("Failed to decode directions response: \(error)")
            }
        }
        task.resume()
    }

    // Decodes the polyline returned by the API and updates the map
    func decodePolyline(encodedPolyline: String) {
        if let path = GMSPath(fromEncodedPath: encodedPolyline) {
            DispatchQueue.main.async {
                self.polylinePath = path
            }
        } else {
            print("Failed to decode polyline")
        }
    }

    // Centers the map on the user's location
    func centerMapOnUser() {
        guard let location = userLocation, let mapView = googleMapView else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        mapView.animate(to: camera)
    }

    // Centers the map on the selected route's polyline
    func centerMapOnRoute() {
        guard let polyline = polylinePath, let mapView = googleMapView else { return }
        
        // Update the map to focus on the route polyline
        let bounds = GMSCoordinateBounds(path: polyline)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView.animate(with: update)
    }

    // Sets the Google Map view when it's ready
    func setGoogleMapView(_ mapView: GMSMapView) {
        self.googleMapView = mapView
    }

    // Updates the user's location when the location manager detects a change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = latestLocation.coordinate
            self.centerMapOnUser()
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
