import UIKit
import GoogleMaps
import CoreLocation

// Shared Map View Controller
class MapViewController: UIViewController {
    var startLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?
    private var mapView: GMSMapView!
    private var polyline: GMSPolyline?
    private var userMarker: GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the map
        let camera = GMSCameraPosition.camera(withLatitude: startLocation?.latitude ?? 0,
                                              longitude: startLocation?.longitude ?? 0, zoom: 12)
        mapView = GMSMapView(frame: self.view.bounds, camera: camera)
        self.view.addSubview(mapView)
        
        // Add markers for start and end locations
        addStartEndMarkers()
    }
    
    // Add markers to show start and end locations
    private func addStartEndMarkers() {
        if let startLocation = startLocation {
            let startMarker = GMSMarker(position: startLocation)
            startMarker.title = "Start"
            startMarker.map = mapView
        }
        
        if let endLocation = endLocation {
            let endMarker = GMSMarker(position: endLocation)
            endMarker.title = "End"
            endMarker.map = mapView
        }
    }

    // Method to display polyline on the map
    func displayPolyline(path: GMSMutablePath) {
        if polyline == nil {
            polyline = GMSPolyline(path: path)
            polyline?.map = mapView
        } else {
            polyline?.path = path
        }
    }
    
    // Method to update the user's location marker
    func updateUserLocationMarker(userLocation: CLLocationCoordinate2D) {
        if userMarker == nil {
            userMarker = GMSMarker(position: userLocation)
            userMarker?.icon = GMSMarker.markerImage(with: .blue)
            userMarker?.map = mapView
        } else {
            userMarker?.position = userLocation
        }
    }
}
