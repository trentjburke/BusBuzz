import SwiftUI

struct RouteDetailsView: View {
    var route: BusRoute
    @State private var isReversed: Bool = false
    @State private var currentBusStopIndex: Int = 3  // Example: Bus is at index 3 (Dynamic Later)
    @State private var userLocationIndex: Int = 5    // Example: User is at index 5 (Dynamic Later)
    @Environment(\.presentationMode) var presentationMode // For Closing Modal

    var body: some View {
        VStack {
            // 🔹 Header Section with Swap, Title, and Close(X) Button
            HStack {
                // 🔹 Swap Route Button
                Button(action: { isReversed.toggle() }) {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(AppColors.buttonGreen)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }

                HStack {
                    Text(route.routeNumber)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppColors.buttonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Text(isReversed ? getReversedRouteName() : getCleanRouteName())
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.leading, 8)

                Spacer()

                // Close Button (X) at the top right
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 15))

            Divider()

            // Scrollable Bus Stop List with Aligned Dots
            ScrollView {
                VStack(alignment: .leading) {
                    let stops = isReversed ? route.stops.reversed() : route.stops
                    ForEach(stops.indices, id: \.self) { index in
                        HStack(alignment: .center) {
                            // 🔹 Vertical Line & Stop Dots (Aligned)
                            VStack(spacing: 0) {
                                if index > 0 {
                                    Rectangle()
                                        .fill(AppColors.grayBackground)
                                        .frame(width: 4, height: 15) // Connects upper line
                                }

                                Circle()
                                    .fill(index == currentBusStopIndex ? AppColors.buttonGreen : AppColors.grayBackground)
                                    .frame(width: 10, height: 10) // Stop Indicator

                                if index < stops.count - 1 {
                                    Rectangle()
                                        .fill(AppColors.grayBackground)
                                        .frame(width: 4, height: 15) // Connects lower line
                                }
                            }
                            .frame(width: 20) // Ensures consistent alignment

                            // 🔹 Bus Stop Name (Left-Aligned)
                            Text(stops[index])
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.leading, 8)

                            Spacer()

                            if index == currentBusStopIndex {
                                Image(systemName: "bus.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 20))
                                    .transition(.slide)
                            }

                            if index == userLocationIndex {
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.yellow)
                                    .font(.system(size: 20))
                                    .transition(.slide)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding(.horizontal)
            }
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()

            // Track Bus Button (Now at the bottom)
            Button(action: {
                //Implement tracking bus logic here
            }) {
                Text("Track Bus")
                    .font(.system(size: 16, weight: .bold))
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(AppColors.buttonGreen)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
            }
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
    }

    // Function to reverse route names dynamically (Fixes Issue)
    func getReversedRouteName() -> String {
        switch route.routeNumber {
        case "119":
            return isReversed ? "Dehiwala to Maharagama" : "Maharagama to Dehiwala"
        case "120":
            return isReversed ? "Colombo to Piliyandala" : "Piliyandala to Colombo"
        case "Ex01":
            return isReversed ? "Galle to Makumbura" : "Makumbura to Galle"
        default:
            return route.name
        }
    }

    // Function to REMOVE Duplicate Route Number (Fix for the issue)
    func getCleanRouteName() -> String {
        let components = route.name.components(separatedBy: " - ")
        if components.count == 2 {
            return components[1].trimmingCharacters(in: .whitespaces)
        }
        return route.name
    }
}
