//
//  SaladCostView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/6/24.
//

import Foundation


extension SaladCostView {
    
    @Observable
    class ViewModel {
        
        // MARK: -Private Properties
        private let salad: Salad
        private let nameService: NameServiceProtocols
        private let calculator: ItemPriceCalculator
        
        
        // MARK: - ViewInfo
        var toppingInfo: [ToppingInfo] {
            getSaladInfo(for: salad)
        }
        
        var needsFork: Bool = false
        
        var selectedDressing = Dressings.ranch
        
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
        
        // MARK: Dressings Enum:
        enum Dressings: String, CaseIterable {
            case ranch = "ranchDressing"
            case balsamic = "balsamicDressing"
            case italian = "italianDressing"
            case blueCheese = "blueCheeseDressing"
            case thousandIsland = "thousandIslandDressing"
            
            var displayName: String {
                ToppingNameService.shared.getToppingName(ingredient: self.rawValue)
            }
        }
        
        // MARK: - Constants:
        private enum Constants {
            static let saladContainer = "saladContainer"
            static let saladLid = "saladLid"
            static let forkId = "fork"
            
        }
        
        // MARK: -Initizilization
        init(
            salad: Salad,
            nameService: NameServiceProtocols = ToppingNameService.shared,
            calculator: ItemPriceCalculator = ItemPriceCalculator()
        ) {
            self.salad = salad
            self.nameService = nameService
            self.calculator = calculator
        }
        
        // MARK: -Private Methods
        private func getSaladInfo(for salad: Salad) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            addToppingInfo(to: &infos)
            
            addContainerInfo(to: &infos)
            
            if needsFork {
                addForkInfo(to: &infos)
            }
            
            addSuaceInfo(to: &infos)
            
            return infos
        }
        
        private func addToppingInfo(to infos: inout [ToppingInfo]) {
            let ingredients = salad.toppings.ingredients
            let quantites = salad.toppings.quantities
            
            for i in 0..<ingredients.count {
                let topping = ingredients[i]
                let amount = quantites[i]
                let toppingName = nameService.getToppingName(ingredient: topping)
                let cost = calculator.getPrice(ingredientId: topping, amount: amount) ?? 0.0
                let toppingInfo = ToppingInfo(name: toppingName, amount: amount, cost: cost)
                infos.append(toppingInfo)
            }
        }
        
        private func addContainerInfo(to infos: inout [ToppingInfo]) {
            
            // Container Cost
            let containerName = nameService.getToppingName(ingredient: Constants.saladContainer)
            let containerCost = calculator.getPrice(ingredientId: Constants.saladContainer, amount: 1.0) ?? 0.0
            let containerInfo = ToppingInfo(name: containerName, amount: 1.0, cost: containerCost)
            infos.append(containerInfo)
            
            // Container Lid Cost
            let containerLidName = nameService.getToppingName(ingredient: Constants.saladLid)
            let containerLidCost = calculator.getPrice(ingredientId: Constants.saladLid, amount: 1.0) ?? 0.0
            let containerLidInfo = ToppingInfo(name: containerLidName, amount: 1.0, cost: containerLidCost)
            infos.append(containerLidInfo)
        }
        
        private func addForkInfo(to infos: inout [ToppingInfo]) {
            let forkCost = calculator.getPrice(ingredientId: Constants.forkId, amount: 1.0) ?? 0.0
            let forkInfo = ToppingInfo(name: "Fork", amount: 1.0, cost: forkCost)
            infos.append(forkInfo)
        }
        
        private func addSuaceInfo(to infos: inout [ToppingInfo]) {
            let dressingName = nameService.getToppingName(ingredient: selectedDressing.rawValue)
            let dressingCost = calculator.getPrice(ingredientId: selectedDressing.rawValue, amount: 1.0) ?? 0.0
            let dressingInfo = ToppingInfo(name: dressingName, amount: 1.0, cost: dressingCost)
            infos.append(dressingInfo)
        }
    
    }
    
}
