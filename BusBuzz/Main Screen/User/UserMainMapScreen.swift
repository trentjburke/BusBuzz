import SwiftUI
import GoogleMaps

struct UserMainMapScreen: View {
    @StateObject private var viewModel = MainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?

    var body: some View {
        ZStack {
            GoogleMapView(
                polylinePath: $viewModel.polylinePath,
                userLocation: $viewModel.userLocation,
                isUser: true,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                }
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
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
        }
        .onAppear {
            viewModel.fetchRoutes()  // Ensure this method is called to fetch the routes
        }
    }
}
