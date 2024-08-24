//
//  RingSizerApp.swift
//  RingSizer
//
//  Created by Maitry Gajjar on 24/08/24.
//

import SwiftUI

@main
struct RingSizerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
