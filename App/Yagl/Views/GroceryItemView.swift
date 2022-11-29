//
//  GroceryItemView.swift
//  Yagl
//
//  Created by Kolmar Kafran on 29/11/22.
//

import SwiftUI

struct GroceryItemView: View {
    @ObservedObject var item: Item
    @State private var isAddingToCart = false
    
    var body: some View {
        Toggle(isOn: $isAddingToCart) {
            TextField("Item", text: $item.nameString)
        }
        .toggleStyle(.checklist)
        .sheet(isPresented: $isAddingToCart) {
            Text(item.nameString)
        }
    }
}

struct GroceryItemView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryItemView(item: Item.example)
    }
}
