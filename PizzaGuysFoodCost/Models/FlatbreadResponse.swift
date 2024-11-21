import Foundation


struct FlatbreadResponse: Codable {
    let flatbread: [Flatbread]
}

struct Flatbread: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let imageName: String
    let toppings: FlatbreadToppings
    
    static let flatbreadExample = Flatbread(
        id: 1,
        name: "Creamy Pesto Artichoke",
        imageName: "pestoArtichokeLogo",
        toppings: FlatbreadToppings(
            ingredients: [
                "dough",
                "pSauce",
                "cheese",
                "tomato",
                "artichoke",
                "basil"
            ],
            quantities: [
                11.0,
                2.0,
                4.0,
                3.0,
                3.0,
                0.15
            ]
        )
    )
}

struct FlatbreadToppings: Codable {
    let ingredients: [String]
    let quantities: [Double]
    
}
