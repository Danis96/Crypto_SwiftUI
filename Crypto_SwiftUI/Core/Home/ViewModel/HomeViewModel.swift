//
//  HomeViewModel.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 12. 6. 2024..
//

import Foundation
import Combine
import SwiftUI


class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    @Published var editPortfolioValue: String = ""
    @Published var showCheckmark: Bool = false
    @Published var isLoading: Bool = false
    @Published var sortOptions: SortOptions = .holdings
    
    @Published var selectedCoin: CoinModel?
    
    private var coinDataService = CoinDataService()
    private var marketDataService = MarketDataService()
    private var portfolioDataService = PortfolioDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    
    // check for multiple activation
    // one is triggered from another
    func addSubscribers() {
        
        
        // return coins based on search text or return everything
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOptions)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates portfolio coins
        $allCoins
             .combineLatest(portfolioDataService.$savedEntities)
             .map(mapAllCoinsToPortfolioCoins)
             .sink { [weak self] (returnedCoins) in
                 guard let self = self else { return }
                 self.portfolioCoins = sortPortfolioCoinsIfNeeded(coins: returnedCoins)
             }
             .store(in: &cancellables)
        
        // updates market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapMarketData)
            .sink { [weak self] (returnedStats) in
                guard let self = self else { return }
                self.statistics = returnedStats
                self.isLoading = false
            }
            .store(in: &cancellables)
        
      
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioCoins.first(where: { $0.coindID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sortOption: SortOptions) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sortOption, coins: &updatedCoins)
        return updatedCoins
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowerCaseText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCaseText) ||
            coin.symbol.lowercased().contains(lowerCaseText) ||
            coin.id.lowercased().contains(lowerCaseText)
        }
    }
    
    private func sortCoins(sort: SortOptions, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortOptions {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    
    
    private func mapMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            // sum things [0 - starting value, + sum]
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentvalue = coin.currentHoldingsValue
                guard var percentageChange = coin.priceChangePercentage24H else {return 0}
                percentageChange = percentageChange / 100
                let previousValue = currentvalue / (1 + percentageChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
    
    
    /// add portfolio view sheet logic
    /// if selcted coin id match with looped id return xorresponding color
    func returnSelectedColor(coin: CoinModel) -> Color {
        
        guard let selectedCoin = selectedCoin else {
            return Color.clear
        }
        
        if selectedCoin.id == coin.id {
            return Color.theme.greenTheme
            
        } else {
            return Color.clear
        }
    }
    
    /// get current value
    /// portfolio edit screen
    func getCurrentValue() -> Double {
        guard let sCoin = selectedCoin else {
            return 0
        }
        if let quantity = Double(editPortfolioValue) {
            return quantity * (sCoin.currentPrice)
        }
        return 0
    }
    
    /// bool for opacity save showing on portfolio edit view
    func shouldShowSaveButton() -> Bool {
        return selectedCoin != nil && selectedCoin?.currentHoldings != Double(editPortfolioValue)
    }
    
    func saveYourCoin() {
        guard
            let coin = selectedCoin,
            let amount = Double(editPortfolioValue)
        else { return }
        
        // save to portfolio
        updatePortfolio(coin: coin, amount: amount)
        
        //show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeYourCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmar
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                self.showCheckmark = false
            }
        }
    }
    
    func removeYourCoin() {
        selectedCoin = nil
        editPortfolioValue = ""
    }
}
