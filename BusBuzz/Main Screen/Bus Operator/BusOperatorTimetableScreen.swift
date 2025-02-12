import SwiftUI

struct BusOperatorTimetableScreen: View {
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            Text("Timetable Screen")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

struct BusOperatorTimetableScreen_Previews: PreviewProvider {
    static var previews: some View {
        BusOperatorTimetableScreen()
    }
}
