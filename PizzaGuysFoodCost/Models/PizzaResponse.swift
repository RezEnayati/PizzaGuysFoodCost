import Foundation

struct PizzaResponse: Codable {
    let pizza: [Pizza]
}

struct Pizza: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let imageName: String
    let toppings: PizzaToppings
    
    static let pizzaExample = Pizza(
        id: 0,
        name: "Pizza Guys Combo",
        imageName: "comboLogo",
        toppings: PizzaToppings(
            ingredients: [
                "dough", "rSauce", "cheese", "salami", "pepperoni",
                "mushroom", "greenPepper", "yellowOnion", "blackOlive",
                "beef", "sausage"
                
            ],
            quantities: [
                "s": [11.0, 2.0, 3.5, 6.0, 12.0, 2.0, 1.0, 1.0, 1.0, 1.0, 1.0],
                "m": [15.0, 3.0, 5.0, 10.0, 16.0, 3.0, 1.5, 1.5, 1.5, 1.5, 1.5],
                "l": [20.0, 4.0, 7.0, 13.0, 23.0, 3.5, 2.0, 2.0, 2.0, 2.0, 2.0],
                "x": [26.0, 5.0, 9.0, 17.0, 30.0, 4.5, 2.5, 2.5, 2.5, 2.5, 2.5]
            ]
        )
    )
}

struct PizzaToppings: Codable {
    let ingredients: [String]
    let quantities: [String:[Double]]
}
