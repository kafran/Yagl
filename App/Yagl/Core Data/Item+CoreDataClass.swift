//
//  Item+CoreDataClass.swift
//  Yagl
//
//  Created by Kolmar Kafran on 28/11/22.
//
//

import CoreData
import Foundation

@objc(Item)
public class Item: NSManagedObject {}

extension Item {
    var nameString: String {
        get { name ?? "" }
        set { name = newValue }
    }

    var statusEnum: Status {
        get {
            Status(rawValue: status) ?? .list
        }
        set {
            status = newValue.rawValue
        }
    }
    
    var transactionArray: [Transaction] {
        self.transaction?.array as? [Transaction] ?? []
    }
}
