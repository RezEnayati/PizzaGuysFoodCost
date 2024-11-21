//
//  NameServiceProtocols.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/2/24.
//

import Foundation

protocol NameServiceProtocols {
    func getToppingName(ingredient: String) -> String
    func getToppingNames(ingredients: [String]) -> [String]
}
