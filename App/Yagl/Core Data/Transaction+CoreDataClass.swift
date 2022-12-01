//
//  Transaction+CoreDataClass.swift
//  Yagl
//
//  Created by Kolmar Kafran on 28/11/22.
//
//

import CoreData
import Foundation

@objc(Transaction)
public class Transaction: NSManagedObject {}

extension Transaction {
    var priceDecimal: Decimal {
        get { price as? Decimal ?? Decimal(0) }
        set { price = newValue as NSDecimalNumber }
    }
}
