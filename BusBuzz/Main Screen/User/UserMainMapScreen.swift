import SwiftUI
import GoogleMaps
import CoreLocation

struct UserMainMapScreen: View {
    @StateObject private var viewModel = UserMainMapScreenViewModel()
    @State private var googleMapView: GMSMapView?
    @State private var selectedRouteFromPicker: BusRoute?
    @State private var searchText: String = ""
    @State private var isPickerVisible: Bool = false

    // Fetching all available routes
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
                    
                    // Only load polyline and operators if a route is selected
                    if let route = selectedRouteFromPicker {
                        viewModel.loadPolyline(for: route)
                    }
                }
            )
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                // Ensure selectedRouteFromPicker is passed to observeOnlineBusOperators
                if let route = selectedRouteFromPicker {
                    viewModel.observeOnlineBusOperators(selectedRoute: route)  // Pass selected route here
                }
            }

            VStack {
                // Search Bar with Picker Dropdown
                VStack {
                    if availableRoutes.isEmpty {
                        Text("Select a route")
                            .foregroundColor(.gray)
                            .padding()
                            .background(AppColors.grayBackground)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    } else {
                        // Dropdown Picker for selecting route
                        Picker("Select Route", selection: $selectedRouteFromPicker) {
                            ForEach(availableRoutes, id: \.id) { route in
                                Text(route.name) // Show the name of each route
                                    .tag(route as BusRoute?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle()) // Menu style will show it as a dropdown
                        .frame(height: 50) // Adjust height for better alignment
                        .background(AppColors.grayBackground)
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }

                    // Button to find the selected route's bus
                    Button(action: {
                        if let selectedRoute = selectedRouteFromPicker {
                            // Call the logic to center the map on the selected route
                            viewModel.loadPolyline(for: selectedRoute)
                        }
                    }) {
                        Text("Find a Bus")
                            .padding()
                            .background(AppColors.buttonGreen)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding(.top, 10) // Adjust top padding to make the layout clean

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
            // Ensure selectedRouteFromPicker is passed to observeOnlineBusOperators
            if let route = selectedRouteFromPicker {
                viewModel.observeOnlineBusOperators(selectedRoute: route)  // Pass the selected route here
                viewModel.loadPolyline(for: route)
                viewModel.centerMapOnUser()
            }
        }
    }
}
