import SwiftUI

struct BusOperatorMainScreenContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            AppColors.background
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Main content area (TabView)
                TabView(selection: $selectedTab) {
                    BusOperatorTimetableScreen()
                        .tabItem {
                            Image(systemName: "list.bullet")
                        }
                        .tag(0)

                    BusOperatorMainMapScreen()
                        .tabItem {
                            Image(systemName: "map")
                        }
                        .tag(1)

                    BusOperatorSettingsScreen()
                        .tabItem {
                            Image(systemName: "gear")
                        }
                        .tag(2)
                }
                .accentColor(AppColors.buttonGreen)
                .ignoresSafeArea(edges: .bottom)

                // Add spacing at the bottom of the map (before the tab view)
                .frame(maxHeight: .infinity)
                .edgesIgnoringSafeArea(.bottom) // Remove map content from bottom if necessary
            }
            .edgesIgnoringSafeArea(.top) // Make sure the top part isn't affected

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)  // Hide navigation bar
    }
}

struct BusOperatorMainScreenContentView_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorMainScreenContentView()
    }
}
