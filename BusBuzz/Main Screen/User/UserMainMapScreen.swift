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
            viewModel.enableMyLocation()
        }
    }
}

struct UserMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserMainMapScreen(
            selectedRoute: BusRoute(routeNumber: "119", name: "Maharagama - Dehiwala", stops: [
                ("Maharagama", CLLocationCoordinate2D(latitude: 6.846004, longitude: 79.926111)),
                ("Boralesgamuwa lake", CLLocationCoordinate2D(latitude: 6.842679, longitude: 79.916113)),
                ("Embillawatta", CLLocationCoordinate2D(latitude: 6.842843, longitude: 79.912515)),
                ("Pirivena Junction", CLLocationCoordinate2D(latitude: 6.842021, longitude: 79.908512)),
                ("Boralesgamuwa", CLLocationCoordinate2D(latitude: 6.840506, longitude: 79.900605)),
                ("Dewalamulla", CLLocationCoordinate2D(latitude: 6.840362, longitude: 79.897837)),
                ("Bellanwila", CLLocationCoordinate2D(latitude: 6.845176, longitude: 79.889709)),
                ("Belantota", CLLocationCoordinate2D(latitude: 6.848021, longitude: 79.885879)),
                ("Nikape", CLLocationCoordinate2D(latitude: 6.849500, longitude: 79.882735)),
                ("Nedimala", CLLocationCoordinate2D(latitude: 6.849621, longitude: 79.878496)),
                ("Karagampitiya", CLLocationCoordinate2D(latitude: 6.850165, longitude: 79.872634)),
                ("Hillstreet", CLLocationCoordinate2D(latitude: 6.851187, longitude: 79.866501)),
                ("Dehiwala", CLLocationCoordinate2D(latitude: 6.851253, longitude: 79.865038))
            ])
        )
    }
}
