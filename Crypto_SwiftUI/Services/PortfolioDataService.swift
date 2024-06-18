//
//  PortfolioDataService.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 17. 6. 2024..
//


// gping to core data
import Foundation
import CoreData


class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading core data \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coindID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amound: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    
    // MARK: PRIVATE
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio entities \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coindID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amound: Double) {
        entity.amount = amound
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving core data \(error)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
