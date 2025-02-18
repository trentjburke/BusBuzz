import SwiftUI

struct RouteDetailsView: View {
    var route: BusRoute
    @State private var isReversed: Bool = false
    @State private var currentBusStopIndex: Int = 3  // Example: Bus is at index 3 (Dynamic Later)
    @State private var userLocationIndex: Int = 5    // Example: User is at index 5 (Dynamic Later)
    @State private var navigateToMap = false
    @Environment(\.presentationMode) var presentationMode // For Closing Modal

    // Define two sets of buses for the routes (Makumbura to Galle and Galle to Makumbura)
    @State private var buses: [Bus] = [
        Bus(id: UUID(), licensePlate: "NB-2586", busType: "Highway Bus", time: "8:30 AM", status: "Onboarding", finalDestination: "Galle"),
        Bus(id: UUID(), licensePlate: "KO-2797", busType: "Highway Bus", time: "9:15 AM", status: "Scheduled", finalDestination: "Galle"),
        Bus(id: UUID(), licensePlate: "TL-2776", busType: "Highway Bus", time: "10:00 AM", status: "Scheduled", finalDestination: "Galle")
    ]

    // Hardcoded swapped bus route cards for Galle to Makumbura
    @State private var reversedBuses: [Bus] = [
        Bus(id: UUID(), licensePlate: "TU-1592", busType: "Highway Bus", time: "8:30 AM", status: "Onboarding", finalDestination: "Makumbura"),
        Bus(id: UUID(), licensePlate: "AT-5679", busType: "Highway Bus", time: "9:15 AM", status: "Scheduled", finalDestination: "Makumbura"),
        Bus(id: UUID(), licensePlate: "YP-3751", busType: "Highway Bus", time: "10:00 AM", status: "Scheduled", finalDestination: "Makumbura")
    ]

    var body: some View {
        VStack {
            // 🔹 Header Section with Swap, Title, and Close(X) Button
            HStack {
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

            // Date moved up
            if route.routeNumber == "Ex01" {
                // Display bus cards for Ex01 Makumbura to Galle
                VStack {
                    Text("24th March 2025")
                        .font(.headline)
                        .foregroundColor(AppColors.buttonGreen)
                        .padding(.top, 5)  // Pushed more to the top

                    ScrollView {
                        VStack {
                            ForEach(isReversed ? reversedBuses : buses) { bus in
                                BusRouteCard(bus: bus)
                                    .padding(.horizontal)
                                    .padding(.bottom, 4) // Reduced the gap between cards
                            }
                        }
                    }
                }
            } else {
                // Default scrollable bus stop list for other routes
                ScrollView {
                    VStack(alignment: .leading) {
                        let stops = isReversed ? route.stops.reversed() : route.stops
                        ForEach(stops.indices, id: \.self) { index in
                            HStack {
                                Text(stops[index])
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .padding(.leading, 8)
                                Spacer()
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal)
                }
                .background(AppColors.background)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()
            }

            // Track Bus Button
            Button(action: {
                navigateToMap = true
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
            .background(
                NavigationLink("", destination: UserMainMapScreen(selectedRoute: route), isActive: $navigateToMap)
                    .hidden()
            )
        }
        .background(AppColors.background.edgesIgnoringSafeArea(.all))
    }

    // Hardcoded bus route cards for Ex01 Makumbura to Galle
    var busRouteCards: [Bus] {
        return [
            Bus(id: UUID(), licensePlate: "NB-2586", busType: "Highway Bus", time: "8:30 AM", status: "Onboarding", finalDestination: "Galle"),
            Bus(id: UUID(), licensePlate: "KO-2797", busType: "Highway Bus", time: "9:15 AM", status: "Scheduled", finalDestination: "Galle"),
            Bus(id: UUID(), licensePlate: "TL-2776", busType: "Highway Bus", time: "10:00 AM", status: "Scheduled", finalDestination: "Galle")
        ]
    }

    // Define Bus Route Card UI
    struct BusRouteCard: View {
        var bus: Bus

        var body: some View {
            VStack {
                HStack {
                    Text("Licence plate: \(bus.licensePlate)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.background) // Blue text
                    Spacer()
                }
                .padding(.bottom, 2)

                HStack {
                    Text("Bus Type: \(bus.busType)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.background) // Blue text
                    Spacer()
                }
                .padding(.bottom, 2)

                HStack {
                    Text("Final destination: \(bus.finalDestination)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.background) // Blue text
                    Spacer()
                }
                .padding(.bottom, 2)

                HStack {
                    Text("Time: \(bus.time)")
                        .font(.subheadline)
                        .foregroundColor(AppColors.background) // Blue text
                    Spacer()
                }
                .padding(.bottom, 2)

                // Status and Dot aligned to top-right
                HStack {
                    Spacer()
                    HStack {
                        Text(bus.status)
                            .font(.caption)
                            .foregroundColor(statusColor(for: bus.status))

                        // Status Dot
                        Circle()
                            .fill(statusColor(for: bus.status))
                            .frame(width: 12, height: 12)
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 0).fill(AppColors.grayBackground)) // No rounded edges
                }
            }
            .frame(maxWidth: .infinity) // Makes the card bigger
            .padding(.vertical, 4)  // Reduced gap between the cards
            .background(RoundedRectangle(cornerRadius: 0).fill(AppColors.grayBackground)) // Card background color (No rounded edges)
        }

        func statusColor(for status: String) -> Color {
            switch status {
            case "Onboarding":
                return Color.green
            case "Scheduled":
                return Color.yellow
            default:
                return Color.red
            }
        }
    }

    // Define Bus model
    struct Bus: Identifiable {
        var id: UUID
        var licensePlate: String
        var busType: String
        var time: String
        var status: String
        var finalDestination: String
        var busRoute: String = "Ex-01 Makumbura-Galle"
    }

    // Helper methods to determine reversed name and cleaned route name
    func getReversedRouteName() -> String {
        switch route.routeNumber {
        case "119":
            return isReversed ? "Dehiwala to Maharagama" : "Maharagama to Dehiwala"
        case "120":
            return isReversed ? "Colombo to Kesbewa" : "Kesbewa to Colombo"
        case "Ex01":
            return isReversed ? "Galle to Makumbura" : "Makumbura to Galle"
        default:
            return route.name
        }
    }

    func getCleanRouteName() -> String {
        let components = route.name.components(separatedBy: " - ")
        if components.count == 2 {
            return components[1].trimmingCharacters(in: .whitespaces)
        }
        return route.name
    }
}

struct RouteDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RouteDetailsView(route: BusRoute.allRoutes[2]) // Ex01 route
    }
}
