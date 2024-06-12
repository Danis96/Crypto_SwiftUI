//
//  Color.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 11. 6. 2024..
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let greenTheme = Color("GreenColor")
    let redTheme = Color("RedColor")
    let secondarytext = Color("SecondaryTextColor")
}
