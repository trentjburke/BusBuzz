import SwiftUI
import GoogleMaps
import CoreLocation

struct BusOperatorMainMapScreen: View {
    @StateObject private var viewModel = BusOperatorMainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?
    var selectedRoute: String?  // Route passed from the previous screen
    
    var body: some View {
        ZStack {
            GoogleMapView(
                polylinePath: $viewModel.polylinePath,
                userLocation: $viewModel.busLocation,
                isUser: false,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                    viewModel.startTrackingBus(for: selectedRoute) // Start tracking bus for the selected route
                }
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
            }

            // Gray background for the bottom tab view
            VStack {
                Spacer()
                AppColors.grayBackground
                    .frame(height: 83)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            if let route = selectedRoute {
                // Handle route-specific logic (for example, showing the polyline or markers for this route)
                viewModel.loadRouteOnMap(route: route) // Update the map view based on the selected route
            }
            viewModel.startTrackingBus(for: selectedRoute) // Start tracking the bus for the selected route
            viewModel.enableMyLocation()
        }
    }
}

struct BusOperatorMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorMainMapScreen(selectedRoute: "119 Dehiwala - Maharagama")
    }
}
