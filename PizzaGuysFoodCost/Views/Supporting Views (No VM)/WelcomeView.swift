import SwiftUI

struct WelcomeView: View {
    
    @Binding var isPresented: Bool
    @AppStorage("hasSeenWelcomeView") private var hasSeenWelcomeView: Bool = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                HStack{
                    Image(.pgLogo2)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    Spacer()
                }
                Text("Welcome to")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()
                Text("Pizza Guys Food Cost")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .bold()
                Text("Calculator")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(Color.pizzaGuysRed)
                Spacer()
                Button(action: {
                    hasSeenWelcomeView = true
                    isPresented = false
                }, label: {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pizzaGuysRed)
                        .cornerRadius(10)
                })
                
                
            }.padding(.horizontal, 20)
        }
    }
}

#Preview {
    WelcomeView(isPresented: .constant(true))
}
