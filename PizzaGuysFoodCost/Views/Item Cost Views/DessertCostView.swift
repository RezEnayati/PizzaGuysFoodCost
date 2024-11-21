//
//  DessertCostView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/13/24.
//

import SwiftUI

struct DessertCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(dessert: Dessert) {
        _viewModel = State(initialValue: ViewModel(dessert: dessert))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                
                ingredientsStack
                
                amountsStack
                
                costsStack
                
            }
            
            if !viewModel.isIceCream {
                totalCost
            }
        }
    }
    
    //MARK: View Properties
    private var ingredientsStack: some View {
        VStack(alignment: .leading) {
            viewModel.toppingInfo.count == 1 ? Text("Ingredient:").bold() : Text("Ingredients:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                Text("\(info.name)")
            }
        }
        .padding(.leading)
    }
    
    private var amountsStack: some View {
        VStack(alignment: .leading) {
            Text("Amount:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self) {info in
                Text(String(format: "%.2f", info.amount))
            }
        }
        .padding(.leading)
    }
    
    private var costsStack: some View {
        VStack(alignment: .leading) {
            Text("Cost:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                Text(String(format: "%.2f", info.cost))
                
            }
        }
        .padding(.leading)

    }
    
    private var totalCost: some View {
        Group {
            Divider()
            HStack{
                Text("Total Cost: $\(viewModel.totalCost)")
                    .bold()
                    .padding(.bottom)
                
                Spacer()
            }
            .padding(.leading)

        }
    }
    
}

#Preview {
    DessertCostView(dessert: .dessertExample)
}
