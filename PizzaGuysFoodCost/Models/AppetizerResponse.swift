import Foundation

struct AppetizerResponse: Codable {
    let apps: [Appetizer]
}

struct Appetizer: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let imageName: String
    let toppings: AppToppings
    
}

struct AppToppings: Codable {
    let ingredients: [String]
    let quantities: AppQuantities
    
    // Custom decoding to handle both array and dictionary
    private enum CodingKeys: String, CodingKey {
        case ingredients
        case quantities
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ingredients = try container.decode([String].self, forKey: .ingredients)
        
        // try dictionary first if failed try array
        if let sizedQuantities = try? container.decode([String: [Double]].self, forKey: .quantities) {
            quantities = .sized(sizedQuantities)
        } else {
            let fixedQuantities = try container.decode([Double].self, forKey: .quantities)
            quantities = .fixed(fixedQuantities)
        }
    }
}


enum AppQuantities: Codable {
    case sized([String: [Double]])
    case fixed([Double])
    
    
}



// For testing with the view only 
extension AppToppings {
    init(ingredients: [String], quantities: AppQuantities) {
        self.ingredients = ingredients
        self.quantities = quantities
    }
}

extension Appetizer {
    static let sampleBread = Appetizer(
            id: 1,
            name: "Bacon Bread",
            imageName: "baconBreadLogo",
            toppings: AppToppings(
                ingredients: ["dough", "wSauce", "cheese", "bacon"],
                quantities: .sized([
                    "s": [11.0, 2.0, 2.0, 2.0],
                    "l": [15.0, 3.0, 3.0, 3.0]
                ])
            )
        )
        
        // Sample roll with fixed quantities
        static let sampleRoll = Appetizer(
            id: 6,
            name: "Cheezee Garlic Rolls",
            imageName: "garlicRollLogo",
            toppings: AppToppings(
                ingredients: ["dough", "wSauce", "cheese", "mincedGarlic"],
                quantities: .fixed([11.0, 3.0, 4.0, 0.5])
            )
        )
        
        // Sample muncheez with single ingredient
        static let sampleMuncheez = Appetizer(
            id: 9,
            name: "Muncheez",
            imageName: "muncheezLogo",
            toppings: AppToppings(
                ingredients: ["muncheez"],
                quantities: .fixed([10.0])
            )
        )
}
