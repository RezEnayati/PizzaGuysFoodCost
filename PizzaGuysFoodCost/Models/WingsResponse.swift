import Foundation

struct WingsResponse: Codable {
    let wings: [Wings]
}

struct Wings: Codable, Identifiable, MenuItem{
    let id: Int
    let name: String
    let imageName: String
    let quantity: Double
    let dippingSauceQty: Int
    let sauceAmount: Double?
    
    static let regularWingsExample = Wings(
        id: 1,
        name: "8PCs Wings",
        imageName: "8wingsLogo",
        quantity: 8,
        dippingSauceQty: 1,
        sauceAmount: 2.5
    )
    
    
    static let bonelessWingsExample = Wings(
        id: 5,
        name: "8 Boneless Wings",
        imageName: "8BoneLessLogo",
        quantity: 8,
        dippingSauceQty: 1,
        sauceAmount: nil
    )
    
}
