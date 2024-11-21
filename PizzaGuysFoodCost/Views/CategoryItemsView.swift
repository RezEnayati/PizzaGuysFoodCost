import SwiftUI

struct CategoryItemsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var category: Category
    @State private var viewModel: ViewModel
    
    init(category: Category) {
        self.category = category
        _viewModel = State(initialValue: ViewModel(category: category))
    }
    
    var body: some View {
        contentView
            .navigationTitle(category.name.uppercased())
            .toolbar {
                PizzaGuysToolBarItem()
            }
            .task {
                await viewModel.loadCategoryItems()
            }
    }
    
    private var contentView: some View {
        Group {
            if viewModel.isLoading {
                LoadingView()
            } else if let error = viewModel.error {
                errorView(error)
            } else {
                ItemListView(items: viewModel.items)
            }
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        VStack {
            Text("Error loading items")
            Text(error.localizedDescription)
                .font(.caption)
            Button("Retry") {
                Task { await viewModel.loadCategoryItems() }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    CategoryItemsView(category: .example)
}

