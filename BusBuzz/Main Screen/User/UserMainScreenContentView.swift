import SwiftUI

struct UserMainScreenContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            AppColors.background
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                Spacer()

                TabView(selection: $selectedTab) {
        
                    UserRouteSelectionScreen()
                        .tabItem {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("Menu")
                        }
                        .tag(0)

                    // Main Map Screen
                    UserMainMapScreen()
                        .tabItem {
                            Image(systemName: "map")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("Map")
                        }
                        .tag(1)

                    // Settings Screen
                    UserSettingsScreen()
                        .tabItem {
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                            Text("Settings")
                        }
                        .tag(2)
                }
                .accentColor(AppColors.buttonGreen)
                .ignoresSafeArea(edges: .bottom)
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
