//
//  Currency.swift
//  Yagl
//
//  Created by Kolmar Kafran on 01/12/22.
//

import Foundation

// FIXME: Move this to a better Settings. Fix deprecation.
struct Currency {
    static let code = Locale.current.currencyCode ?? "USD"
}
