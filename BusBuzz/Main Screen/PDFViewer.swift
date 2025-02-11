import SwiftUI
import PDFKit

struct PDFViewer: View {
    let pdfName: String

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Close") {
                    // Dismiss the view
                }
                .padding()
            }

            if let pdfURL = Bundle.main.url(forResource: pdfName, withExtension: nil) {
                PDFKitView(url: pdfURL)
            } else {
                Text("PDF not found")
                    .foregroundColor(.red)
                    .bold()
            }
        }
    }
}
