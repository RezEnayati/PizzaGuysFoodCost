import SwiftUI

struct AppetizerCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(appetizer: Appetizer) {
        _viewModel = State(initialValue: ViewModel(appetizer: appetizer))
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if viewModel.isSized {
                
                sizePicker
                
                Divider()
            }
            
            HStack(alignment: .top){
                
                ingredientsStack
                
                amountsStack
                
                costStack
            }
            
            Divider()
            
            saucePicker
            
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
    
    // Size Picker and Sauce Picker
    private var sizePicker: some View {
        Picker("Select Dipping Sauce", selection: $viewModel.selectedSize) {
            ForEach(ViewModel.AppetizerSize.allCases, id: \.self) { size in
                Text(size.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    private var saucePicker: some View {
        Picker("Select Sauce", selection: $viewModel.selectedSauce) {
            ForEach(ViewModel.SauceType.allCases, id: \.self) {sauce in
                Text(sauce.rawValue)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
}

#Preview {
    AppetizerCostView(appetizer: .sampleBread)
}
