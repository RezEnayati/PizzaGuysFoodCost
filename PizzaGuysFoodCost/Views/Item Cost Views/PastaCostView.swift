//
//  PastaCostView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/6/24.
//

import SwiftUI

struct PastaCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(pasta: Pasta) {
        _viewModel = State(initialValue: ViewModel(pasta: pasta))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                
                ingredientsStack
                
                amountsStack
                
                costsStack

            }
            
            Divider()
            
            forkToggle
            
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
                Text("\(info.name)")
            }
        }
        .padding(.leading)
    }
    
    private var amountsStack: some View {
        VStack(alignment: .leading) {
            Text("Amount:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self) { info in
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
        Text("Total Cost: $\(viewModel.totalCost)")
            .bold()
    }
    
    //Fork Toggle 
    private var forkToggle: some View {
        Toggle("Include Fork?", isOn: $viewModel.needsFork)
            .padding(.trailing)
            .padding(.horizontal)
    }
    
    
}

#Preview {
    PastaCostView(pasta: .pastaExample)
}
