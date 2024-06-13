//
//  HomeStatView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 13. 6. 2024..
//

import SwiftUI

struct HomeStatView: View {
    
    @EnvironmentObject private var homeVm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(homeVm.statistics) { stat in
                StatisticView(statModel: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading
        )
    }
}

#Preview {
    HomeStatView(showPortfolio: .constant(false))
        .environmentObject(DeveloperPreview.instance.homeVM)
}
