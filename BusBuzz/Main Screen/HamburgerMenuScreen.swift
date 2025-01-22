import SwiftUI

struct HamburgerMenuScreenView: View {
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            Text("Hamburger Menu Screen")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct HamburgerMenuScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HamburgerMenuScreenView()
    }
}
