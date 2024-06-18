//
//  XMarkButton.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 13. 6. 2024..
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss.callAsFunction()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}
