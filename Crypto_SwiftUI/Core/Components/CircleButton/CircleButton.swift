//
//  CircleButton.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 11. 6. 2024..
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
            .padding()
    }
}

#Preview {
    Group {
        CircleButtonView(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
        CircleButtonView(iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
            .colorScheme(.dark)
    }
   
}
