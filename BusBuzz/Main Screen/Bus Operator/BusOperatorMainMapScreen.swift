import SwiftUI
import GoogleMaps
import CoreLocation

struct BusOperatorMainMapScreen: View {
    @StateObject private var viewModel = BusOperatorMainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?

    var body: some View {
        ZStack {
            GoogleMapView(
                polylinePath: $viewModel.polylinePath,
                userLocation: $viewModel.busLocation,
                isUser: false,
                onMapReady: { map in
                    self.googleMapView = map
                    viewModel.setGoogleMapView(map)
                    viewModel.startTrackingBus()
                }
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.centerMapOnBus()
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
                Spacer()
                AppColors.grayBackground
                    .frame(height: 83)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            viewModel.startTrackingBus()
        }
    }
}

struct BusOperatorMainMapScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorMainMapScreen()
    }
}
