import SwiftUI
import CoreLocation
import GoogleMaps

// ViewModel for handling map logic
class UserMainMapScreenViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedRoute: String? = nil
    @Published var polylinePath: GMSMutablePath?
    
    private var locationManager = CLLocationManager()

    // **Updated Start & End Coordinates**
    let startLocation = CLLocationCoordinate2D(latitude: 6.846088884675021, longitude: 79.92613078770619) // **Maharagama**
    let endLocation = CLLocationCoordinate2D(latitude: 6.8512, longitude: 79.8650) // **Dehiwala**

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.first else { return }
        userLocation = newLocation.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    // **Fetch Route from Google Directions API**
    func fetchRoute() {
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(startLocation.latitude),\(startLocation.longitude)&destination=\(endLocation.latitude),\(endLocation.longitude)&key=AIzaSyB1ymE_w2NaWXIhZvSe7KVUScuPtcjRCU4"

        guard let url = URL(string: directionsURL) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching route: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("API Response: \(jsonResponse)")  // **Debugging API Response**

                let decoder = JSONDecoder()
                let directionsResponse = try decoder.decode(DirectionsResponse.self, from: data)
                
                if let routes = directionsResponse.routes, let route = routes.first {
                    self.decodePolyline(encodedPolyline: route.overview_polyline.points)
                } else {
                    print("No routes found in response")
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
            self.polylinePath = GMSMutablePath(path: path)
        } else {
            print("Failed to decode polyline")
        }
    }
}

// **API Response Models**
struct DirectionsResponse: Codable {
    let routes: [Route]?
}

struct Route: Codable {
    let overview_polyline: OverviewPolyline
}

struct OverviewPolyline: Codable {
    let points: String
}

// **Main View**
struct UserMainMapScreen: View {
    @StateObject private var viewModel = UserMainMapScreenViewModel()

    var body: some View {
        ZStack {
            // Google Map
            GoogleMapView(polylinePath: $viewModel.polylinePath, userLocation: $viewModel.userLocation, startLocation: viewModel.startLocation, endLocation: viewModel.endLocation)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // **Accuracy Button**
                HStack {
                    Spacer()
                    Button(action: {
                        NotificationCenter.default.post(name: NSNotification.Name("CenterMapOnUser"), object: nil)
                    }) {
                        Image("AccuracyIcon")  // Use your actual Accuracy icon
                            .resizable()
                            .frame(width: 37.5, height: 37.5) // **Reduced by 25%**
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            viewModel.fetchRoute()
        }
    }
}

// **Google Maps View**
struct GoogleMapView: UIViewControllerRepresentable {
    @Binding var polylinePath: GMSMutablePath?
    @Binding var userLocation: CLLocationCoordinate2D?
    var startLocation: CLLocationCoordinate2D
    var endLocation: CLLocationCoordinate2D

    func makeUIViewController(context: Context) -> UIViewController {
        let mapViewController = MapViewController()
        mapViewController.startLocation = startLocation
        mapViewController.endLocation = endLocation
        return mapViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let mapVC = uiViewController as? MapViewController {
            if let polylinePath = polylinePath {
                mapVC.displayPolyline(path: polylinePath)
            }
            if let userLocation = userLocation {
                mapVC.updateUserLocationMarker(userLocation: userLocation)
            }
        }
    }
}

// **Map View Controller**
class MapViewController: UIViewController {
    var mapView: GMSMapView!
    var locationMarker: GMSMarker?
    var currentRoutePolyline: GMSPolyline?
    var startLocation: CLLocationCoordinate2D!
    var endLocation: CLLocationCoordinate2D!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()

        // **Listen for Accuracy button tap to center on user**
        NotificationCenter.default.addObserver(self, selector: #selector(centerMapOnUser), name: NSNotification.Name("CenterMapOnUser"), object: nil)
    }

    func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: startLocation.latitude, longitude: startLocation.longitude, zoom: 14.0)
        mapView = GMSMapView(frame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)

        // **Add Red Markers for Start & End Points**
        addMarker(at: startLocation, title: "Start - Maharagama", isRed: true)
        addMarker(at: endLocation, title: "End - Dehiwala", isRed: true)
    }

    func addMarker(at coordinate: CLLocationCoordinate2D, title: String, isRed: Bool) {
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = title
        marker.icon = isRed ? GMSMarker.markerImage(with: .red) : GMSMarker.markerImage(with: .blue)
        marker.map = mapView
    }

    // **Update User's Location with Stickman Icon**
    func updateUserLocationMarker(userLocation: CLLocationCoordinate2D) {
        if locationMarker == nil {
            locationMarker = GMSMarker()
            locationMarker?.icon = UIImage(named: "StickMan")  // Use your Stickman icon
            locationMarker?.title = "You are here"
        }
        locationMarker?.position = userLocation
        locationMarker?.map = mapView
    }

    // **Handle Accuracy Button Click**
    @objc func centerMapOnUser() {
        guard let location = locationMarker?.position else { return }
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 14.0)
        mapView.animate(to: camera)
    }

    func displayPolyline(path: GMSMutablePath) {
        if currentRoutePolyline != nil {
            currentRoutePolyline?.map = nil // Remove previous polyline
        }

        currentRoutePolyline = GMSPolyline(path: path)
        currentRoutePolyline?.strokeWidth = 7.0  // **Increased width**
        currentRoutePolyline?.strokeColor = .blue
        currentRoutePolyline?.map = mapView
    }
}

// **Preview**
struct UserMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserMainMapScreen()
    }
}
