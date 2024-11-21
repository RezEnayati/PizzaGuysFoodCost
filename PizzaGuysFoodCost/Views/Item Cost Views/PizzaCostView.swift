import SwiftUI

struct PizzaCostView: View {
    
    let pizza: Pizza
    
    @State private var viewModel: ViewModel
    
    // Sizes for the picker
    let sizes: [String] = ["Small", "Medium", "Large", "X Large"]
    
    init(pizza: Pizza) {
        self.pizza = pizza
        _viewModel = State(initialValue: ViewModel(pizza: pizza))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            sizePicker
            
            Divider()
            
            HStack(alignment: .top) {
            
                ingredientsStack
                
                amountsStack

                costStack
            }
            
            if viewModel.isMedium {
                
                Divider()
                
                mediumToggle
            }
            
            Divider()
            
            HStack {
                
                totalCost
                
                Spacer()
            }
        }
    }
    
    //MARK: View Properties
    private var ingredientsStack: some View {
        VStack(alignment: .leading) {
            Text("Ingredients:")
                .bold()
                
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                HStack {
                    Text("\(info.name)")
                        
                }
            }
        }
        .padding(.leading)
    }
    
    private var amountsStack: some View {
        VStack(alignment: .leading) {
            Text("\(viewModel.selectedSize):")
                .bold()
            
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                Text(String(format: "%.1f", info.amount))
            }
        }
        .padding(.leading)
    }
    
    private var costStack: some View {
        VStack(alignment: .leading) {
            Text("Cost:")
                .bold()
            
            ForEach(viewModel.toppingInfo, id: \.self) { info in
                Text(String(format: "$%.2f", info.cost))
            }
        }
        .padding(.leading)
    }
    
    private var totalCost: some View {
        Text("Total Cost: $\(viewModel.totalCost)")
            .bold()
            .padding(.leading)
            .padding(.bottom)
    }
    
    // Toggle and Picker
    private var sizePicker: some View {
        Picker("Select Size", selection: $viewModel.selectedSize) {
            ForEach(sizes, id: \.self){ size in
                Text("\(size)")
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
        .disabled(!viewModel.hasDifferentSizes)
    }
    
    private var mediumToggle: some View {
        Toggle("Gluten Free?", isOn: $viewModel.isGluttenFree)
            .padding(.horizontal)
            .padding(.trailing)
    }
    
    
}

#Preview {
    PizzaCostView(pizza: Pizza.pizzaExample)
}
