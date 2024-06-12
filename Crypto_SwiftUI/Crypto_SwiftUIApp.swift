//
//  Crypto_SwiftUIApp.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 11. 6. 2024..
//

import SwiftUI

@main
struct Crypto_SwiftUIApp: App {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
        }.environmentObject(homeViewModel)
    }
}
