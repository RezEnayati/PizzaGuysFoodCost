//
//  ItemPriceCalculator.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/29/24.
//

import Foundation

class ItemPriceCalculator: PriceServiceProtocols {
    private var ingredients: [String:Ingredient]
    
    init(){
        self.ingredients = [:]
        
        do {
            try loadIngredients()
            addPestoSauce()
        } catch {
            print("Failed to load ingridient data \(error.localizedDescription)")
        }
        
    }
    
    private func loadIngredients() throws {
        guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json") else {
            throw PizzaServiceError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let ingredientsData = try decoder.decode(IngredientsData.self, from: data)
            
            self.ingredients = Dictionary(uniqueKeysWithValues: ingredientsData.ingredients.map { ($0.id, $0) })
        } catch {
            throw PizzaServiceError.decodingError
        }
    }
    
    // gives us the price for
    func getPrice(ingredientId: String, amount: Double) -> Double? {
        guard let ingredient = ingredients[ingredientId] else {return nil}
        switch ingredient.servingUnit {
        case .quantity:
            return ingredient.getPricePerServing() * amount
        case .oz,.gallon, .kg, .lb:
            let ozAmount = ingredient.servingUnit.convertToOz(amount: amount)
            return ingredient.getPricePerServing() * ozAmount
            
        }
    }
    
    // Get all the toppings in list to be seen in the items. 
    
}

extension ItemPriceCalculator {
    
    //Calculate and find the price for pesto Sauce
    private func calculatePestoPrice() -> Double {
        guard let garlicSaucePrice = getPrice(ingredientId: "wSauce", amount: 21.0),
              let pestoPouchPrice = getPrice(ingredientId: "pestoPouch", amount: 14.0) else {return 0.0}
        
        return garlicSaucePrice + pestoPouchPrice
    }
    
    private func addPestoSauce() {
        let pestoSauce = Ingredient(id: "pSauce", name: "Pesto Sauce", purchasePrice: calculatePestoPrice(), purchaseUnit: .oz, packageQuantity: 1, packageAmount: 35.0, servingUnit: .oz, unitConversion: nil)
        ingredients["pSauce"] = pestoSauce
    }
}
