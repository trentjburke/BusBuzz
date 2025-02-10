import SwiftUI
import PDFKit

struct AuthoritiesPDFView: View {
    var body: some View {
        PDFViewer(pdfName: "BussBuzz Emergency Services Contact List.pdf")
    }
}
