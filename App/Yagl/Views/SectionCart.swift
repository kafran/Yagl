//
//  SectionCart.swift
//  Yagl
//
//  Created by Kolmar Kafran on 30/11/22.
//

import SwiftUI

struct SectionCart: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(
            format: "%K == %@",
            argumentArray: [#keyPath(Item.status), Status.cart.rawValue]
        ),
        animation: .default
    ) private var items: FetchedResults<Item>

    @State private var isExpanded = false

    var count: Int {
        items.map { $0.transactionArray.last?.quantity ?? 0 }
            .reduce(0) { $0 + Int($1) }
    }

    var total: Decimal {
        items.map {
            let quantity = Decimal($0.transactionArray.last?.quantity ?? 0)
            let price = $0.transactionArray.last?.priceDecimal ?? Decimal(0)
            return quantity * price
        }
        .reduce(0) { $0 + $1 }
    }

    var body: some View {
        Section {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(items) { item in
                    CartItem(item: item)
                }
            } label: {
                HStack {
                    Image(systemName: "cart").foregroundColor(.blue)
                    Text(self.total, format: .currency(code: Currency.code))
                        + Text(" (\(self.count) items)")
                }
                .bold()
            }
        }
    }
}

struct SectionCart_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SectionCart()
                .environment(
                    \.managedObjectContext,
                    PersistenceController.preview.container.viewContext
                )
        }
    }
}
