//
//  CoinRowView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 12. 6. 2024..
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
           leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
    }
}

#Preview {
    Group {
        CoinRowView(coin: Preview.dev.coin, showHoldingsColumn: true)
        CoinRowView(coin: Preview.dev.coin, showHoldingsColumn: true)
            .colorScheme(.dark)
    }
   
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0.0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondarytext)
                .frame(width: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .padding(.horizontal, 6)
        }
    }


    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
    }


    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .fontWeight(.bold)
                .foregroundStyle(Color.theme.accent)
            if let priceChange = coin.priceChangePercentage24H {
                Text(priceChange.asPercentageString())
                    .foregroundStyle(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.theme.greenTheme : Color.theme.redTheme
                    )
            }
        }
        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
    }
    
}
