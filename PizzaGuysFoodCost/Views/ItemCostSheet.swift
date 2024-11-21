import SwiftUI

struct ItemCostSheet: View {
    
    let item: any MenuItem
    
    
    @State private var offset = CGSize.zero
    @Binding var showingSheet: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                //Header including image and title
                headerSection
                
                Divider()
                
                //The information about the item passed in
                contentSection
            }
            .frame(maxWidth: .infinity)
            .background(sheetBackground)
            
            
        }
        .offset(y: max(0, offset.height))
        .gesture(dismissGesture)
        
    }
    
    // Information about the item passed in
    private var contentSection: some View {
        Group {
            switch item {
            case let pizza as Pizza:
                PizzaCostView(pizza: pizza)
            case let flatbread as Flatbread:
                FlatbreadCostView(flatbread: flatbread)
            case let appetizer as Appetizer:
                AppetizerCostView(appetizer: appetizer)
            case let wings as Wings:
                WingsCostView(wings: wings)
            case let pasta as Pasta:
                PastaCostView(pasta: pasta)
            case let salad as Salad:
                SaladCostView(salad: salad)
            case let cateringItem as CateringItem:
                CateringCostView(cateringItem: cateringItem)
            case let dessert as Dessert:
                DessertCostView(dessert: dessert)
            default:
                Text("Item not found")
            }
        }
    }
    
    // Gesture for dismissing
    private var dismissGesture: some Gesture {
        DragGesture()
            .onChanged { gesture  in
                // numerical value of the gesture
                offset = gesture.translation
            }
            .onEnded { gesture in
                handleGesture(with: gesture)
            }
    }
    
    // Background Rectaangle
    private var sheetBackground: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(.ultraThickMaterial)
            .offset(y:55)
    }
    
    // Item image
    private var itemImage: some View {
        Image(item.imageName)
            .resizable()
            .scaledToFit()
            .frame(height: Constants.headerImageHeight)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(6)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(.leading)
    }
    
    // Title and image combined
    private var headerSection: some View {
        Group {
            HStack {
                itemImage
                Spacer()
            }
            
            Text(item.name)
                .font(.title3)
                .bold()
                .padding(.leading)
        }
    }
    
    // handleing the gesture based on the height of the gesture
    private func handleGesture(with gesture: DragGesture.Value) {
        let animation = Animation.spring(
            response: Constants.animationResponse,
            dampingFraction: Constants.animationDamping
        )
        
        withAnimation(animation) {
            if gesture.translation.height > Constants.gestureThreshhold {
                showingSheet = false
            } else {
                offset = CGSize.zero
            }
        }
    }
    
}

// Preview 
struct ItemCostSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            ItemCostSheet(item: Wings.regularWingsExample, showingSheet: .constant(true))
        }
    }
}

// MARK: Extenstion (Constants)
extension ItemCostSheet {
    private enum Constants {
        static let cornerRadius: CGFloat = 10
        static let headerImageHeight: CGFloat = 100
        static let gestureThreshhold: Double = 100
        static let animationResponse: Double = 0.3
        static let animationDamping: Double = 0.8
        
    }
}
