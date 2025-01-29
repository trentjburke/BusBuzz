import SwiftUI

struct MainScreenContentView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content Area
            Color(AppColors.background)
                .edgesIgnoringSafeArea(.all) // App background spans full screen

            VStack {
                Spacer() // Push content upward
                Text("Main Content Area")
                    .font(.title)
                    .foregroundColor(.white)
            }

            // TabView with Custom Background
            ZStack {
                AppColors.grayBackground // Gray background for TabView
                    .edgesIgnoringSafeArea(.bottom)

                TabView {
                    // Hamburger Menu Screen
                    HamburgerMenuScreen()
                        .tabItem {
                            VStack {
                                Image("HamburgerIconMainScreen")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30) // Adjust icon size
                                    .foregroundColor(AppColors.background) // Set default color
                                Text("") // Empty text for spacing
                            }
                        }

                    // Main Map Screen
                    MainMapScreen()
                        .tabItem {
                            VStack {
                                Image("MainScreenMapIcon")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30) // Adjust icon size
                                    .foregroundColor(AppColors.background) // Set default color
                                Text("") // Empty text for spacing
                            }
                        }

                    // Settings Main Screen
                    SettingsMainScreen()
                        .tabItem {
                            VStack {
                                Image("SettingsIconMainScreen")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFit()
                                    .frame(width: 30, height: 30) // Adjust icon size
                                    .foregroundColor(AppColors.background) // Set default color
                                Text("") // Empty text for spacing
                            }
                        }
                }
                .accentColor(AppColors.buttonGreen) // Green for active tab
            }
            .frame(height: 70) // TabView height
        }
    }
}

// Placeholder Views for Tabs
struct HamburgerMenuScreen: View {
    var body: some View {
        ZStack {
            Text("Hamburger Menu Screen")
                .font(.title)
                .foregroundColor(.black)
        }
    }
}

struct MainMapScreen: View {
    var body: some View {
        ZStack {
            Text("Main Map Screen")
                .font(.title)
                .foregroundColor(.black)
        }
    }
}

struct SettingsMainScreen: View {
    var body: some View {
        ZStack {
            Text("Settings Main Screen")
                .font(.title)
                .foregroundColor(.black)
        }
    }
}

// Preview
struct MainScreenContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenContentView()
    }
}
