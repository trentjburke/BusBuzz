import SwiftUI

// Contact Us Screen
struct ContactUsView: View {
    var body: some View {
        VStack {
            Text("Contact Us")
                .font(.title)
                .bold()
                .padding()
            Text("We are happy to support! Write to us at:")
                .font(.body)
                .padding()
            Text("teambusbuzz@gmail.com")
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
            Spacer()
        }
        .navigationTitle("Contact Us")
    }
}
