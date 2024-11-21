import Foundation

struct SaladsResponse: Codable {
    let salads: [Salad]
}

struct Salad: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let imageName: String
    let toppings: SaladToppings
    
    static let saladExample = Salad(
        id: 1,
        name: "Garden Salad",
        imageName: "gardenSaladLogo",
        toppings: SaladToppings(
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
                6.0,
                0.4,
                0.4,
                0.4,
                1.5,
                0.25,
                0.25
            ]
        )
    )
}


struct SaladToppings: Codable {
    let ingredients: [String]
    let quantities: [Double]
}
