//
//  SectionArchived.swift
//  Yagl
//
//  Created by Kolmar Kafran on 01/12/22.
//

import SwiftUI

struct SectionArchived: View {
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(
            format: "%K == %@",
            argumentArray: [#keyPath(Item.status), Status.archived.rawValue]
        ),
        animation: .default
    ) private var items: FetchedResults<Item>

    @State private var isExpanded = false

    var body: some View {
        Section {
            DisclosureGroup(isExpanded: $isExpanded) {
                ForEach(items) { item in
                    ArchivedItem(item: item)
                }
            } label: {
                Label("Archive", systemImage: "tray")
                    .badge(items.count)
            }
        }
    }
}

struct SectionArchived_Previews: PreviewProvider {
    static var previews: some View {
        SectionArchived()
    }
}
