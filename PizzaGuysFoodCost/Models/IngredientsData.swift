//
//  IngredientData.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/29/24.
//

import Foundation


// Errors for the service
enum PizzaServiceError: Error {
    case fileNotFound
    case decodingError
    case invalidData
}

// Units
enum Unit: String, Codable {
    case oz = "oz"
    case lb = "lb"
    case gallon = "GA"
    case kg = "kg"
    case quantity = "qty"
    
    func convertToOz(amount: Double) -> Double {
        switch self {
        case .oz:
            return amount
        case .lb:
            return amount * 16
        case .gallon:
            return amount * 128
        case .kg:
            return amount * 35.274
        case .quantity:
            return amount
        }
    }
}

// Ingredient Model
struct Ingredient: Codable {
    let id: String
    let name: String
    let purchasePrice: Double
    let purchaseUnit: Unit
    let packageQuantity: Int
    let packageAmount: Double
    let servingUnit: Unit
    let unitConversion: Double?
    
    func getPricePerServing() -> Double {
        
        // For items that need piece conversion (like pepperoni)
        if let conversion = unitConversion {
            let pricePerPackage = purchasePrice / Double(packageQuantity)
            let pricePerPound = pricePerPackage / packageAmount
            let poundsPerPiece = conversion / 16.0 // Convert oz to lb
            return pricePerPound * poundsPerPiece
        }
        
        // For regular weighted items
        if servingUnit != .quantity {
            let totalOz = purchaseUnit.convertToOz(amount: packageAmount * Double(packageQuantity))
            return purchasePrice / totalOz
        }
        
        // For quantity items (like boxes)
        return purchasePrice / (packageAmount * Double(packageQuantity))
    }
}


struct IngredientsData: Codable {
    let ingredients: [Ingredient]
}
