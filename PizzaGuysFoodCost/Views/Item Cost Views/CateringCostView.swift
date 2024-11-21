//
//  CateringCostView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/13/24.
//

import SwiftUI

struct CateringCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(cateringItem: CateringItem) {
        _viewModel = State(initialValue: ViewModel(cateringItem: cateringItem))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                
                ingredientsStack
                
                amountsStack
                
                costsStack
                
            }
            
            Divider()
            
            if viewModel.isSalad {
                HStack {
                    
                    dressingPicker

                }
                .padding(.horizontal)
                
                Divider()
                
            }
            
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
            ForEach(viewModel.toppingInfo, id: \.self) {info in
                Text(String(format: "%.2f", info.cost))
            }
        }
        .padding(.leading)

    }
    
    private var totalCost: some View {
        Text("Total Cost: $\(viewModel.totalCost)")
            .bold()
            .padding(.bottom)
    }
    
    //Picker
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
            .padding(.leading)
            .pickerStyle(.menu)
            .tint(Color.pizzaGuysRed)
        }
    }
    
    
}

#Preview {
    CateringCostView(cateringItem: .saladExample)
}
