//
//  ExtrasView-ViewModel.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/15/24.
//

import Foundation

extension ExtrasView {
    
    @Observable
    class ViewModel {
        
        //MARK: - Private Properties
        private let nameService: NameServiceProtocols
        private let calculator: ItemPriceCalculator
        
        private var sauces = [String]()
        private var dressings = [String]()
        private var sides = [String]()
        private var miscs = [String]()
        private var uniforms = [String]()
        
        //MARK: - View Info
        var isLoading = true
        var error: Error?
        
        var sauceInfo: [ToppingInfo] {
            getSauceInfo()
        }
        
        var sideInfo: [ToppingInfo] {
            getSideInfo()
        }
        
        var dressingsInfo: [ToppingInfo] {
            getDressingsInfo()
        }
        
        var miscInfo: [ToppingInfo] {
            getInfo(for: miscs)
        }
        
        var uniformInfo: [ToppingInfo] {
            getInfo(for: uniforms)
        }
        
        //MARK: - Initizalization
        
        init(
            nameService: NameServiceProtocols = ToppingNameService.shared,
            calculator: ItemPriceCalculator = ItemPriceCalculator()
        ){
            self.nameService = nameService
            self.calculator = calculator
            Task {
                await loadExtras()
            }
            
        }
        
        // MARK: JSON Loading methods
        private func loadJSONFile() throws -> Data {
            
            guard let path = Bundle.main.path(forResource: "extras", ofType: "json") else {
                throw NSError(domain: "couldNotFindFile", code: 404, userInfo: [NSDebugDescriptionErrorKey: "Could not find extras.json in directory"])
            }
            
            let url = URL(filePath: path)
            return try Data(contentsOf: url)
        }
        
        @MainActor
        private func loadExtras() async {
            isLoading = true
            defer {isLoading = false}
            
            do {
                let data = try loadJSONFile()
                let decoder = JSONDecoder()
                let results = try decoder.decode(Extras.self, from: data)
                assignExtras(from: results)
            } catch {
                self.error = error
                print("There was an error decoding the extras file: \(error.localizedDescription)")
            }
        }
        
        //MARK: assignment
        private func assignExtras(from extras: Extras) {
            sauces = extras.sauces
            dressings = extras.dressings
            sides = extras.sides
            miscs = extras.misc
            uniforms = extras.uniforms
        }
        
        //MARK: Item Info
        // Sauce
        private func getSauceInfo() -> [ToppingInfo] {
            var infos = [ToppingInfo] ()
            let containerCost = getContainerCost()
            for sauce in sauces {
                if sauce == "ranch" || sauce == "cholula" {
                    let name = nameService.getToppingName(ingredient: sauce)
                    let cost = calculator.getPrice(ingredientId: sauce, amount: 1.0) ?? 0.0
                    let info = ToppingInfo(name: name, amount: 1.0, cost: cost)
                    infos.append(info)
                } else {
                    let name = nameService.getToppingName(ingredient: sauce)
                    let cost =  calculator.getPrice(ingredientId: sauce, amount: 2.0) ?? 0.0
                    let totalCost =  cost + containerCost
                    let toppingInfo =  ToppingInfo(name: name, amount: 2.0, cost: totalCost)
                    infos.append(toppingInfo)
                }
                
            }
            return infos
        }
        
        // Sides
        private func getSideInfo() -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            let noContainerItems = ["parmesanPacket", "crushedRedPepper"]
            
            for side in sides {
                let name = nameService.getToppingName(ingredient: side)
                var cost = calculator.getPrice(ingredientId: side, amount: side == "lime" ? 0.5 : 1.0) ?? 0.0
                
                if !noContainerItems.contains(side) {
                    cost += getContainerCost()
                }
                
                let info = ToppingInfo(name: name, amount: 1.0, cost: cost)
                infos.append(info)
            }
            return infos
        }
        
        // Dressings
        private func getDressingsInfo() -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            
            for dressing in dressings {
                let name = nameService.getToppingName(ingredient: dressing)
                let cost =  calculator.getPrice(ingredientId: dressing, amount: 1.0) ?? 0.0
                infos.append(ToppingInfo(name: name, amount: 1.0, cost: cost))
            }
            
            return infos
        }
        
        // Misc
        private func getInfo(for items: [String]) -> [ToppingInfo] {
            var infos = [ToppingInfo]()
            for item in items {
                let name = nameService.getToppingName(ingredient: item)
                let cost = (item == "glove" ?
                    calculator.getPrice(ingredientId: item, amount: 2.0) :
                    calculator.getPrice(ingredientId: item, amount: 1.0)) ?? 0.0

                infos.append(ToppingInfo(name: name, amount: 1.0, cost: cost))
            }
            return infos
        }
        
        private func getContainerCost() -> Double {
            let containerCost = calculator.getPrice(ingredientId: "portionCup", amount: 1.0) ?? 0.0
            let containerLidCost = calculator.getPrice(ingredientId: "portionCupLid", amount: 1.0) ?? 0.0
            return containerCost + containerLidCost
        }
        
    }
}
