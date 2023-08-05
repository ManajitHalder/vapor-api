//
//  RecipeListVM.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

class RecipeListVM: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes() async throws {
        let urlString = Constants.baseURL + Endpoints.recipe
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let recipesFetched: [Recipe] = try await HttpClient.shared.fetch(url: url)
        
        // This will update the recipes, which will update the UI and hence should be done on main thread.
        DispatchQueue.main.async {
            self.recipes = recipesFetched
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            guard let recipeID = recipes[i].id else {
                return
            }
            
            guard let url = URL(string: Constants.baseURL + Endpoints.recipe + "/\(recipeID)") else {
                return
            }
            
            Task {
                do {
                    try await HttpClient.shared.delete(at: recipeID, url: url)
                } catch {
                    print("😇 error in delete \(error)")
                }
            }
        }
        recipes.remove(atOffsets: offsets)
    }
}

