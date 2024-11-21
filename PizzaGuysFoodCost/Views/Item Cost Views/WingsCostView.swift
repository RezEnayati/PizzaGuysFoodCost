//
//  WingsCostView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/6/24.
//

import SwiftUI

struct WingsCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(wings: Wings) {
        _viewModel = State(initialValue: ViewModel(wings: wings))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                
                ingredientsStack
                
                amountStack
                
                costStack

            }
            
            Divider()
            
            HStack{
                
                totalCost
                
                Spacer()
                
            }
            .padding(.leading)
        }
    }
    
    //MARK: View Properties
    private var ingredientsStack: some View {
        VStack(alignment: .leading) {
            Text("Ingredients:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                Text(info.name)
            }
        }
        .padding(.leading)
    }
    
    private var amountStack: some View {
        VStack(alignment: .leading) {
            Text("Amount:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                Text(String(format: "%.2f", info.amount))
            }
        }
        .padding(.leading)
    }
    
    private var costStack: some View {
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
        Text("Total Cost: $\(viewModel.totalCost)")
            .bold()
    }
}

#Preview {
    WingsCostView(wings: .regularWingsExample)
}
