//
//  StatisticView.swift
//  Crypto_SwiftUI
//
//  Created by Danis Preldzic on 13. 6. 2024..
//

import SwiftUI

struct StatisticView: View {
    
    let statModel: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(statModel.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondarytext)
            Text(statModel.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack {
                
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statModel.percentageChange ?? 0) >= 0 ? 0 : 180))
                    .foregroundStyle((statModel.percentageChange ?? 0) >= 0 ? Color.theme.greenTheme : Color.theme.redTheme)
                
                Text(statModel.percentageChange?.asPercentageString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .opacity(statModel.percentageChange == nil ? 0 : 1)
            
          
            
        }
    }
}

#Preview {
    StatisticView(statModel: DeveloperPreview.instance.stat1)
}
