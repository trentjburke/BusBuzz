import SwiftUI

struct SettingsMainScreen: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea() // Background color
            Text("Settings Screen")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }
}

struct SettingsMainScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMainScreen()
    }
}
