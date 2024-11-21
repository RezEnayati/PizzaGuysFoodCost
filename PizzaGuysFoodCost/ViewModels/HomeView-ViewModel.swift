import Foundation
import SwiftUI

extension HomeView {
    
    @Observable
    class ViewModel{
        
        // MARK: - Properties
        var menuCategories: [Category] = []
        var isLoading = true
        var error: Error?
        var showingWelcomeView = false
        
        // MARK: - Welcome View Methods
        func checkAndShowWelcomeSheet(){
            let hasSeenWelcomeView = UserDefaults.standard.bool(forKey: "hasSeenWelcomeView")
            if !hasSeenWelcomeView {
                showingWelcomeView = true
            }
        }
        
        // MARK: - Private File Loading Methods
        private func loadJSONfile(named fileName: String) throws -> Data {
            
            
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
                throw NSError(domain: "FileNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Could not find \(fileName).json"])
            }
            let url = URL(filePath: path)
            return try Data(contentsOf: url)
            
        }
        
        // MARK: - Public Methods
        func loadMenuCategories() async {
            isLoading = true
            defer {isLoading = false}
            
            
            do {
                let data = try loadJSONfile(named: "menu")
                
                if let decodedData = try? JSONDecoder().decode(MenuCategories.self, from: data){
                    menuCategories = decodedData.categories
                    
                } else {
                    error = NSError(domain: "DecodingError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Failed To Decode data"])
                    print("Failed to decode Data")
                }
            } catch {
                self.error = error
                print("Failed to load data: \(error.localizedDescription)")
            }
        }
        
    }
    
}
