import SwiftUI

struct ItemView: View {
    
    var title: String
    var imageName: String
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.thinMaterial)
            .frame(height: 80)
            .overlay {
                HStack(){
                    Image("\(imageName)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .circular))
                        .padding(.leading, 3)
                        .padding(.vertical, 4)
                    
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            
    }
}



struct ItemViewPreviews_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            ItemView(title: Category.example.name, imageName: Category.example.imageName)
        }
        
    }
}

