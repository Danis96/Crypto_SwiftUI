//
//  PortfolioView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 13. 6. 2024..
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var homeVM: HomeViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    
                    SearchBarComponent(textFieldText: $homeVM.searchText)
                    
                    coinLogoList
                    
                    if homeVM.selectedCoin != nil {
                        portfolioInputScreen
                    }
                    
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBaritems
                }
            })
            .onChange(of: homeVM.searchText) { oldValue, newValue in
                if newValue == "" {
                    homeVM.removeYourCoin()
                }
            }
            
        }
        
    }
}

#Preview {
    PortfolioView()
        .environmentObject(DeveloperPreview.instance.homeVM)
}


extension PortfolioView {
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(content: {
                ForEach(homeVM.searchText.isEmpty ? homeVM.portfolioCoins : homeVM.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10.0)
                                .strokeBorder(
                                    homeVM.returnSelectedColor(coin: coin), lineWidth: 1)
                        )
                }
            }).padding(.leading)
            
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        homeVM.selectedCoin = coin
        
        if
            let portfolioCoin = homeVM.portfolioCoins.first(where: { $0.id == coin.id }),
            let amount = portfolioCoin.currentHoldings {
               homeVM.editPortfolioValue = "\(amount)"
        } else {
            homeVM.editPortfolioValue = ""
        }
    }
    
    private var portfolioInputScreen: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(homeVM.selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(homeVM.selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $homeVM.editPortfolioValue)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(homeVM.getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBaritems: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(homeVM.showCheckmark ? 1 : 0)
            Button(action: {
                homeVM.saveYourCoin()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(
                (homeVM.shouldShowSaveButton() ? 1 : 0)
            )
            
        }
        .font(.headline)
    }
    
}


