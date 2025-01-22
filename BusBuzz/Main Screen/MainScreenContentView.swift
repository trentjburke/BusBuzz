import SwiftUI

struct MainScreenContentView: View {
    var body: some View {
        TabView {
            // Example Screen for Hamburger Menu
            HamburgerMenuScreen()
                .tabItem {
                    Image("HamburgerIconMainScreen")
                    Text("Hamburger")
                }
        }
    }
}

// Placeholder View for Hamburger Menu Screen
struct HamburgerMenuScreen: View {
    var body: some View {
        Text("Hamburger Menu Screen")
            .font(.title)
            .foregroundColor(.black)
    }
}

// Preview
struct MainScreenContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenContentView()
    }
}
