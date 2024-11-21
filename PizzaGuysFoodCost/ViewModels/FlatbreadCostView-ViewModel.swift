import Foundation

extension FlatbreadCostView {
    
    @Observable
    class ViewModel {
        // MARK: - Private Properties
        private let flatbread: Flatbread
        private let calculator: PriceServiceProtocols
        private let nameService: NameServiceProtocols
        
        // MARK: - Public Properties
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingsInfo)
        }
        
        private(set) var toppingsInfo: [ToppingInfo]
        
        // MARK: - Constants
        private enum Constants {
            static let insert12Id: String = "insert12"
            static let insertName: String = "Insert(12\") (1/2)"
            static let boxId: String = "fBox"
            static let boxName: String = "Flatbread Box"
        }
        
        // MARK: - Initialization
        init(
            flatbread: Flatbread,
            calculator: PriceServiceProtocols = ItemPriceCalculator(),
            nameService: NameServiceProtocols = ToppingNameService.shared
        ) {
            self.flatbread = flatbread
            self.calculator = calculator
            self.nameService = nameService
            self.toppingsInfo = Self.getToppingInfo(
                flatbread: flatbread,
                calculator: calculator,
                nameService: nameService)
        }
        
        // MARK: - Private Method
        private static func getToppingInfo(
            flatbread: Flatbread,
            calculator: PriceServiceProtocols,
            nameService: NameServiceProtocols
        ) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            // Add flatbread ingredients
            for i in 0..<flatbread.toppings.ingredients.count {
                let ingrident = flatbread.toppings.ingredients[i]
                let amount = flatbread.toppings.quantities[i]
                
                let name = nameService.getToppingName(ingredient: ingrident)
                let cost = calculator.getPrice(ingredientId: ingrident, amount: amount) ?? 0.0
                
                let info = ToppingInfo(name: name, amount: amount, cost: cost)
                infos.append(info)
            }
            
            // Fixed Items
            
            // Box Insert
            let insertPrice = (calculator.getPrice(ingredientId: Constants.insert12Id, amount: 1.0) ?? 0.0) / 2
            // Flatbreads use 1/2 of a 12" insert so we have to divide by two
            infos.append(ToppingInfo(name: Constants.insertName, amount: 1.0, cost: insertPrice))
            
            // Box
            let boxPrice = calculator.getPrice(ingredientId: Constants.boxId, amount: 1.0) ?? 0.0
            let boxName = nameService.getToppingName(ingredient: Constants.boxId)
            infos.append(ToppingInfo(name: boxName, amount: 1.0, cost: boxPrice))
            
            return infos
        }
    }
}
