import Foundation
import CoreLocation

struct BusRoute: Identifiable, Hashable, Equatable {
    let id = UUID()
    let routeNumber: String
    let name: String
    let stops: [(name: String, location: CLLocationCoordinate2D)]
    let isReverse: Bool
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
        isReverse: false,
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
    
    // Equatable conformance
    static func == (lhs: BusRoute, rhs: BusRoute) -> Bool {
        return lhs.id == rhs.id
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(routeNumber)
        hasher.combine(name)
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
        ], isReverse : false, currentBusStop : nil),
        
        BusRoute(routeNumber: "119", name: "119 - Dehiwala to Maharagama", stops: [
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
        ], isReverse : true, currentBusStop : nil),
        

        BusRoute(routeNumber: "120", name: "120 - Kesbewa to Colombo", stops: [
            ("Kesbewa", CLLocationCoordinate2D(latitude: 6.801681174282759, longitude: 79.9239695642226)),
            ("Piliyandala", CLLocationCoordinate2D(latitude: 6.800700234591165, longitude: 79.92365831075625)),
            ("Bokundara", CLLocationCoordinate2D(latitude: 6.819962071109644, longitude: 79.91685564805408)),
            ("Werahera", CLLocationCoordinate2D(latitude: 6.833299940014564, longitude: 79.9057083114398)),
            ("Boralesgamuwa", CLLocationCoordinate2D(latitude: 6.839517912648861, longitude: 79.90273906563667)),
            ("Rattanapitiya", CLLocationCoordinate2D(latitude: 6.84865000185514, longitude: 79.8966974930631)),
            ("Pepiliyana", CLLocationCoordinate2D(latitude: 6.856082607757802, longitude: 79.89072505915735)),
            ("Kohuwala", CLLocationCoordinate2D(latitude: 6.868329177951234, longitude: 79.8833955416306)),
            ("Dutugemunu Street", CLLocationCoordinate2D(latitude: 6.87069532901583, longitude: 79.87737139618588)),
            ("Pamankada", CLLocationCoordinate2D(latitude: 6.876558877657431, longitude: 79.86998012967204)),
            ("Havelock City", CLLocationCoordinate2D(latitude: 6.8828786844758225, longitude: 79.86884954743292)),
            ("Thimbirigasyaya Junction", CLLocationCoordinate2D(latitude: 6.893343076976488, longitude: 79.86194183007606)),
            ("Thummulla", CLLocationCoordinate2D(latitude: 6.8956742076789705, longitude: 79.86054385945774)),
            ("Colombo Campus", CLLocationCoordinate2D(latitude: 6.902672680153752, longitude: 79.86225119338751)),
            ("RaceCourse", CLLocationCoordinate2D(latitude: 6.9061470332288675, longitude: 79.86368398061377)),
            ("Nelum Pokuna", CLLocationCoordinate2D(latitude: 6.909578447928814, longitude: 79.8637048891096)),
            ("Town Hall", CLLocationCoordinate2D(latitude: 6.916575274016843, longitude: 79.86496237288942)),
            ("Ibbanwala Junction", CLLocationCoordinate2D(latitude: 6.918112320713323, longitude: 79.86252787124621)),
            ("T.B. Jayah Road (Darley Road)", CLLocationCoordinate2D(latitude: 6.923288970296334, longitude: 79.86188877935501)),
            ("Gamani Hall Junction", CLLocationCoordinate2D(latitude: 6.927029364620313, longitude: 79.86123904857823)),
            ("Lotus Tower", CLLocationCoordinate2D(latitude: 6.929199381651755, longitude: 79.85692673395766)),
            ("SL Exhibition Centre", CLLocationCoordinate2D(latitude: 6.932525092332875, longitude: 79.84945389384576)),
            ("Lake House", CLLocationCoordinate2D(latitude: 6.9326515723345175, longitude: 79.84789575254854)),
            ("Pettah", CLLocationCoordinate2D(latitude: 6.927039678349846, longitude: 79.86118582377492))
        ], isReverse: false, currentBusStop: nil),

        BusRoute(routeNumber: "Ex01", name: "Ex01 - Makumbura to Galle", stops: [
            ("Makumbura", CLLocationCoordinate2D(latitude: 6.8391, longitude: 79.9763)),
            ("Southern Expressway", CLLocationCoordinate2D(latitude: 6.049904966831381, longitude: 80.25611495252512)),
            ("Malgaha Junction", CLLocationCoordinate2D(latitude: 6.047381125376059, longitude: 80.24852018128948)),
            ("Main Street Galle", CLLocationCoordinate2D(latitude: 6.034974308785326, longitude: 80.22002186648511)),
            ("Dileka Street", CLLocationCoordinate2D(latitude: 6.041674246199178, longitude: 80.23701521326672)),
            ("Dewata", CLLocationCoordinate2D(latitude: 6.036741508932712, longitude: 80.22958014758323)),
            ("Galle", CLLocationCoordinate2D(latitude: 6.0324, longitude: 80.2149))
        ], isReverse: false, currentBusStop: nil),
        
        ]

    }
        
