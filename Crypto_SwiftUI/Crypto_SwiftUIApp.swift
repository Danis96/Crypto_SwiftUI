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
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
        }.environmentObject(homeViewModel)
    }
}
