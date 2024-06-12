//
//  HomeView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 11. 6. 2024..
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        ZStack {
            
            // background layer
            Color.theme.background
                .ignoresSafeArea()
            
            // content layer
            VStack {
                header
                
                HStack {
                    Text("Coin")
                    Spacer()
                    if showPortfolio {
                        Text("Holdings")
                    }
                    Text("Price")
                        .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
                }
                .font(.caption)
                .foregroundStyle(Color.theme.secondarytext)
                .padding(.horizontal)
                
                if !showPortfolio {
                    allCoinList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinList
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
    }
}

#Preview { 
    NavigationView {
        HomeView()
            .toolbar(.hidden)
            .environmentObject(DeveloperPreview.instance.homeVM)
    }
}

extension HomeView {
    
    private var header: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(CircleButtonAnimationView(animate: $showPortfolio))
                .animation(.none)
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring) {
                        showPortfolio.toggle()
                    }
                }
        }.padding(.horizontal)
    }
    
    private var allCoinList: some View {
        List {
            ForEach(homeVM.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }

    private var portfolioCoinList: some View {
        List {
            ForEach(homeVM.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
}
