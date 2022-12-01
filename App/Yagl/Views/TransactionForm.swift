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

    var items: String {
        transaction.quantity <= 1 ? "item" : "items"
    }

    var total: Double {
        // FIXME: nil-coalescing
        Double(transaction.quantity) * (transaction.price?.doubleValue ?? 0.0)
    }

    var body: some View {
        Form {
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

            HStack {
                Text("Total")
                Spacer()
                Text(self.total, format: .currency(code: Currency.code))
            }
        }
        .padding()
        .navigationTitle("\(item.nameString)")
        .navigationBarTitleDisplayMode(.inline)
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
