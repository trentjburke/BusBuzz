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
                            VStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.large)
                                Text("Schedule") 
                            }
                        }
                        .tag(0)

                    BusOperatorMainMapScreen()
                        .tabItem {
                            VStack {
                                Image(systemName: "location.circle")
                                    .imageScale(.large)
                                Text("Location")
                            }
                        }
                        .tag(1)

                    BusOperatorSettingsScreen()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear")
                                    .imageScale(.large)
                                Text("Settings")
                            }
                        }
                        .tag(2)
                }
                .accentColor(AppColors.buttonGreen)
                .ignoresSafeArea(edges: .bottom)
                .frame(maxHeight: .infinity)

                .edgesIgnoringSafeArea(.bottom)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct BusOperatorMainScreenContentView_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorMainScreenContentView()
    }
}
