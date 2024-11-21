import Foundation


struct PastaResponse: Codable {
    let pasta: [Pasta]
}

struct Pasta: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let imageName: String
    let toppings: PastaToppings
    static let pastaExample = Pasta(
        id: 1,
        name: "Penne Pollo Rustico",
        imageName: "polloRusticoImage",
        toppings: PastaToppings(
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
                8.0,
                2.0,
                0.5,
                0.5,
                0.5,
                2.0,
                6.0,
                0.15
            ]
        )
    )
}

struct PastaToppings: Codable {
    let ingredients: [String]
    let quantities: [Double]
}
