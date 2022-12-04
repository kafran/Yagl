//
//  GroceryItemView.swift
//  Yagl
//
//  Created by Kolmar Kafran on 29/11/22.
//

import SwiftUI

struct ListItem: View {
    @Environment(\.editMode) private var editMode
    @ObservedObject var item: Item
    @State private var isAddingToCart = false

    var body: some View {
        if editMode?.wrappedValue.isEditing == true {
            TextField("Item", text: $item.nameString)
                .submitLabel(.done)
        } else {
            Toggle(isOn: $isAddingToCart) {
                Text(item.nameString)
            }
            .toggleStyle(.checklist)
            .sheet(isPresented: $isAddingToCart, onDismiss: self.persistData) {
                TransactionView(item: .init(editEntity: item))
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private func persistData() {
        PersistenceController.shared.save()
    }
}

//struct GroceryItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListItem(item: Item.example)
//    }
//}
