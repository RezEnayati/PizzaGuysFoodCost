//
//  CateringResponse.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 10/27/24.
//

import Foundation


struct CateringResponse: Codable {
    let catering: [CateringItem]
}

struct CateringItem: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let type: String
    let imageName: String
    let toppings: CateringToppings
    
    static let saladExample = CateringItem(
        id: 1,
        name: "Garden Salad", type: "salad",
        imageName: "cateringGardenSaladLogo",
        toppings: CateringToppings(
            ingredients: [
                "lettuce",
                "greenPepper",
                "redOnion",
                "blackOlive",
                "tomato",
                "cheese",
                "cheddarCheese"
            ],
            quantities: [
                24.0,
                1.5,
                1.5,
                1.5,
                5.0,
                1.0,
                1.0
            ]
        )
    )
    
    static let pastaExample = CateringItem(
        id: 3,
        name: "Penne Pollo Rustico", type: "pasta",
        imageName: "polloRusticoCateringImage",
        toppings: CateringToppings(
            ingredients: [
                "pasta",
                "chicken",
                "bacon",
                "tomato",
                "greenOnion",
                "cheese",
                "wSauce",
                "basil"
            ],
            quantities: [
                32.0,
                8.0,
                2.0,
                2.0,
                2.0,
                8.0,
                22.0,
                0.25
            ]
        )
    )
}

struct CateringToppings: Codable {
    let ingredients: [String]
    let quantities: [Double]
}
