import SwiftUI

struct BusOperatorHamburgerMenuScreen: View {
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            Text("Hamburger Menu Screen")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct BusOperatorHamburgerMenuScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorHambdurgerMenuScreen()
    }
}

