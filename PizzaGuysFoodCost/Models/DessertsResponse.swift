import Foundation

struct DessertsResponse: Codable {
    let desserts: [Dessert]
}

struct Dessert: Codable, Identifiable, MenuItem {
    let id: Int
    let name: String
    let imageName: String
    let ingredients: [String]?
    let types: [String]?
    
    static let dessertExample = Dessert(
        id: 1,
        name: "Cookie",
        imageName: "dessertsLogo",
        ingredients: ["cookie", "bakingPaper14", "cBox"],
        types: nil)
}
