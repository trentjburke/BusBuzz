import SwiftUI

struct SettingsMainScreenView: View {
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            Text("Settings Main Screen")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct SettingsMainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMainScreenView()
    }
}
