//
//  ExtrasView.swift
//  PizzaGuysFoodCost
//
//  Created by Reza Enayati on 11/15/24.
//

import SwiftUI

struct ExtrasView: View {
    
    @State private var viewModel = ViewModel()
    
    @State private var searchText = ""
    
    // An array of tuples. 
    private let sections: [(String, KeyPath<ViewModel, [ToppingInfo]>)] = [
         ("Dipping Sauces (Including Container)", \ViewModel.sauceInfo),
         ("Sides (Including Container)", \ViewModel.sideInfo),
         ("Dressings", \ViewModel.dressingsInfo),
         ("Miscellaneous", \ViewModel.miscInfo),
         ("Uniforms", \ViewModel.uniformInfo)
     ]
    
    func filtered(_ items: [ToppingInfo]) -> [ToppingInfo] {
         searchText.isEmpty ? items : items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
     }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.error {
                    ContentUnavailableView("Error", systemImage: "exclamationmark.triangle", description: Text(error.localizedDescription))
                } else if searchText.isEmpty || sections.contains(where: { filtered(viewModel[keyPath: $1]).count > 0 }) {
                    List {
                        ForEach(sections, id: \.0) { title, keyPath in
                            let filteredItems = filtered(viewModel[keyPath: keyPath])
                            if !filteredItems.isEmpty {
                                Section(title) {
                                    ForEach(filteredItems, id: \.self) { info in
                                        RowView(name: info.name, cost: info.cost)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ContentUnavailableView.search(text: searchText)
                }
            }
            .navigationTitle("Extras")
            .searchable(text: $searchText)
        }
    }
}

struct RowView: View {
    
    let name: String
    let cost: Double
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text("$") + Text(String(format: "%.2f", cost))
        }

    }
}


#Preview {
    ExtrasView()
}
