import SwiftUI
import GoogleMaps

struct UserMainMapScreen: View {
    @StateObject private var viewModel = MainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?

    var body: some View {
        ZStack {
            // Map View
            GoogleMapView(
                polylinePath: $viewModel.polylinePath,
                userLocation: $viewModel.userLocation,
                isUser: true,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                }
            )
            .edgesIgnoringSafeArea(.top) // To ensure the map is full-screen above the tab view
            
            VStack {
                Spacer() // To push the button upward so that the tab view is not covered
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.centerMapOnUser()
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

            // Gray background for the bottom tab view
            VStack {
                Spacer() // Make space for the tab view at the bottom
                AppColors.grayBackground
                    .frame(height: 83) // Height of the bottom tab view
                    .edgesIgnoringSafeArea(.bottom) // Make sure it extends to the bottom edge of the screen
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            viewModel.fetchRoutes()  // Ensure this method is called to fetch the routes
        }
    }
}

struct UserMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserMainMapScreen()
    }
}
