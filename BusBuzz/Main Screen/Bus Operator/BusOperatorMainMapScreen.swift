import SwiftUI
import GoogleMaps
import CoreLocation
import FirebaseAuth

struct BusOperatorMainMapScreen: View {
    @StateObject private var viewModel = BusOperatorMainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?
    var selectedRoute: String?
    
    var body: some View {
        ZStack {
            GoogleMapView(
                polylinePath: $viewModel.polylinePath,
                userLocation: $viewModel.busLocation,
                isUser: false,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                    viewModel.startTrackingBus(for: selectedRoute)
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
                
                viewModel.loadRouteOnMap(route: route)             }
            viewModel.startTrackingBus(for: selectedRoute)
            viewModel.enableMyLocation()
        }
    }
}

struct BusOperatorMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorMainMapScreen(selectedRoute: "119 Dehiwala - Maharagama")
    }
}
