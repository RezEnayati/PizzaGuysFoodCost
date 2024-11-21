import Foundation

struct MenuCategories: Codable {
    let categories: [Category]
}

struct Category: Codable, Identifiable {
    let id: Int
    let imageName: String
    let name: String
    
    static let example = Category(id: 0, imageName: "pizzaLogo", name: "pizza")
}
