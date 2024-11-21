//
//  DessertCostView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/13/24.
//

import Foundation

extension DessertCostView {
    
    @Observable
    class ViewModel {
        
        //MARK: - Private Properties
        private let dessert: Dessert
        private let calculator: PriceServiceProtocols
        private let nameService: NameServiceProtocols
        
        private var dessertType: DessertType {
            switch dessert.id {
            case 1: return .cheeseCake
            case 2: return .cookie
            case 3: return .cinnaTwist
            case 4: return .iceCream
            default: return .cinnaTwist
            }
        }
        
        //MARK: - ViewInfo
        var toppingInfo: [ToppingInfo] {
            getToppingInfo()
        }
        
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
        
        var isIceCream: Bool {
            dessertType == .iceCream
        }
        
        // MARK: - Enum
        private enum DessertType {
            case cheeseCake
            case cookie
            case cinnaTwist
            case iceCream
        }
        
        //MARK: - Initalization
        init(
            dessert: Dessert,
            calculator: PriceServiceProtocols = ItemPriceCalculator(),
            nameService: NameServiceProtocols = ToppingNameService.shared) {
            self.dessert = dessert
            self.calculator = calculator
            self.nameService = nameService
        }
        
        //MARK: - Pirvate Methods
        private func getToppingInfo() -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            switch dessertType {
            case .cheeseCake, .cookie:
                addInfo(to: &infos)
            case .cinnaTwist:
                addCinnatwistInfo(to: &infos)
            case .iceCream:
                addIceCreamInfo(to: &infos)
            }
            
            return infos
        }
        
        private func addInfo(to infos: inout [ToppingInfo]) {
            let ingredients = dessert.ingredients
            for i in 0..<ingredients!.count {
                let name = nameService.getToppingName(ingredient: ingredients![i])
                let cost = calculator.getPrice(ingredientId: ingredients![i], amount: 1.0) ?? 0.0
                let info = ToppingInfo(name: name, amount: 1.0, cost: cost)
                infos.append(info)
            }
        }
        
        private func addCinnatwistInfo(to infos: inout [ToppingInfo]) {
            guard let ingredients = dessert.ingredients else { return }
            
            for ingredient in ingredients {
                let name = nameService.getToppingName(ingredient: ingredient)
                let amount: Double = ingredient == "cinnaTwist" ? 16.0 :
                                   ingredient == "cinnaSugar" ? 0.05 : 1.0
                let cost = calculator.getPrice(ingredientId: ingredient, amount: amount) ?? 0.0
                let info = ToppingInfo(name: name, amount: amount, cost: cost)
                infos.append(info)
            }
        }
        
        private func addIceCreamInfo(to infos: inout [ToppingInfo]) {
            let iceCreamTypes = dessert.types
            for type in iceCreamTypes! {
                let name =  nameService.getToppingName(ingredient: type)
                let cost = calculator.getPrice(ingredientId: type, amount: 1.0) ?? 0.0
                let info = ToppingInfo(name: name, amount: 1.0, cost: cost)
                infos.append(info)
            }
            
        }
        
    }
}
