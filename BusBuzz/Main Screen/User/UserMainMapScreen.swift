import SwiftUI
import GoogleMaps
import CoreLocation

struct UserMainMapScreen: View {
    @StateObject private var viewModel = UserMainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?
    var selectedRoute: BusRoute

    var body: some View {
        ZStack {
            // Google Map view with route polyline and user location
            GoogleMapView(
                polylinePath: $viewModel.polylinePath,
                userLocation: $viewModel.userLocation,
                isUser: false,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                    viewModel.loadPolyline(for: selectedRoute)
                }
            )
            .edgesIgnoringSafeArea(.top)

            VStack {
                Spacer()
            }

            // Gray background for bottom tab view
            VStack {
                Spacer()
                AppColors.grayBackground
                    .frame(height: 83)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            // Fetch route details on appearance and set up map
            viewModel.loadPolyline(for: selectedRoute)
            viewModel.centerMapOnUser()
        }
    }
}


