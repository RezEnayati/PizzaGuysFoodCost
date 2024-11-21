
import SwiftUI

struct ItemListView: View {
    
    var items: [any MenuItem]
    
    @State private var selectedItem: (any MenuItem)? = nil
    @State private var showingSheet: Bool =  false
    
    var body: some View {
        
        NavigationStack{
            ScrollView {
                VStack(spacing: 5) {
                    
                    itemsList
                    
                }
                .padding()
                
            }
            .pizzaGuysBackGround
            
        }
        .overlay {
            if showingSheet, let selectedItem = selectedItem {
                overlayContet(for: selectedItem)
            }
        }
        .animation(animation, value: showingSheet)
    }
    
    // function to pop up the overlay with the selected item.
    private func overlayContet(for item: any MenuItem) -> some View {
        ZStack {
            dimmedBackground
            
            ItemCostSheet(item: item, showingSheet: $showingSheet)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .frame(maxHeight: .infinity, alignment: .bottom)
                .zIndex(1)
        }
        .transaction { transaction in
            transaction.animation = animation
        }
    }
    
    // Dimmed backGround when the sheet pops up, dismmises the sheet when tapped
    private var dimmedBackground: some View {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .onTapGesture {
                withAnimation(animation) {
                    showingSheet = false
                }
            }
    }
    
    // List of items in the view
    private var itemsList: some View {
        ForEach(items, id: \.id){ item in
            ItemView(title: item.name, imageName: item.imageName)
                .onTapGesture {
                    showingSheet = true
                    selectedItem = item
                }
        }
    }
    
    // Spring Animation
    private var animation: Animation {
        return Animation.spring(response: Constants.animationResponse, dampingFraction: Constants.animationDamping)
    }
    
}

#Preview {
    let samplePizzas = [
        Pizza(
            id: 0,
            name: "Combo",
            imageName: "comboLogo",
            toppings: PizzaToppings(
                ingredients: ["ham"],
                quantities: ["s": [1.0]]
            )
        )
    ]
    return ItemListView(items: samplePizzas)
}

// MARK: - Contansts
extension ItemListView {
    private enum Constants {
        static let animationResponse: Double = 0.3
        static let animationDamping: Double = 0.8
    }
}
