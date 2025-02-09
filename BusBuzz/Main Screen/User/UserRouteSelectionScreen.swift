import SwiftUI

struct UserRouteSelectionScreen: View {
    @State private var fromLocation: String? = "Current Location" // Default to user's location
    @State private var toLocation: String? = nil
    @State private var availableRoutes: [String] = []
    @State private var showBusStopsScreen = false
    
    let locations = ["Maharagama", "Dehiwala", "Piliyandala", "Colombo", "Makumbura", "Galle"]

    var body: some View {
        VStack {
            // From Picker
            Picker("Choose starting point", selection: $fromLocation) {
                Text("Current Location").tag("Current Location")
                ForEach(locations, id: \.self) { location in
                    Text(location).tag(location)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
            // To Picker
            Picker("Choose destination", selection: $toLocation) {
                Text("Select Destination").tag(nil as String?)
                ForEach(locations, id: \.self) { location in
                    Text(location).tag(location)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            
            // Find Bus Button
            Button(action: {
                filterRoutes()
                showBusStopsScreen.toggle()
            }) {
                Text("FIND A BUS")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColors.buttonGreen)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(toLocation == nil)
            
            Spacer()
        }
        .padding()
        .background(AppColors.background)
        .navigationTitle("Find a Bus")
        .sheet(isPresented: $showBusStopsScreen) {
            UserBusStopsScreen(fromLocation: fromLocation, toLocation: toLocation, availableRoutes: availableRoutes)
        }
    }

    func filterRoutes() {
        // Logic to filter routes based on the "From" and "To" selections.
        if fromLocation == "Maharagama" && toLocation == "Dehiwala" {
            availableRoutes = ["Route 119"]
        } else if fromLocation == "Piliyandala" && toLocation == "Colombo" {
            availableRoutes = ["Route 120"]
        } else if fromLocation == "Makumbura" && toLocation == "Galle" {
            availableRoutes = ["Route Ex01"]
        } else {
            availableRoutes = [] // No routes available
        }
    }
}

struct UserBusStopsScreen: View {
    let fromLocation: String?
    let toLocation: String?
    let availableRoutes: [String]
    
    var body: some View {
        VStack {
            Text("Available Routes")
                .font(.title)
                .padding()
            
            List(availableRoutes, id: \.self) { route in
                Text(route)
            }
            
            Spacer()
        }
    }
}

// Preview
struct UserHamburgerMenuScreenView_Previews: PreviewProvider {
    static var previews: some View {
        UserRouteSelectionScreen()
    }
}
