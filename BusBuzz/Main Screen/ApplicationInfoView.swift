import SwiftUI

struct ApplicationInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Application Info")
                .font(.title)
                .bold()
                .padding(.top, 20)

            Text("Version 1.2")
                .font(.headline)
                .foregroundColor(.gray)

            Divider() // Adds a separation line

            Text("BusBuzz is designed to provide real-time bus tracking, schedules, and push notifications for user convenience.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
        .navigationTitle("Application Info")
    }
}

// Preview
struct ApplicationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ApplicationInfoView()
        }
    }
}
