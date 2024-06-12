//
//  Double.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 12. 6. 2024..
//

import Foundation



extension Double {
    
    /// Converts a double into currency with 2 decimal places
    /// ```
    /// Converts 1234.56 to $1,234.56
    /// Converts 12.3456 to $12.34
    /// Converts 0.123456 to $0.12
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }


    /// Converts a double into currency with 2-6 decimal places
    /// ```
    /// Converts 1234.56 to $1,234.56
    /// Converts 12.3456 to $12.3456
    /// Converts 0.123456 to $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    // Converts a double into string representation
    /// ```
    /// Converts 1234.56 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    // Converts a double into string representation with percentage symbol
    /// ```
    /// Converts 1234.56 to "1.23%"
    /// ```
    func asPercentageString() -> String {
        return asNumberString() + "%"
    }
    
}
