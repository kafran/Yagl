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
    ) private var cart: FetchedResults<Item>
    
    @State private var isExpanded = false
    
    var body: some View {
        Section {
            DisclosureGroup(isExpanded: $isExpanded){
                ForEach(cart) { item in
                    Text(item.name ?? "Unkown")
                }
            } label: {
                HStack {
                    Image(systemName: "cart")
                        .foregroundColor(.blue)
                    //                        Text(self.total, format: .currency(code: settings.currency))
                    Text("R$ 80.00")
                    +
                    Text(" (10 items)")
                    //                            Text(" (\(self.count) items)")
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
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
