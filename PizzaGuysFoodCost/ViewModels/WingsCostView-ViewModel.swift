//
//  WingsCostView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/6/24.
//

import Foundation

extension WingsCostView {
    
    @Observable
    class ViewModel {
        
        //MARK: - Private Properties
        private let wings: Wings
        private let calculator: PriceServiceProtocols
        private let nameService: ToppingNameService
        private let wingType: WingType
        private var boxCount: Double {
            switch wings.quantity {
            case 16.0: return 2.0
            case 24.0: return 3.0
            default: return 1
            }
        }
        
        
        //MARK: - View Information
        var toppingInfo: [ToppingInfo] {
            getToppingInfo(for: wings)
        }
        
        var totalCost: String {
            ToppingInfo.calculateTotalCostFormated(for: toppingInfo)
        }
        
        //MARK: - Types
        private enum WingType {
            case boneIn
            case boneLess
            
            var id: String {
                switch self {
                case.boneIn: return "boneinWing"
                case.boneLess: return "bonelessWing"
                }
            }
        }
        
        // MARK: - Initialization
        init(
            wings: Wings,
            calcluator: PriceServiceProtocols = ItemPriceCalculator(),
            nameService: ToppingNameService = ToppingNameService.shared
        ) {
            self.wings = wings
            self.calculator = calcluator
            self.nameService = nameService
            self.wingType = wings.sauceAmount != nil ? .boneIn : .boneLess
        }
        
        // MARK: - Private Methods
        private func getToppingInfo(for wings: Wings) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
                        
            addWingInfo(to: &infos)
                        
            if wingType == .boneIn {
                addSacueInfo(to: &infos)
            }
            
            addRanchInfo(to: &infos)
            addBakingPaperInfo(to: &infos)
            addBoxInfo(to: &infos)
            
            return infos
        
        }
        
        private func addWingInfo(to infos: inout [ToppingInfo]) {
            let wingName = nameService.getToppingName(ingredient: wingType.id)
            let wingsPrice = calculator.getPrice(ingredientId: wingType.id, amount: wings.quantity) ?? 0.0
            let wingInfo = ToppingInfo(name: wingName, amount: wings.quantity, cost: wingsPrice)
            infos.append(wingInfo)
        }
        
        private func addSacueInfo(to infos: inout [ToppingInfo]) {
            let sauceName = nameService.getToppingName(ingredient: "buffaloSauce")
            let saucePrice = calculator.getPrice(ingredientId: "buffaloSauce", amount: wings.sauceAmount!) ?? 0.0
            let sauceInfo =  ToppingInfo(name: sauceName, amount: wings.sauceAmount!, cost: saucePrice)
            infos.append(sauceInfo)
        }
        
        private func addBakingPaperInfo(to infos: inout  [ToppingInfo]) {
            let paperName = nameService.getToppingName(ingredient: "bakingPaper12")
            let paperPrice = calculator.getPrice(ingredientId: "bakingPaper12", amount: boxCount) ?? 0.0
            let paperInfo = ToppingInfo(name: paperName, amount: boxCount, cost: paperPrice)
            infos.append(paperInfo)
        }
        
        private func addRanchInfo(to infos: inout [ToppingInfo]) {
            let ranchName = nameService.getToppingName(ingredient: "ranch")
            let ranchPrice = calculator.getPrice(ingredientId: "ranch", amount: boxCount) ?? 0.0
            let ranchInfo = ToppingInfo(name: ranchName, amount: boxCount, cost: ranchPrice)
            infos.append(ranchInfo)
        }
        
        private func addBoxInfo(to infos: inout [ToppingInfo]) {
            let boxName = nameService.getToppingName(ingredient: "wBox")
            let boxCost = calculator.getPrice(ingredientId: "wBox", amount: boxCount) ?? 0.0
            let boxInfo = ToppingInfo(name: boxName, amount: boxCount, cost: boxCost)
            infos.append(boxInfo)
        }
        
    }
}
