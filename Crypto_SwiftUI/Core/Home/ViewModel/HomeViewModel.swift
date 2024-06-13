//
//  HomeViewModel.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 12. 6. 2024..
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = [
        StatisticModel(title: "Market Cap", value: "$12.5Bn", percentageChange: 25.34),
        StatisticModel(title: "Danis Cap", value: "$12.5Bn", percentageChange: 15.34),
        StatisticModel(title: "Portfolio Cap", value: "$152.5Bn", percentageChange: 1.23),
        StatisticModel(title: "Cap", value: "$12", percentageChange: -7.4)
    ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private var dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        
        // return coins based on search text or return everything
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
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
    
}
