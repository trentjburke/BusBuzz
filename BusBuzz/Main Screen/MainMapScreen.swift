import SwiftUI

struct MainMapScreenView: View {
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            Text("Main Map Screen")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct MainMapScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapScreenView()
    }
}
