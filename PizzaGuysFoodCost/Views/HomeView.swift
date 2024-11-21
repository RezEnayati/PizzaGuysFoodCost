import SwiftUI

struct HomeView: View {

    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let error = viewModel.error {
                    errorView(error: error)
                    
                } else {
                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(viewModel.menuCategories){ category in
                                
                                NavigationLink(destination: CategoryItemsView(category: category)) {
                                    ItemView(title: category.name, imageName: category.imageName)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                            }
                            
                            NavigationLink {
                                ExtrasView()
                            } label: {
                                ItemView(title: "Extras", imageName: "extrasLogo")
                            }
                        }
                        .padding()
                        .scrollContentBackground(.hidden)
                    }
                    .pizzaGuysBackGround
                }
            }
            
            .preferredColorScheme(.dark)
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                PizzaGuysToolBarItem()
            }
            
        }
        .tint(.white)
        .task {
            await viewModel.loadMenuCategories()
        }
        .onAppear{
            viewModel.checkAndShowWelcomeSheet()
        }
        .fullScreenCover(isPresented: $viewModel.showingWelcomeView, content: {
            WelcomeView(isPresented: $viewModel.showingWelcomeView)
        })
        
    }
    
    private func errorView(error: Error ) -> some View {
        print("\(error.localizedDescription)")
        return VStack {
            Text("Error Loading Categry Items")
                .font(.title)
            Text("Please Check Internet Connection")
                .font(.subheadline)
            Button("Retry") {
                Task { await viewModel.loadMenuCategories()}
            }
            
        }
    }
}

#Preview {
    HomeView()
}


