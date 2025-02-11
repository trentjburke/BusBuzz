import SwiftUI

struct ApplicationInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Application Information")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Version 1.2")
                .font(.headline)
                .foregroundColor(.white)

            Divider()
                .background(Color.white)

            Text("BusBuzz offers real-time bus tracking, up-to-date schedules, and timely push notifications, all designed to enhance your daily commute. Stay informed and plan your travel with ease, making your bus rides more efficient and convenient.")
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ApplicationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApplicationInfoView()
        }
    }
}
