import SwiftUI
import PDFKit

struct AuthoritiesPDFView: View {
    var body: some View {
        VStack {
            if let pdfURL = Bundle.main.url(forResource: "BussBuzz Emergency Services Contact List", withExtension: "pdf") {
                PDFKitView(url: pdfURL)
                    .background(Color.white) 
            } else {
                Text("PDF not found")
                    .foregroundColor(.red)
                    .bold()
                    .padding()
            }
        }
        .navigationTitle("Contact Authorities")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct AuthoritiesPDFView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthoritiesPDFView()
        }
    }
}
