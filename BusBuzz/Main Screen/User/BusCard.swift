import SwiftUI

struct BusCard: View {
    var route: BusRoute
    var onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                // Route Number as Badge
                Text(route.name.split(separator: " ")[0])
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 50, height: 30)
                    .background(AppColors.buttonGreen)
                    .cornerRadius(8)

                // Route Name
                Text(route.name.split(separator: "-")[1].trimmingCharacters(in: .whitespaces))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(AppColors.grayBackground)
                    .cornerRadius(8)

                Spacer()
                
                //  Right Chevron Icon
                Image(systemName: "chevron.right.circle.fill")
                    .foregroundColor(AppColors.buttonGreen)
                    .frame(width: 25, height: 25)
            }
            .padding(10)
            .background(AppColors.grayBackground)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}
