//
//  ToppingNameService.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/30/24.
//

import Foundation


class ToppingNameService: NameServiceProtocols {
    
    static let shared = ToppingNameService()
    private var toppingDictionary: [String:String] = [:]
    
    private init() {
        getToppingsDict()
    }
    private func getToppingsDict() {
        guard let url = Bundle.main.url(forResource: "ToppingKeys", withExtension: "json"), let data = try? Data(contentsOf: url), let mapping = try? JSONDecoder().decode([String:String].self, from: data) else {
            print("Could not load names dictinary")
            return
        }
        toppingDictionary = mapping
        
    }
    
    func getToppingNames(ingredients: [String]) -> [String] {
        return ingredients.compactMap{toppingDictionary[$0]}
    }
    
    func getToppingName(ingredient: String) -> String {
        return toppingDictionary[ingredient] ?? "Name Not Found"
    }

    
}
