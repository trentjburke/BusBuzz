import SwiftUI

struct UserRouteSelectionScreen: View {
    @StateObject private var viewModel = UserRouteSelectionViewModel()
    @State private var selectedRoute: BusRoute? = nil // Stores the selected route for modal

    var body: some View {
        VStack(spacing: 8) {
            // 🔹 Top Search Bar for Filtering Routes
            ZStack {
                AppColors.background
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 100)

                VStack(spacing: 8) {
                    HStack {
                        // 🔹 Search Bar for Filtering Bus Routes
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

            // 🔹 Available Bus Routes (Filtered Results)
            ScrollView {
                VStack(spacing: 6) {
                    ForEach(viewModel.filteredRoutes) { route in
                        BusCard(route: route) {
                            selectedRoute = route // 🔹 Clicking a route opens modal
                        }
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.showAllRoutes() // ✅ Shows all routes when app opens
            }

            Spacer()
        }
        .background(AppColors.background)
        .navigationTitle("Find a Bus")
        .sheet(item: $selectedRoute) { route in
            RouteDetailsView(route: route) // 🔹 Calls the modal view
                .presentationDetents([.fraction(0.6)]) // Modal height set to 60%
        }
    }
}

// MARK: - ViewModel for Route Selection
class UserRouteSelectionViewModel: ObservableObject {
    @Published var searchQuery: String = "" // 🔹 User's input for filtering
    @Published var filteredRoutes: [BusRoute] = []

    init() {
        showAllRoutes() // ✅ Show all routes on load
    }

    // ✅ Ensures all routes are shown when the app opens
    func showAllRoutes() {
        filteredRoutes = BusRoute.allRoutes
    }

    // 🔹 Filters routes based on search input
    func filterRoutes() {
        if searchQuery.isEmpty {
            filteredRoutes = BusRoute.allRoutes
        } else {
            filteredRoutes = BusRoute.allRoutes.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}

// MARK: - Preview
struct UserRouteSelectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        UserRouteSelectionScreen()
    }
}
