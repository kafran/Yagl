//
//  ContentView.swift
//  Yagl
//
//  Created by Kolmar Kafran on 22/11/22.
//

import CoreData
import SwiftUI

struct GroceryListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        List {
            SectionList()
            SectionCart()
            // SectionArchived()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
//            ToolbarItem {
//                Button(action: { print("add item pressed") }) {
//                    Label("Add Item", systemImage: "plus")
//                }
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GroceryListView().environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
        }
    }
}
