import SwiftUI

struct UserMainScreenContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            // Apply blue background to the entire screen including tab area
            AppColors.background
                
            VStack(spacing: 0) {
                Spacer()

                // TabView with custom background and icon styles
                TabView(selection: $selectedTab) {
                    // Menu Tab
                    UserRouteSelectionScreen()
                        .tabItem {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedTab == 0 ? AppColors.buttonGreen : AppColors.background)
                            Text("Menu")
                        }
                        .tag(0)

                    // Map Tab
                    UserMainMapScreen()
                        .tabItem {
                            Image(systemName: "map")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedTab == 1 ? AppColors.buttonGreen : AppColors.background)
                            Text("Map")
                        }
                        .tag(1)

                    // Settings Tab
                    UserSettingsScreen()
                        .tabItem {
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(selectedTab == 2 ? AppColors.buttonGreen : AppColors.background)
                            Text("Settings")
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
