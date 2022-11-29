//
//  Status.swift
//  Yagl
//
//  Created by Kolmar Kafran on 28/11/22.
//

import Foundation

enum Status: Int16 {
    case list
    case cart
    case archived
}

extension Status {
    var name: String {
        switch self {
        case .list:
            return "List"
        case .cart:
            return "Cart"
        case .archived:
            return "Archived"
        }
    }
}
