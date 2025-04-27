import SwiftUI

struct SettingsRow: View {
    var iconName: String  
    var title: String
    var textColor: Color = AppColors.background
    var destination: AnyView? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        if let destination = destination {
            NavigationLink(destination: destination) {
                rowContent
            }
        } else if let action = action {
            Button(action: action) {
                rowContent
            }
        }
    }

    private var rowContent: some View {
        HStack {
            
            Image(iconName)
                .resizable()
                .frame(width: 35, height: 35)
                .padding(.trailing, 10)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(textColor) 

            Spacer()

            if destination != nil {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(AppColors.grayBackground)
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
