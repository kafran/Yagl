//
//  TransactionView.swift
//  Yagl
//
//  Created by Kolmar Kafran on 30/11/22.
//

import SwiftUI

struct TransactionView: View {
    let item: CoreDataChildContext<Item>

    var body: some View {
        NavigationView {
            TransactionForm(
                item: item.childObject,
                transaction: Transaction(context: item.childContext!)
            )
        }
    }
}

// struct TransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionView()
//    }
// }
