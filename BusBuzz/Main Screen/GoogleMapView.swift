import SwiftUI
import GoogleMaps

struct GoogleMapView: UIViewRepresentable {
    @Binding var polylinePath: GMSPath?
    @Binding var userLocation: CLLocationCoordinate2D?
    var isUser: Bool
    var onMapReady: ((GMSMapView) -> Void)?

    func makeUIView(context: Context) -> GMSMapView {
        let mapView = GMSMapView()
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = false

        DispatchQueue.main.async {
            onMapReady?(mapView)
        }

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        context.coordinator.addRoutePolyline(mapView: uiView, polylinePath: polylinePath)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        var routePolyline: GMSPolyline?

        init(_ parent: GoogleMapView) {
            self.parent = parent
        }

        // **Add Polyline**
        func addRoutePolyline(mapView: GMSMapView, polylinePath: GMSPath?) {
            guard let path = polylinePath else { return }

            if routePolyline != nil {
                routePolyline?.map = nil  // Remove previous polyline
            }

            routePolyline = GMSPolyline(path: path)
            routePolyline?.strokeColor = .blue
            routePolyline?.strokeWidth = 5.0
            routePolyline?.map = mapView
        }

        // **Handle Red Markers at Start & End**
        func addMarkers(mapView: GMSMapView, start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) {
            let markerStart = GMSMarker(position: start)
            markerStart.title = "Start"
            markerStart.icon = GMSMarker.markerImage(with: .red)
            markerStart.map = mapView

            let markerEnd = GMSMarker(position: end)
            markerEnd.title = "End"
            markerEnd.icon = GMSMarker.markerImage(with: .red)
            markerEnd.map = mapView
        }
    }
}
