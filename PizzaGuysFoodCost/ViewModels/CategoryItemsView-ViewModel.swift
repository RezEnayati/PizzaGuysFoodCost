import SwiftUI
import Foundation


extension CategoryItemsView {
    
    @Observable
    class ViewModel {
        
        // MARK: - Properties
        var category: Category
        var items: [any MenuItem] = []
        var isLoading = true
        var error: Error?
        
        // MARK: - Initialization
        init(category: Category) {
            self.category = category
        }
        
        // MARK: - Private File Loading Methods
        private func loadJSONFile(named fileName: String) throws -> Data {
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                throw NSError(domain: "FileNot Found", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not find \(fileName).json"])
            }
            
            let url = URL(filePath: path)
            return try Data(contentsOf: url)
            
        }
        
        private func getJSONfileName(for category: Category) -> String {
            return category.name.lowercased()
        }
        
        // MARK: - Private Decoding Methods
        private func decode(data: Data, for category: Category) throws -> [any MenuItem] {
            switch category.name.lowercased() {
            case "pizza":
                let reponse = try JSONDecoder().decode(PizzaResponse.self, from: data)
                return reponse.pizza
            case "flatbread":
                let reponse = try JSONDecoder().decode(FlatbreadResponse.self, from: data)
                return reponse.flatbread
            case "pasta":
                let reponse = try JSONDecoder().decode(PastaResponse.self, from: data)
                return reponse.pasta
            case "apps":
                let response = try JSONDecoder().decode(AppetizerResponse.self, from: data)
                return response.apps
            case "wings":
                let response = try JSONDecoder().decode(WingsResponse.self, from: data)
                return response.wings
            case "salads":
                let response = try JSONDecoder().decode(SaladsResponse.self, from: data)
                return response.salads
            case "desserts":
                let response = try JSONDecoder().decode(DessertsResponse.self, from: data)
                return response.desserts
            case "catering":
                let response = try JSONDecoder().decode(CateringResponse.self, from: data)
                return response.catering
            default:
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unsupported category"))
            }
        }
        
        // MARK: - Public Methods
        @MainActor
        func loadCategoryItems() async {
            isLoading = true
            defer {isLoading = false}
        
            
            do {
                let fileName = getJSONfileName(for: category)
                let data = try loadJSONFile(named: fileName)
                items = try decode(data: data, for: category)
            } catch {
                self.error = error
                print("Failed to load Data: \(error.localizedDescription)")
            }
        }
    }
}
