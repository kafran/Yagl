//
//  TransactionForm.swift
//  Yagl
//
//  Created by Kolmar Kafran on 01/12/22.
//

import SwiftUI

struct TransactionForm: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var item: Item
    @ObservedObject var transaction: Transaction
    
    init(item: Item, transaction: Transaction) {
        self.item = item
        
        if let lastTransaction = item.transactionArray.last {
            transaction.quantity = lastTransaction.quantity
            transaction.priceDecimal = lastTransaction.priceDecimal
            self.transaction = transaction
        } else {
            self.transaction = transaction
        }
    }

    @State var isHistoryExpanded = false

//    private var transactionHistory: [Transaction] {
//        guard let parentItem = try? item.parentContext.existingObject(with:
//        item.childObject.objectID) as? Item else { return [] }
//        return parentItem.transactionArray
//    }
//
    private var items: String {
        transaction.quantity <= 1 ? "item" : "items"
    }

    private var total: Double {
        // FIXME: nil-coalescing
        Double(transaction.quantity) * (transaction.price?.doubleValue ?? 0.0)
    }

    var body: some View {
        List {
            Section {
                Stepper(
                    "\(transaction.quantity) \(items)",
                    value: $transaction.quantity,
                    in: 0...99
                )
                TextField(
                    "Price",
                    value: $transaction.priceDecimal,
                    format: .currency(code: Currency.code)
                )
                .keyboardType(.decimalPad)
                .submitLabel(.done)
            }
            Section {
                HStack {
                    Text("Total")
                    Spacer()
                    Text(self.total, format: .currency(code: Currency.code))
                }
            }
            Section {
                DisclosureGroup(isExpanded: $isHistoryExpanded) {
                    ForEach(item.transactionArray.reversed()) { transaction in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(transaction.quantity)")
                                Image(systemName: "multiply")
                                Text(
                                    transaction.priceDecimal,
                                    format: .currency(code: Currency.code)
                                )
                            }
                            Text(
                                transaction.date?
                                    .formatted(date: .abbreviated, time: .shortened) ??
                                    ""
                            )
                            .font(.caption)
                        }
                    }
                } label: {
                    Label("History", systemImage: "calendar.badge.clock")
                        .badge(item.transactionArray.count)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.save()
                    dismiss()
                } label: {
                    Text("Add")
                }
                .disabled(transaction.quantity == 0)
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .navigationTitle("\(item.nameString)")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func save() {
        guard transaction.managedObjectContext?.hasChanges == true else {
            return // no changes to persist
        }

        item.statusEnum = .cart
        transaction.item = item
        transaction.date = Date.now

        // Push changes to the viewContext
        do {
            try transaction.managedObjectContext?.save()
        } catch {
            print("Something went wrong while saving the child context: \(error)")
        }
    }
}

// struct TransactionForm_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionForm()
//    }
// }
