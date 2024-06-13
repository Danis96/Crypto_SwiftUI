//
//  SearchBarComponent.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 13. 6. 2024..
//

import SwiftUI

struct SearchBarComponent: View {
    
    @Binding var textFieldText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    textFieldText.isEmpty ? Color.theme.secondarytext : Color.theme.accent
                )
            
            TextField("Search by name or symbol...", text: $textFieldText)
                .foregroundStyle(Color.theme.accent)
                .overlay(alignment: .trailing, content: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.theme.accent)
                        .autocorrectionDisabled(true)
                        .opacity(textFieldText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            textFieldText = ""
                        }
                })
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 10
                )
        )
        .padding()
    }
}

//#Preview {
//    SearchBarComponent(textFieldText: <#T##Binding<String>#>)
//}
