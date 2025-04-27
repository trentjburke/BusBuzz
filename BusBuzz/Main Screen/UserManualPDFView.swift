import SwiftUI
import PDFKit

struct UserManualPDFView: View {
    var body: some View {
        PDFKitContainerUserGuide()
            .navigationTitle("User Guide")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PDFKitContainerUserGuide: View {
    let url: URL? = Bundle.main.url(forResource: "User Guide Document- BusBuzz", withExtension: "pdf")

    var body: some View {
        if let pdfURL = url {
            PDFKitView(url: pdfURL)
                .edgesIgnoringSafeArea(.bottom)
        } else {
            Text("PDF not found")
                .foregroundColor(.red)
                .bold()
        }
    }
}

struct UserGuidePDFView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserManualPDFView()
        }
    }
}
