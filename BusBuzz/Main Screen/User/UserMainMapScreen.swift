import SwiftUI
import GoogleMaps

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
                isUser: true,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                    viewModel.fetchSelectedRoute(for: selectedRoute) // Fetch selected route for map display
                }
            )
            .edgesIgnoringSafeArea(.top)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    // Center map on user location only
                    Button(action: {
                        viewModel.centerMapOnUser() // Focus on user's location
                    }) {
                        Image("AccuracyIcon")
                            .resizable()
                            .frame(width: 37.5, height: 37.5)
                            .background(Color.white.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 50)
                }
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
            viewModel.fetchSelectedRoute(for: selectedRoute)
        }
    }
}

struct UserMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserMainMapScreen(
            selectedRoute: BusRoute(routeNumber: "119", name: "Maharagama - Dehiwala", stops: ["Maharagama", "Nugegoda", "Dehiwala"])
        )
    }
}
