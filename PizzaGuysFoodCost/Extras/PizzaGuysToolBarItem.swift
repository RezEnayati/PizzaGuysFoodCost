//
//  PizzaGuysToolBarItem.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/22/24.
//

import SwiftUI

struct PizzaGuysToolBarItem: ToolbarContent {
    var body: some ToolbarContent { 
        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 8) {
                Image(.pgLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .accessibilityLabel("Pizza Guys Logo")
            }
        }
    }
}
