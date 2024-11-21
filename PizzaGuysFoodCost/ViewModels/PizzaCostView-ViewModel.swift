import Foundation

extension PizzaCostView {
    
    @Observable
    class ViewModel {
        // MARK: - Private Properties
        private let pizza: Pizza
        private var calculator: PriceServiceProtocols
        private var nameService: NameServiceProtocols
        
        // MARK: - Public Properties
        private(set) var hasDifferentSizes: Bool
        
        var toppingInfo: [ToppingInfo] {
            getToppingInfo(for: pizza, sizeKey: sizeKey)
        }
        
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
        
        var isMedium: Bool {
            sizeKey == "m"
        }
        
        var isGluttenFree: Bool = false
        
        // MARK: - Size Properties
        var selectedSize = Constants.largeSize {
            didSet {
                isGluttenFree = false
            }
        }
        
        private var sizeKey: String {
            if Self.sizesAvailable(for: pizza) {
                return selectedSize.prefix(1).lowercased()
            } else {
                return "l"
            }
        }
        
        // MARK: - Constants
        private enum Constants {
            static let insert12Id: String = "insert12"
            static let insert14Id: String = "insert14"
            static let largeSize: String = "Large"
            static let sBox: String = "sBox"
            static let mBox: String = "mBox"
            static let lBox: String = "lBox"
            static let xBox: String = "xBox"
            static let lidSupportId: String = "lidSupport"
            static let glutenFreeId: String = "glutenFreeCrust"
            static let doughId: String = "dough"
        }
        
        // MARK: - Initialization
        init(
            pizza: Pizza,
            nameService: NameServiceProtocols = ToppingNameService.shared,
            calculator: PriceServiceProtocols = ItemPriceCalculator()
        ){
            self.pizza = pizza
            self.nameService = nameService
            self.calculator = calculator
            self.hasDifferentSizes = Self.sizesAvailable(for: pizza)
        }
        
        // MARK: - Helper Methods
        private static func sizesAvailable(for pizza: Pizza) -> Bool {
            let quantites = pizza.toppings.quantities
            
            if quantites.count > 1 {
                return true
            } else {
                return false
            }
        }
        
        private func getToppingInfo(for pizza: Pizza, sizeKey: String) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            let ingridients = pizza.toppings.ingredients
            let toppingAmounts = pizza.toppings.quantities[sizeKey] ?? []
            
            // Add pizza ingredients
            addPizzaIngredients(ingredients: ingridients, amounts: toppingAmounts, to: &infos)
            
            // If the crust is gluten Freen, remove dough cost and insert gluten free cost
            if isGluttenFree && sizeKey == "m" {
                infos.removeAll { topping in
                    topping.name == nameService.getToppingName(ingredient: Constants.doughId)
                }
                infos.insert(getGlutenFreeInfo(), at: 0)
            }
            
            // Add fixed items
            addBoxInfo(for: sizeKey, to: &infos)
            addLidSupportInfo(to: &infos)
            
            // Add box insert for medium and larger pizzas
            if sizeKey != "s" {
                addBoxInsertInfo(for: sizeKey, to: &infos)
            }
            
            
            return infos
        }
        
        private func addPizzaIngredients(ingredients: [String], amounts: [Double], to infos: inout [ToppingInfo]) {
            for i in 0..<ingredients.count {
                let ingridentId = ingredients[i]
                let amount = amounts[i]
                
                let name = nameService.getToppingName(ingredient: ingridentId)
                let cost = calculator.getPrice(ingredientId: ingridentId, amount: amount) ?? 0.0
                
                let info = ToppingInfo(name: name, amount: amount, cost: cost)
                infos.append(info)
            }
        }
        
        private func addBoxInfo(for sizeKey: String, to infos: inout [ToppingInfo]) {
            let boxType = getBoxType(for: sizeKey)
            let boxCost = calculator.getPrice(ingredientId: boxType, amount: 1.0) ?? 0.0
            let boxName = nameService.getToppingName(ingredient: boxType)
            let boxInfo = ToppingInfo(name: boxName, amount: 1.0, cost: boxCost)
            infos.append(boxInfo)
        }
        
        private func addLidSupportInfo(to infos: inout [ToppingInfo]) {
            let lidSupportCost = calculator.getPrice(ingredientId: Constants.lidSupportId, amount: 1.0) ?? 0.0
            let lidSupportName = nameService.getToppingName(ingredient: Constants.lidSupportId)
            let lidSupportInfo = ToppingInfo(name: lidSupportName, amount: 1.0, cost: lidSupportCost)
            infos.append(lidSupportInfo)
        }
        
        private func addBoxInsertInfo(for sizeKey: String, to infos: inout [ToppingInfo]) {
            let insertId = sizeKey == "m" ? Constants.insert12Id : Constants.insert14Id
            let insertCost = calculator.getPrice(ingredientId: insertId, amount: 1.0) ?? 0.0
            let insertName = nameService.getToppingName(ingredient: insertId)
            let insertInfo = ToppingInfo(name: insertName, amount: 1.0, cost: insertCost)
            infos.append(insertInfo)
        }
        
        private func getBoxType(for sizeKey: String) -> String {
            switch sizeKey {
            case "s": return Constants.sBox
            case "m": return Constants.mBox
            case "l": return Constants.lBox
            default: return Constants.xBox
            }
        }
        
        private func getGlutenFreeInfo() -> ToppingInfo {
            let crustName = nameService.getToppingName(ingredient: Constants.glutenFreeId)
            let crustCost = calculator.getPrice(ingredientId: Constants.glutenFreeId, amount: 1.0) ?? 0.0
            let glutenFreeInfo = ToppingInfo(name: crustName, amount: 1.0, cost: crustCost)
            return glutenFreeInfo
            
        }
    }
}
