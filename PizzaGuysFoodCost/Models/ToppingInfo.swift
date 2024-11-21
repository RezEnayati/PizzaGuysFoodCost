//
//  ToppingInfo.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/2/24.
//

import Foundation

struct ToppingInfo: Hashable {
    let name: String
    let amount: Double
    let cost: Double
}


// Helper Methods for total cost of items.
extension ToppingInfo {
    
    static func calculateTotalCostFormated(for toppings: [ToppingInfo]) -> String {
        var sum = 0.0
        for topping in toppings {
            sum += topping.cost
        }
        return String(format: "%.2f", sum)
    }
}
