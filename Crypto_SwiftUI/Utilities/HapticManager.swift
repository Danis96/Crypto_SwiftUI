//
//  HapticManager.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 18. 6. 2024..
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
