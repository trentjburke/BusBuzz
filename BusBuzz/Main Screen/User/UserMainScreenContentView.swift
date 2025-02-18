import SwiftUI

struct UserMainScreenContentView: View {
    @State private var selectedTab = 0
    @State private var selectedRoute: BusRoute? = nil  // ✅ Added selectedRoute to handle navigation

    var body: some View {
        ZStack {
            // Apply blue background to the entire screen including tab area
            AppColors.background

            VStack(spacing: 0) {
                Spacer()

                // TabView with custom background and icon styles
                TabView(selection: $selectedTab) {
                    // Menu Tab
                    UserRouteSelectionScreen(selectedRoute: $selectedRoute)  // ✅ Pass selectedRoute to update when a user selects a route
                        .tabItem {
                            VStack {
                                Image(systemName: "list.bullet")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text("Menu")
                            }
                        }
                        .tag(0)

                    // Map Tab
                    UserMainMapScreen(selectedRoute: selectedRoute ?? BusRoute.defaultRoute)  // ✅ Ensuring a valid route
                        .tabItem {
                            VStack {
                                Image(systemName: "map")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text("Map")
                            }
                        }
                        .tag(1)

                    // Settings Tab
                    UserSettingsScreen()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                Text("Settings")
                            }
                        }
                        .tag(2)
                }
                .accentColor(AppColors.buttonGreen)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct UserMainScreenContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserMainScreenContentView()
    }
}
