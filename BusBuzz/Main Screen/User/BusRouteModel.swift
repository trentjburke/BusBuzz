import Foundation

struct BusRoute: Identifiable {
    let id = UUID()
    let routeNumber: String
    let name: String
    let stops: [String]
    var currentBusStop: String?

    // ✅ Add a default route to prevent missing route errors
    static let defaultRoute = BusRoute(
        routeNumber: "119",
        name: "Maharagama to Dehiwala",
        stops: ["Maharagama", "Boralesgamuwa", "Pirivena Junction", "Dewalamulla", "Bellanwila", "Bellantota", "Nikape", "Nedimala", "Karagampitiya", "Dehiwela"],
        currentBusStop: nil // ✅ No tracking needed yet
    )

    // Computed property to dynamically reverse the route name
    var reversedName: String {
        return getReversedRouteName()
    }

    // Function to reverse route names correctly
    private func getReversedRouteName() -> String {
        switch routeNumber {
        case "119":
            return name.contains("Maharagama") ? "- Dehiwala to Maharagama" : "- Maharagama to Dehiwala"
        case "120":
            return name.contains("Piliyandala") ? "- Colombo to Kesbewa" : "- Kesbewa to Colombo"
        case "Ex01":
            return name.contains("Makumbura") ? "- Galle to Makumbura" : "- Makumbura to Galle"
        default:
            return name
        }
    }

    //  Hardcoded Available Bus Routes (Now with Optional `currentBusStop`)
    static let allRoutes: [BusRoute] = [
        BusRoute(routeNumber: "119", name: "119 - Maharagama to Dehiwala", stops: ["Maharagama", "Boralesgamuwa", "Pirivena Junction", "Dewalamulla", "Bellanwila", "Bellantota", "Nikape", "Nedimala", "Karagampitiya", "Dehiwela"], currentBusStop: nil),

        BusRoute(routeNumber: "120", name: "120 - Kesbewa to Colombo", stops: ["Kesbewa", "Werahera", "Boralesgamuwa", "Pepiliyana", "Thummulla", "Town Hall", "Fort", "Pettah"], currentBusStop: nil),

        BusRoute(routeNumber: "Ex01", name: "Ex01 - Makumbura to Galle", stops: ["Makumbura", "Galle"], currentBusStop: nil)
    ]
}
