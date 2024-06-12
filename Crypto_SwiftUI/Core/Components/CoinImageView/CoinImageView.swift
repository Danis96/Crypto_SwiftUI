//
//  CoinImageView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 12. 6. 2024..
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject var coinImageVM: CoinImageViewModel
    
    init(coin: CoinModel) {
        _coinImageVM = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = coinImageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if coinImageVM.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.theme.secondarytext)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: DeveloperPreview.instance.coin)
}
