//
//  CartItem.swift
//  Yagl
//
//  Created by Kolmar Kafran on 01/12/22.
//

import SwiftUI

struct CartItem: View {
    @ObservedObject var item: Item
    @State private var isInCart = true

    var body: some View {
        Toggle(isOn: $isInCart) {
            Text(item.nameString)
        }
        .toggleStyle(.checklist)
        .onChange(of: isInCart) { _ in
            item.statusEnum = .list
            PersistenceController.shared.save()
        }
        .swipeActions {
            Button {
                self.archiveItems(item: item)
            } label: {
                Image(systemName: "tray.and.arrow.down")
            }
            .tint(.blue)
        }
//            .sheet(isPresented: $isAddingToCart) {
//                TransactionView(item: .init(editEntity: item))
//                    .presentationDetents([.medium, .large])
//            }
    }

    private func archiveItems(item: Item) {
        item.statusEnum = .archived
        PersistenceController.shared.save()
    }
}

// struct CartItem_Previews: PreviewProvider {
//    static var previews: some View {
//        CartItem()
//    }
// }
