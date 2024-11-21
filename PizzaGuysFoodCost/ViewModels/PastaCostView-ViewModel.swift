//
//  PastaCostView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/6/24.
//

import Foundation

extension PastaCostView {
    
    @Observable
    class ViewModel {
        
        // MARK: - Private Properties
        private let pasta: Pasta
        private let calculator: PriceServiceProtocols
        private let nameService: NameServiceProtocols
        
        // MARK: - View Information
        var toppingInfo: [ToppingInfo] {
            getPastaInfo(for: pasta)
        }
        
        var needsFork: Bool = false
        
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
                
        // MARK: - Initialization
        init(
            pasta: Pasta,
            calculator: PriceServiceProtocols = ItemPriceCalculator(),
            nameService: NameServiceProtocols = ToppingNameService.shared
        ) {
            self.pasta = pasta
            self.calculator = calculator
            self.nameService = nameService
        }
        
        // MARK: - Constants
        private enum Constants {
            static let calzoneBoxId: String = "calzoneBox"
            static let insert12Id: String = "insert12"
            static let insert12Name: String = "Insert(12\") (1/2)"
            static let pastaContainerId: String = "pastaContainer"
            static let pastaLidId: String = "pastaLid"
            static let doughId: String = "dough"
            static let wSauceId: String = "wSauce"
            static let cheeseId: String = "cheese"
            static let garlicBreadName: String = "Garlic Bread"
            static let forkId: String = "fork"
            static let forkName: String = "Fork"
        }
        
        // MARK: - Private Methods
        private func getPastaInfo(for pasta: Pasta) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            addPastaToppingsInfo(to: &infos)
            
            addGarlicBread(to: &infos)
            
            addFixedItems(to: &infos)
            
            if needsFork == true {
                addForkInfo(to: &infos)
            }
            
            return infos
        }
        
        private func addPastaToppingsInfo(to infos: inout [ToppingInfo]) {
            let ingredients = pasta.toppings.ingredients
            let quantities = pasta.toppings.quantities
            
            for i in 0..<ingredients.count {
                let toppingName = nameService.getToppingName(ingredient: ingredients[i])
                let toppingAmount = quantities[i]
                let toppingCost = calculator.getPrice(ingredientId: ingredients[i], amount: toppingAmount) ?? 0.0
                let toppingInfo = ToppingInfo(name: toppingName, amount: toppingAmount, cost: toppingCost)
                infos.append(toppingInfo)
            }
        }
        
        private func addFixedItems(to infos: inout [ToppingInfo]) {
            
            // Add Box Cost
            let boxName = nameService.getToppingName(ingredient: Constants.calzoneBoxId)
            let boxCost = calculator.getPrice(ingredientId: Constants.calzoneBoxId, amount: 1.0) ?? 0.0
            let boxInfo = ToppingInfo(name: boxName, amount: 1.0, cost: boxCost)
            infos.append(boxInfo)
            
            // Add insert Cost
            let insertCost = calculator.getPrice(ingredientId: Constants.insert12Id, amount: 1.0) ?? 0.0
            // We use half of the insert
            let insertInfo = ToppingInfo(name: Constants.insert12Name, amount: 0.5, cost: insertCost/2)
            infos.append(insertInfo)
            
            //Add pasta Container
            let containerName =  nameService.getToppingName(ingredient: Constants.pastaContainerId)
            let containerCost = calculator.getPrice(ingredientId: Constants.pastaContainerId, amount: 1.0) ?? 0.0
            let containerInfo =  ToppingInfo(name: containerName, amount: 1.0, cost: containerCost)
            infos.append(containerInfo)
            
            // Add container Lid Cost
            let lidName = nameService.getToppingName(ingredient: Constants.pastaLidId)
            let lidCost = calculator.getPrice(ingredientId: Constants.pastaLidId, amount: 1.0) ?? 0.0
            let lidInfo = ToppingInfo(name: lidName, amount: 1.0, cost: lidCost)
            infos.append(lidInfo)
            
                
        }
        
        private func addGarlicBread(to infos: inout [ToppingInfo]) {
            var cost = 0.0
            
            guard let doughCost = calculator.getPrice(ingredientId: Constants.doughId, amount: 4.0), let wSauceCost = calculator.getPrice(ingredientId: Constants.wSauceId, amount: 1.0), let cheeseCost = calculator.getPrice(ingredientId: Constants.cheeseId, amount: 1.0) else {return}
            
            cost = doughCost + wSauceCost + cheeseCost
            
            let garlicBreadInfo = ToppingInfo(name: Constants.garlicBreadName, amount: 1.0, cost: cost)
            infos.append(garlicBreadInfo)
            
        }
        
        private func addForkInfo(to infos: inout [ToppingInfo]) {
            let forkCost = calculator.getPrice(ingredientId: Constants.forkId, amount: 1.0) ?? 0.0
            let forkInfo = ToppingInfo(name: Constants.forkName, amount: 1.0, cost: forkCost)
            infos.append(forkInfo)
        }
        
    }
}
