import SwiftUI

struct ContactUsView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            // 🔹 Centered "Contact Us" Title
            Text("Contact Us")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            // 🔹 Contact Information
            Text("We are happy to support! Write to us at:")
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            // 🔹 Email Address (Clickable)
            Button(action: {
                if let url = URL(string: "mailto:teambusbuzz@gmail.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("teambusbuzz@gmail.com")
                    .font(.headline)
                    .foregroundColor(AppColors.buttonGreen)
                    .underline()
            }
            .padding(.bottom, 10)

            Divider() // 🔹 Adds a separation line

            Spacer()
        }
        .padding()
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactUsView()
        }
    }
}
