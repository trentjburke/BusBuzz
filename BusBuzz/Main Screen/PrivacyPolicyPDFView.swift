import SwiftUI
import PDFKit

struct PrivacyPolicyPDFView: View {
    var body: some View {
        VStack {
            Text("Privacy Policy")
                .font(.title)
                .bold()
                .padding(.top, 20)

            if let pdfURL = Bundle.main.url(forResource: "BussBuzz User Application Privacy Policy", withExtension: "pdf") {
                PDFKitView(url: pdfURL) // ✅ Now using the shared PDFKitView
            } else {
                Text("PDF not found")
                    .foregroundColor(.red)
                    .bold()
            }

            Spacer()
        }
        .navigationTitle("Privacy Policy")
    }
}

// Preview
struct PrivacyPolicyPDFView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyPDFView()
    }
}
