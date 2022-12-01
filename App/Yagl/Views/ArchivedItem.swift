//
//  ArchivedItem.swift
//  Yagl
//
//  Created by Kolmar Kafran on 01/12/22.
//

import SwiftUI

struct ArchivedItem: View {
    @ObservedObject var item: Item

    private var lastTransactionDate: String {
        if let transaction = item.transactionArray.last,
           let transactionDate = transaction.date
        {
            return transactionDate.formatted(date: .abbreviated, time: .omitted)
        } else {
            return "Unknown Date"
        }
    }

    var body: some View {
        HStack {
            Image(systemName: "circle")
                .foregroundColor(.secondary)
            VStack(alignment: .leading) {
                Text(item.nameString)
                Text("Last buy: \(lastTransactionDate)")
                    .font(.caption2)
            }
        }
        .swipeActions {
            Button {
                self.unarchiveItems(item: item)
            } label: {
                Image(systemName: "tray.and.arrow.up")
            }
            .tint(.blue)
        }
    }

    private func unarchiveItems(item: Item) {
        item.statusEnum = .list
        PersistenceController.shared.save()
    }
}

// struct ArchivedItem_Previews: PreviewProvider {
//    static var previews: some View {
//        ArchivedItem()
//    }
// }
