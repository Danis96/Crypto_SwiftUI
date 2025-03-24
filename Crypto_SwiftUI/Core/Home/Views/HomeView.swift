//
//  HomeView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 11. 6. 2024..
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var showPortfolio: Bool = false // - right animation
    @State private var showPortfolioView: Bool = false // - open sheet
    
    @State private var selectedCoin: CoinModel?
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(homeVM)
                })
            
            // content layer
            VStack {
                header
                
                HomeStatView(showPortfolio: $showPortfolio)
                
                SearchBarComponent(textFieldText: $homeVM.searchText)
                
                nameColumns
                
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
        .background(
            navigationDestination(isPresented: $showDetailView, destination: {
                DetailLoadingView(coin: $selectedCoin)
            })
        )
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
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(CircleButtonAnimationView(animate: $showPortfolio))
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
                    .onTapGesture {
                        selectedCoin = coin
                        showDetailView.toggle()
                    }
                
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinList: some View {
        List {
            ForEach(homeVM.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        selectedCoin = coin
                        showDetailView.toggle()
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private var nameColumns: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((homeVM.sortOptions == .rank || homeVM.sortOptions == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: homeVM.sortOptions == .rank ? 180 : 0))
            }
            .onTapGesture {
                withAnimation {
                    homeVM.sortOptions = homeVM.sortOptions == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((homeVM.sortOptions == .holdings || homeVM.sortOptions == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: homeVM.sortOptions == .holdings ? 180 : 0))
                }
                .onTapGesture {
                    withAnimation {
                        homeVM.sortOptions = homeVM.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
                HStack(spacing: 4) {
                    Text("Price")
                    Image(systemName: "chevron.down")
                        .opacity((homeVM.sortOptions == .price || homeVM.sortOptions == .priceReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: homeVM.sortOptions == .price ? 180 : 0))
                }
                .frame(width: UIScreen.main.bounds.width / 3, alignment: .trailing)
                .onTapGesture {
                    withAnimation {
                        homeVM.sortOptions = homeVM.sortOptions == .price ? .priceReversed : .price
                    }
                }
                
                Button(action: {
                    withAnimation(.linear(duration: 2.0)) {
                        homeVM.reloadData()
                    }
                }, label: {
                    Image(systemName: "goforward")
                })
                .rotationEffect(Angle(degrees: homeVM.isLoading ? 360 : 0), anchor: .center)
            }
                .font(.caption)
                .foregroundStyle(Color.theme.secondarytext)
                .padding(.horizontal)
        }
    }
