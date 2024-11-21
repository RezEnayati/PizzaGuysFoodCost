import SwiftUI

struct FlatbreadCostView: View {
    
    @State private var viewModel: ViewModel
    
    init(flatbread: Flatbread){
        _viewModel = State(initialValue: ViewModel(flatbread: flatbread))
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top){
                
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
        VStack(alignment: .leading){
            Text("Ingredients:")
                .bold()
                
            ForEach(viewModel.toppingsInfo, id:\.self) { info in
                Text("\(info.name)")
            }
        }
        .padding(.leading)
    }
    
    private var amountStack: some View {
        VStack(alignment: .leading){
            Text("Amount:")
                .bold()
                
            ForEach(viewModel.toppingsInfo, id: \.self) { info in
                Text(String(format: "%.2f", info.amount))
            }
        }
        .padding(.leading)
    }
    
    private var costStack: some View {
        VStack(alignment: .leading){
            Text("Amount:")
                .bold()
                
            ForEach(viewModel.toppingsInfo, id: \.self) { info in
                Text(String(format: "%.2f", info.amount))
            }
        }
        .padding(.leading)
    }
    
    private var totalCost: some View {
        Text("Total Cost: $\(viewModel.totalCost)")
            .bold()
            .padding(.bottom)
    }
}

#Preview {
    FlatbreadCostView(flatbread: .flatbreadExample)
}
