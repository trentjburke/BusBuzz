import SwiftUI

struct ContactUsView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Contact Us")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            
            Text("We are happy to support! Write to us at:")
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

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

            Divider()

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
