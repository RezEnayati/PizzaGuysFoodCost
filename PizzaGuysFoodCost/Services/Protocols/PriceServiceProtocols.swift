//
//  PriceServiceProtocols.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/2/24.
//

import Foundation
protocol PriceServiceProtocols {
    func getPrice(ingredientId: String, amount: Double) -> Double?
}
