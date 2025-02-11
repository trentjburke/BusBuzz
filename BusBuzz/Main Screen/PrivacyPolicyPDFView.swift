import SwiftUI
import PDFKit

struct PrivacyPolicyPDFView: View {
    var body: some View {
        VStack {
            Divider()

            // 🔹 PDF Viewer
            if let pdfURL = Bundle.main.url(forResource: "BussBuzz User Application Privacy Policy", withExtension: "pdf") {
                PDFKitView(url: pdfURL)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("PDF not found")
                    .foregroundColor(.red)
                    .bold()
            }
        }
        .padding()
        .navigationTitle("Privacy Policy")
    }
}

struct PrivacyPolicyPDFView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { 
            PrivacyPolicyPDFView()
        }
    }
}
