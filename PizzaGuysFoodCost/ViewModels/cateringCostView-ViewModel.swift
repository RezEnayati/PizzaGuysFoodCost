//
//  cateringCostView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/13/24.
//

import Foundation


extension CateringCostView {
    
    @Observable
    class ViewModel {
        
        // MARK: - Private Properties
        private let cateringItem: CateringItem
        private let calculator: PriceServiceProtocols
        private let nameService: NameServiceProtocols
        
        // MARK: - View Information
        var toppingInfo: [ToppingInfo] {
            getCateringInfo()
        }
        
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
        
        var selectedDressing = Dressings.ranch
        
        var isSalad: Bool {
            cateringItem.type == "salad"
        }
        
        // MARK: - Dressings
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
        
        // MARK: - Initazilation
        init(
            cateringItem: CateringItem,
            calculator: PriceServiceProtocols = ItemPriceCalculator(),
            nameService: NameServiceProtocols = ToppingNameService.shared) {
            self.cateringItem = cateringItem
            self.calculator = calculator
            self.nameService = nameService
        }
        
        // MARK: - Pirvate Methods
        private func getCateringInfo() -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            // Add topping info
            addToppingInfo(to: &infos)
            
            //Add Container Info
            addContainerInfo(to: &infos)
            
            if cateringItem.type == "pasta" {
                
                // Add Garlic Bread Info
                addGarlicBreadInfo(to: &infos)
                
            } else if cateringItem.type == "salad" {
                
                // Add the dressing Inforamtion for the salads
                addDressingInfo(to: &infos)
                
            }
            
            return infos
        }
        
        private func addToppingInfo(to infos: inout [ToppingInfo]) {
            
            let ingredients = cateringItem.toppings.ingredients
            let quantites =  cateringItem.toppings.quantities
            
            
            for i in 0..<ingredients.count {
                let ingredientId = ingredients[i]
                let amount = quantites[i]
                let ingredientName = nameService.getToppingName(ingredient: ingredientId)
                let ingredientCost = calculator.getPrice(ingredientId: ingredientId, amount: amount) ?? 0.0
                let toppingInfo = ToppingInfo(name: ingredientName, amount: amount, cost: ingredientCost)
                infos.append(toppingInfo)
            }
        }
        
        private func addContainerInfo(to infos: inout [ToppingInfo]) {
            //Container Info
            let containerName = nameService.getToppingName(ingredient: "cateringContainer")
            let containerCost = calculator.getPrice(ingredientId: "cateringContainer", amount: 1.0) ?? 0.0
            let containerInfo = ToppingInfo(name: containerName, amount: 1.0, cost: containerCost)
            infos.append(containerInfo)
            
            //Container lid Info
            let lidName = nameService.getToppingName(ingredient: "cateringLid")
            let lidCost = calculator.getPrice(ingredientId: "cateringLid", amount: 1.0) ?? 0.0
            let lidInfo = ToppingInfo(name: lidName, amount: 1.0, cost: lidCost)
            infos.append(lidInfo)
            
            
        }
        
        private func addGarlicBreadInfo(to infos: inout [ToppingInfo]) {
            
            var totalCost = 0.0
            let garlicBreadToppings = ["dough", "cheese", "wSauce", "sBox"]
            let garlicBreadQuantities = [11.0, 2.0, 2.0, 1.0]
            
            for i in 0..<garlicBreadToppings.count {
                
                guard let cost =  calculator.getPrice(ingredientId: garlicBreadToppings[i], amount: garlicBreadQuantities[i]) else { return }
                totalCost += cost
            }
            
            let garlicBreadInfo = ToppingInfo(name: "Garlic Bread (w/ Box)", amount: 1.0, cost: totalCost)
            
            infos.append(garlicBreadInfo)
            
        }
        
        private func addDressingInfo(to infos: inout [ToppingInfo]) {
            let dreesingCost = calculator.getPrice(ingredientId: selectedDressing.rawValue, amount: 10.0) ?? 0.0
            let dressingInfo = ToppingInfo(name: selectedDressing.displayName, amount: 10.0 , cost: dreesingCost)
            infos.append(dressingInfo)
            
        }
        
    }
    
}
