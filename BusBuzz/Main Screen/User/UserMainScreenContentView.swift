import SwiftUI

struct UserMainScreenContentView: View {
   @State private var selectedTab = 0
   @State private var selectedRoute: BusRoute? = nil

   var body: some View {
       ZStack {
        
           AppColors.background

           VStack(spacing: 0) {
               Spacer()

               TabView(selection: $selectedTab) {
                   // Menu Tab
                   UserRouteSelectionScreen(selectedRoute: $selectedRoute)
                       .tabItem {
                           VStack {
                               Image(systemName: "list.bullet")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 25, height: 25)
                               Text("Route")
                           }
                       }
                       .tag(0)

                   // Map Tab
                   UserMainMapScreen()
                       .tabItem {
                           VStack {
                               Image(systemName: "location.circle")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 25, height: 25)
                               Text("Location")
                           }
                       }
                       .tag(1)

                   // Settings Tab
                   UserSettingsScreen()
                       .tabItem {
                           VStack {
                               Image(systemName: "gear")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 25, height: 25)
                               Text("Settings")
                           }
                       }
                       .tag(2)
               }
               .accentColor(AppColors.buttonGreen)
           }
           .edgesIgnoringSafeArea(.top)
       }
       .navigationBarBackButtonHidden(true)
   }
}

struct UserMainScreenContentView_Previews: PreviewProvider {
   static var previews: some View {
       UserMainScreenContentView()
   }
}
