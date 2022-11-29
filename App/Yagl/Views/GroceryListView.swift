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

    @SectionedFetchRequest(
        sectionIdentifier: \Item.status,
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.status, ascending: true)],
        animation: .default
    )
    private var items: SectionedFetchResults<Int16, Item>

    @State private var newItem = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        let list = items[0]
        let cart = items[1]
        let archived = items[2]

        List {
            Section(header: Text("Grocery List")) {
                ForEach(list) { item in
                    GroceryItemView(item: item)
                }
                .onDelete { indexSet in
                    deleteItems(at: indexSet, of: Array(list))
                }
                HStack {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                    TextField("New item", text: $newItem)
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onSubmit {
//                            addToList()
                        }
                    Button {
                        withAnimation {
//                            addToList()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add new item")
                    }
                    .disabled(newItem.isEmpty)
                }
            }
            .headerProminence(.increased)

            Section(header: Text("Cart")) {
                ForEach(cart) { item in
                    Text(item.name ?? "Unkown")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: { print("add item pressed") }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error
//                /appropriately.
//                // fatalError() causes the application to generate a crash log and
//                /terminate. You should not use this function in a shipping
//                /application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

    private func deleteItems(at offsets: IndexSet, of items: [Item]) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error
                // appropriately.
                // fatalError() causes the application to generate a crash log and
                // terminate. You should not use this function in a shipping
                // application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

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
