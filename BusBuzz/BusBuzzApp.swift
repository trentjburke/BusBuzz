//
//  BusBuzzApp.swift
//  BusBuzz
//
//  Created by user271476 on 1/3/25.
//

import SwiftUI

@main
struct BusBuzzApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
