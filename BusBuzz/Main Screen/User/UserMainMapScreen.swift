import SwiftUI
import GoogleMaps
import CoreLocation

struct UserMainMapScreen: View {
    @StateObject private var viewModel = UserMainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?
    @State private var selectedRouteFromPicker: BusRoute? = BusRoute.allRoutes.first
    
    var availableRoutes: [BusRoute] {
        return BusRoute.allRoutes
    }
    
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
                    
                    // Load polyline and observe operators for the selected route
                    if let route = selectedRouteFromPicker {
                        viewModel.loadPolyline(for: route)
                        viewModel.observeOnlineBusOperators(selectedRoute: route)
                    }
                }
            )
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                HStack {
                    // Picker for selecting a route
                    Picker("Select Route", selection: $selectedRouteFromPicker) {
                        ForEach(availableRoutes, id: \.id) { route in
                            Text(route.name)
                                .tag(route as BusRoute?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(height: 50)
                    .frame(maxWidth: .infinity) // Sucess: Ensure it takes available space
                    .background(AppColors.grayBackground)
                    .cornerRadius(8)
                    
                    // Find Bus Button
                    Button(action: {
                        if let selectedRoute = selectedRouteFromPicker {
                            viewModel.loadPolyline(for: selectedRoute)
                            viewModel.observeOnlineBusOperators(selectedRoute: selectedRoute)
                        }
                    }) {
                        Text("Find a Bus")
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(AppColors.buttonGreen)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                if (viewModel.selectedBusId != nil) {
                    VStack(spacing: 8) {
                        Text("\(viewModel.selectedBusType) • \(viewModel.selectedLicensePlate)")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text(viewModel.etaText)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.background.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                
                VStack {
                    Spacer()
                    AppColors.grayBackground
                        .frame(height: 83)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .onChange(of: selectedRouteFromPicker) { newRoute in
                if let selectedRoute = newRoute {
                    viewModel.updateSelectedRoute(selectedRoute)
                    viewModel.loadPolyline(for: selectedRoute)
                }
            }
        }
    }
}
