//
//  ListView.swift
//  Yagl
//
//  Created by Kolmar Kafran on 29/11/22.
//

import SwiftUI

struct SectionList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.order, ascending: true)],
        predicate: NSPredicate(
            format: "%K == %@",
            argumentArray: [#keyPath(Item.status), Status.list.rawValue]
        ),
        animation: .default
    ) private var items: FetchedResults<Item>

    @State private var newItemName = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        Section {
            ForEach(items) { item in
                ListItem(item: item)
                    .swipeActions {
                        Button {
                            self.archiveItems(item: item)
                        } label: {
                            Image(systemName: "tray.and.arrow.down")
                        }.tint(.blue)
                        Button(role: .destructive) {
                            self.deleteItems(item: item)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
            .onMove(perform: self.moveItems)
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
                TextField("New item", text: $newItemName)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .onSubmit {
                        guard !newItemName.isEmpty else { return }
                        addNewItem()
                    }
                Button {
                    withAnimation {
                        addNewItem()
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel("Add new item")
                }
                .disabled(newItemName.isEmpty)
            }
        }
    }

    private func addNewItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = self.newItemName
            newItem.status = Status.list.rawValue
            newItem.order = (items.last?.order ?? 0) + 1
            PersistenceController.shared.save()
        }
        newItemName = ""
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            PersistenceController.shared.save()
        }
    }

    private func deleteItems(item: Item) {
        withAnimation {
            viewContext.delete(item)
        }
        PersistenceController.shared.save()
    }

    private func archiveItems(item: Item) {
        withAnimation {
            item.statusEnum = .archived
        }
        PersistenceController.shared.save()
    }

    private func moveItems(at offset: IndexSet, to destination: Int) {
        let itemToMove = offset.first!

        if itemToMove < destination {
            var startIndex = itemToMove + 1
            let endIndex = destination - 1
            var startOrder = items[itemToMove].order
            while startIndex <= endIndex {
                items[startIndex].order = startOrder
                startIndex += 1
                startOrder += 1
            }
            items[itemToMove].order = startOrder
        } else if destination < itemToMove {
            var startIndex = destination
            let endIndex = itemToMove - 1
            var startOrder = items[destination].order + 1
            let newOrder = items[destination].order
            while startIndex <= endIndex {
                items[startIndex].order = startOrder
                startIndex += 1
                startOrder += 1
            }
            items[itemToMove].order = newOrder
        }
        PersistenceController.shared.save()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SectionList().environment(
                \.managedObjectContext,
                PersistenceController.preview.container.viewContext
            )
        }
    }
}
