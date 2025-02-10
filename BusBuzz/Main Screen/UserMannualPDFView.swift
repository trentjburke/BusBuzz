import SwiftUI
import PDFKit

struct UserManualPDFView: View {
    var body: some View {
        PDFViewer(pdfName: "BussBuzz User Application Privacy Policy.pdf")
    }
}
