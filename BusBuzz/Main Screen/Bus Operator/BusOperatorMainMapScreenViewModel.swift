import SwiftUI
import GoogleMaps
import CoreLocation

class BusOperatorMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var busLocation: CLLocationCoordinate2D?
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

    // ✅ Fetch real-time bus location
    func startTrackingBus() {
        locationManager.startUpdatingLocation()
    }

    // ✅ Center the map on the bus
    func centerMapOnBus() {
        guard let location = busLocation, let mapView = googleMapView else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        mapView.animate(to: camera)
    }

    func setGoogleMapView(_ mapView: GMSMapView) {
        self.googleMapView = mapView
    }

    // ✅ Real-time updates when the bus moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.busLocation = latestLocation.coordinate
            self.centerMapOnBus()
        }
    }
}
