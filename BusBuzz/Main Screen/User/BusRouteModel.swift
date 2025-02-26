import Foundation
import CoreLocation

struct BusRoute: Identifiable {
    let id = UUID()
    let routeNumber: String
    let name: String
    let stops: [(name: String, location: CLLocationCoordinate2D)] 
    var currentBusStop: String?

    // Default route with actual stops and coordinates
    static let defaultRoute = BusRoute(
        routeNumber: "119",
        name: "Maharagama to Dehiwala",
        stops: [
            ("Maharagama", CLLocationCoordinate2D(latitude: 6.846004, longitude: 79.926111)),
            ("Boralesgamuwa lake", CLLocationCoordinate2D(latitude: 6.842679, longitude: 79.916113)),
            ("Embillawatta", CLLocationCoordinate2D(latitude: 6.842843, longitude: 79.912515)),
            ("Pirivena Junction", CLLocationCoordinate2D(latitude: 6.842021, longitude: 79.908512)),
            ("Boralesgamuwa", CLLocationCoordinate2D(latitude: 6.840506, longitude: 79.900605)),
            ("Dewalamulla", CLLocationCoordinate2D(latitude: 6.840362, longitude: 79.897837)),
            ("Bellanwila", CLLocationCoordinate2D(latitude: 6.845176, longitude: 79.889709)),
            ("Belantota", CLLocationCoordinate2D(latitude: 6.848021, longitude: 79.885879)),
            ("Nikape", CLLocationCoordinate2D(latitude: 6.849500, longitude: 79.882735)),
            ("Nedimala", CLLocationCoordinate2D(latitude: 6.849621, longitude: 79.878496)),
            ("Karagampitiya", CLLocationCoordinate2D(latitude: 6.850165, longitude: 79.872634)),
            ("Hillstreet", CLLocationCoordinate2D(latitude: 6.851187, longitude: 79.866501)),
            ("Dehiwala", CLLocationCoordinate2D(latitude: 6.851253, longitude: 79.865038))
        ],
        currentBusStop: nil
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
        BusRoute(routeNumber: "119", name: "119 - Maharagama to Dehiwala", stops: [
            ("Maharagama", CLLocationCoordinate2D(latitude: 6.846004, longitude: 79.926111)),
            ("Boralesgamuwa lake", CLLocationCoordinate2D(latitude: 6.842679, longitude: 79.916113)),
            ("Embillawatta", CLLocationCoordinate2D(latitude: 6.842843, longitude: 79.912515)),
            ("Pirivena Junction", CLLocationCoordinate2D(latitude: 6.842021, longitude: 79.908512)),
            ("Boralesgamuwa", CLLocationCoordinate2D(latitude: 6.840506, longitude: 79.900605)),
            ("Dewalamulla", CLLocationCoordinate2D(latitude: 6.840362, longitude: 79.897837)),
            ("Bellanwila", CLLocationCoordinate2D(latitude: 6.845176, longitude: 79.889709)),
            ("Belantota", CLLocationCoordinate2D(latitude: 6.848021, longitude: 79.885879)),
            ("Nikape", CLLocationCoordinate2D(latitude: 6.849500, longitude: 79.882735)),
            ("Nedimala", CLLocationCoordinate2D(latitude: 6.849621, longitude: 79.878496)),
            ("Karagampitiya", CLLocationCoordinate2D(latitude: 6.850165, longitude: 79.872634)),
            ("Hillstreet", CLLocationCoordinate2D(latitude: 6.851187, longitude: 79.866501)),
            ("Dehiwala", CLLocationCoordinate2D(latitude: 6.851253, longitude: 79.865038))
        ], currentBusStop: nil),

        BusRoute(routeNumber: "120", name: "120 - Kesbewa to Colombo", stops: [
            ("Kesbewa", CLLocationCoordinate2D(latitude: 6.8001, longitude: 79.9415)),
            ("Werahera", CLLocationCoordinate2D(latitude: 6.8122, longitude: 79.9446)),
            ("Boralesgamuwa", CLLocationCoordinate2D(latitude: 6.8202, longitude: 79.9506)),
            ("Pepiliyana", CLLocationCoordinate2D(latitude: 6.8265, longitude: 79.9605)),
            ("Thummulla", CLLocationCoordinate2D(latitude: 6.8308, longitude: 79.9707)),
            ("Town Hall", CLLocationCoordinate2D(latitude: 6.9312, longitude: 79.9800)),
            ("Fort", CLLocationCoordinate2D(latitude: 6.9399, longitude: 79.9875)),
            ("Colombo", CLLocationCoordinate2D(latitude: 6.9488, longitude: 79.9930))
        ], currentBusStop: nil),

        BusRoute(routeNumber: "Ex01", name: "Ex01 - Makumbura to Galle", stops: [
            ("Makumbura", CLLocationCoordinate2D(latitude: 6.8391, longitude: 79.9763)),
            ("Galle", CLLocationCoordinate2D(latitude: 6.0324, longitude: 80.2149))
        ], currentBusStop: nil)
    ]
}
