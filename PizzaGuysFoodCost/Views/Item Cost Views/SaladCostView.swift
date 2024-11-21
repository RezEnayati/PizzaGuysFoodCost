//
//  SaladCostView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/6/24.
//

import SwiftUI

struct SaladCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(salad: Salad) {
        _viewModel = State(wrappedValue: ViewModel(salad: salad))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                
                ingredientsStack
                
                amountsStack
                
                costStack
            }
            
            Divider()
            
            forkToggle
            
            HStack {
                
                dressingPicker
                
            }
            .padding(.horizontal)
            
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
        VStack(alignment: .leading){
            Text("Ingredients:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self){ info in
                Text("\(info.name)")
            }
        }
        .padding(.leading)
    }
    
    private var amountsStack: some View {
        VStack(alignment: .leading){
            Text("Amount:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self){ info in
                Text(String(format: "%.2f", info.amount))
            }
        }
        .padding(.leading)
    }
    
    private var costStack: some View {
        VStack(alignment: .leading){
            Text("Cost:")
                .bold()
            ForEach(viewModel.toppingInfo, id: \.self){ info in
                Text(String(format: "%.2f", info.cost))
            }
        }
        .padding(.leading)
    }
    
    private var totalCost: some View {
        Text("Total Cost: $\(viewModel.totalCost)")
            .bold()
    }
    
    //Dressing Picker and fork toggle
    private var dressingPicker: some View {
        
        Group {
            Text("Select Dressing:")
            
            Spacer()
            
            Picker("Select Dressing", selection: $viewModel.selectedDressing) {
                ForEach(ViewModel.Dressings.allCases, id: \.self) {dressing in
                    Text("\(dressing.displayName)")
                }
            }
            .transaction { transaction in
                transaction.animation = nil
            }
            .pickerStyle(.menu)
            .tint(Color.pizzaGuysRed)
        }
    }
    
    private var forkToggle: some View {
        Toggle("Include Fork?", isOn: $viewModel.needsFork)
            .padding(.trailing)
            .padding(.horizontal)
    }
    
}

#Preview {
    SaladCostView(salad: .saladExample)
}
