//
//  YaglApp.swift
//  Yagl
//
//  Created by Kolmar Kafran on 22/11/22.
//

import SwiftUI

@main
struct YaglApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                GroceryListView()
                    .environment(
                        \.managedObjectContext,
                        PersistenceController.shared.container.viewContext
                    )
            }
        }
    }
}
