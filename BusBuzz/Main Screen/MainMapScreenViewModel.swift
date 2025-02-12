import SwiftUI
import GoogleMaps
import CoreLocation

class MainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var polylinePath: GMSPath?
    
    private var locationManager = CLLocationManager()
    private var googleMapView: GMSMapView?

    let startLocation = CLLocationCoordinate2D(latitude: 6.846088884675021, longitude: 79.92613078770619)  // **Maharagama**
    let endLocation = CLLocationCoordinate2D(latitude: 6.8512, longitude: 79.8650)  // **Dehiwala**

    let route2Start = CLLocationCoordinate2D(latitude: 6.839114621203832, longitude: 79.97635657102828)  // **Makumbura**
    let route2End = CLLocationCoordinate2D(latitude: 6.032418904032479, longitude: 80.21488188991984)  // **Galle**

    let route3Start = CLLocationCoordinate2D(latitude: 6.8001102233793365, longitude: 79.9415064597752)  // **Kesbewa**
    let route3End = CLLocationCoordinate2D(latitude: 6.9344795600214475, longitude: 79.85462959050028)  // **Pettah**

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

    // **Fetching Routes and Polylines**
    func fetchRoutes() {
        // Default Route (Maharagama to Dehiwala)
        fetchRoute(from: startLocation, to: endLocation)

        // Additional Routes (Makumbura to Galle, Kesbewa to Pettah)
        fetchRoute(from: route2Start, to: route2End)
        fetchRoute(from: route3Start, to: route3End)
    }

    private func fetchRoute(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&key=\(googleMapsAPIKey)"
        
        guard let url = URL(string: directionsURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
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
                    }
                }
            } catch {
                print("Failed to decode directions response: \(error)")
            }
        }
        task.resume()
    }

    // **Decoding Polyline**
    func decodePolyline(encodedPolyline: String) {
        if let path = GMSPath(fromEncodedPath: encodedPolyline) {
            DispatchQueue.main.async {
                self.polylinePath = path
            }
        } else {
            print("Failed to decode polyline")
        }
    }

    func centerMapOnUser() {
        guard let location = userLocation, let mapView = googleMapView else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        mapView.animate(to: camera)
    }

    func setGoogleMapView(_ mapView: GMSMapView) {
        self.googleMapView = mapView
    }

    // **Update User Location**
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = latestLocation.coordinate
            self.centerMapOnUser()
        }
    }
}

struct DirectionsResponse: Codable {
    let routes: [Route]?
}

struct Route: Codable {
    let overview_polyline: OverviewPolyline
}

struct OverviewPolyline: Codable {
    let points: String
}
