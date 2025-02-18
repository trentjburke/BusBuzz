import SwiftUI

struct UserRouteSelectionScreen: View {
    @StateObject private var viewModel = UserRouteSelectionViewModel()
    @Binding var selectedRoute: BusRoute?  // ✅ Changed to @Binding to allow updates

    var body: some View {
        ZStack {
            // Ensure the blue background covers the entire screen
            AppColors.background
                .edgesIgnoringSafeArea(.top) // Ensures the blue background extends to the top

            VStack(spacing: 8) {
                // Top Search Bar for Filtering Routes
                ZStack {
                    AppColors.background
                        .edgesIgnoringSafeArea(.top)
                        .frame(height: 100)

                    VStack(spacing: 8) {
                        HStack {
                            // Search Bar for Filtering Bus Routes
                            TextField("Search bus routes...", text: $viewModel.searchQuery)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(8)
                                .frame(height: 40)
                                .background(Color.white)
                                .cornerRadius(8)
                                .onChange(of: viewModel.searchQuery) { _ in
                                    viewModel.filterRoutes()
                                }
                        }
                        .padding(.horizontal)
                    }
                }

                // Show Available Bus Routes
                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(viewModel.filteredRoutes) { route in
                            BusCard(route: route) {
                                selectedRoute = route
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .onAppear {
                    viewModel.showAllRoutes()
                }

                Spacer() 
            }

            // Gray Background for the Bottom TabBar (if required)
            VStack {
                Spacer()
                    AppColors.grayBackground
                        .frame(height: 83)
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.bottom) // Ensures it stretches across the bottom
            }
            .edgesIgnoringSafeArea(.bottom) // Ensures the tab view is fully covered
        }
        .navigationTitle("Find a Bus")
        .sheet(item: $selectedRoute) { route in
            RouteDetailsView(route: route)
                .presentationDetents([.fraction(0.6)])
        }
    }
}

// ViewModel for Route Selection
class UserRouteSelectionViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var filteredRoutes: [BusRoute] = []

    init() {
        showAllRoutes()
    }

    func showAllRoutes() {
        filteredRoutes = BusRoute.allRoutes
    }

    func filterRoutes() {
        if searchQuery.isEmpty {
            filteredRoutes = BusRoute.allRoutes
        } else {
            filteredRoutes = BusRoute.allRoutes.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}

struct UserRouteSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserRouteSelectionScreen(selectedRoute: .constant(nil))
    }
}
