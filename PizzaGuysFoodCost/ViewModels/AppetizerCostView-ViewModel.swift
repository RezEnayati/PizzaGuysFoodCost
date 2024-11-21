//
//  AppetizerCostView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/3/24.
//

import Foundation

extension AppetizerCostView {
    
    @Observable
    class ViewModel {
        
        // MARK: - Properties
        private let appetizer: Appetizer
        private let calculator: PriceServiceProtocols
        private let nameService: NameServiceProtocols
        
        //Info for the View (Single Source of truth)
        var toppingInfo: [ToppingInfo] {
            //get topping info
            getToppingInfo(for: appetizer)
        }
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
        var isSized: Bool
        
        //User selcted Size
        var selectedSize = AppetizerSize.small
        var selectedSauce = SauceType.marinara
            
        // MARK: - Initialization
        init(
            appetizer: Appetizer,
            calculator: PriceServiceProtocols = ItemPriceCalculator(),
            nameService: NameServiceProtocols = ToppingNameService.shared
        ){
            self.appetizer = appetizer
            self.calculator = calculator
            self.nameService = nameService
            self.isSized = if case .sized = appetizer.toppings.quantities {true} else {false}
        }
        
        // MARK: - Enums
        enum SauceType: String, CaseIterable {
            case marinara = "Marinara"
            case ranch = "Ranch"
        }
        
        enum AppetizerSize: String, CaseIterable {
            case small = "Small"
            case large = "Large"
            
            var key: String {
                String(self.rawValue.first!.lowercased())
            }
            
            var boxDescription: String {
                switch self {
                case .small: return "Small Box"
                case .large: return "Medium Box"
                }
            }
        }
        
        // MARK: - Private Methods
        private func getToppingInfo(for appetizer: Appetizer) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            let quantities: [Double]
            if case .sized(let sizes) = appetizer.toppings.quantities, let sizeQuantites = sizes[selectedSize.key] {
                quantities =  sizeQuantites
            } else if case .fixed(let fixedQuantites) = appetizer.toppings.quantities {
                quantities = fixedQuantites
            } else {
                quantities = []
            }
            
            //Add the topping names and the qunatities and the cost for the toppings in the recipe
            for i in 0..<appetizer.toppings.ingredients.count {
                let ingridientId = appetizer.toppings.ingredients[i]
                let toppingAmount = quantities[i]
                
                let toppingName = nameService.getToppingName(ingredient: ingridientId)
                let toppingCost = calculator.getPrice(ingredientId: ingridientId, amount: toppingAmount) ?? 0.0
                
                let topppingInfo = ToppingInfo(name: toppingName, amount: toppingAmount, cost: toppingCost)
                infos.append(topppingInfo)
            }

            // Fixed items
            addFixeditems(to: &infos)
            
            
            //Add the sauce
            addSuace(to: &infos)

            return infos
        }
        
        private func addFixeditems(to infos: inout [ToppingInfo]) {
            if isSized {
                //Add the box insert if its sized and is a large size
                if selectedSize == .large {
                    //the Medium box gets an insert but the small doesnt
                    let insertname = nameService.getToppingName(ingredient: "insert12")
                    let insertCost = calculator.getPrice(ingredientId: "insert12", amount: 1.0) ?? 0.0
                    let insertInfo = ToppingInfo(name: insertname, amount: 1.0, cost: insertCost)
                    infos.append(insertInfo)
                }
                
                //Box
                let boxId = selectedSize == .large ? "mBox" : "sBox"
                let boxName = nameService.getToppingName(ingredient: boxId)
                let boxCost = calculator.getPrice(ingredientId: boxId, amount: 1.0) ?? 0.0
                let boxInfo = ToppingInfo(name: boxName, amount: 1.0, cost: boxCost)
                infos.append(boxInfo)
            } else {
                if appetizer.name == "Muncheez" {
                    //Add foil Sheet Cost
                    let foilSheetName = nameService.getToppingName(ingredient: "foilSheet")
                    let foilCost = calculator.getPrice(ingredientId: "foilSheet", amount: 1.0) ?? 0.0
                    let foilInfo = ToppingInfo(name: foilSheetName, amount: 1.0, cost: foilCost)
                    infos.append(foilInfo)
                } else {
                    //Add Paper Cost
                    let bakingPaperName = nameService.getToppingName(ingredient: "bakingPaper12")
                    let bakingPaperCost = calculator.getPrice(ingredientId: "bakingPaper12", amount: 1.0) ?? 0.0
                    let bakingPaperInfo = ToppingInfo(name: bakingPaperName, amount: 1.0, cost: bakingPaperCost)
                    infos.append(bakingPaperInfo)
                    
                }
                let boxName = nameService.getToppingName(ingredient: "pBox")
                let boxCost = calculator.getPrice(ingredientId: "pBox", amount: 1.0) ?? 0.0
                let boxInfo = ToppingInfo(name: boxName, amount: 1.0, cost: boxCost)
                infos.append(boxInfo)
            }
        }
        
        private func addSuace(to infos: inout [ToppingInfo]) {
            switch selectedSauce {
            case .marinara:
                //ContainerPrice for the marinara:
                let portionCupPrice = calculator.getPrice(ingredientId: "portionCup", amount: 1.0) ?? 0.0
                
                //ContainerLidPrice for the marinara:
                let portionCupLidPrice = calculator.getPrice(ingredientId: "portionCupLid", amount: 1.0) ?? 0.0
                
                //Marinara Suace itself
                let marinaraSauce = calculator.getPrice(ingredientId: "rSauce", amount: 2.0) ?? 0.0
                
                let totalPrice = portionCupPrice + portionCupLidPrice + marinaraSauce
                
                let marinarInfo = ToppingInfo(name: "Marinara Sauce", amount: 1.0, cost: totalPrice)
                infos.append(marinarInfo)
                
            case .ranch:
                let ranchName = nameService.getToppingName(ingredient: "ranch")
                let ranchPrice =  calculator.getPrice(ingredientId: "ranch", amount: 1.0) ?? 0.0
                let ranchInfo =  ToppingInfo(name: ranchName, amount: 1.0, cost: ranchPrice)
                infos.append(ranchInfo)
                
            }
        }
    
    }
}
