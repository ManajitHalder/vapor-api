//
//  AddUpdateVM.swift
//  
//  Created by Manajit Halder on 02/08/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

final class AddUpdateVM: ObservableObject {
    @Published var recipeName = ""
 
    var recipeID: UUID?
    var isUpdating: Bool {
        recipeID != nil
    }
    var buttonTitle: String {
        recipeID != nil ? "Update Recipe" : "Add Recipe"
    }
    
    init() {}
    
    init(newRecipe: Recipe) {
        recipeID = newRecipe.id
        recipeName = newRecipe.name
    }
    
    func addUpdateAction(completion: @escaping () -> Void) {
        Task {
            do {
                if isUpdating {
                    try await updateRecipe()
                } else {
                    try await addRecipe()
                }
            } catch {
                print("🤬 something worng in addUpdateAction: \(error)")
            }
            completion()
        }
    }
    
    // Add a new recipe to the Recipe DB
    func addRecipe() async throws {
        let urlString = Constants.baseURL + Endpoints.recipe
    
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let recipe = Recipe(id: nil, name: recipeName)
        
        try await HttpClient.shared.sendData(to: url, object: recipe, httpMethod: HttpMethods.POST.rawValue)
    }
    
    // Update a recipe
    func updateRecipe() async throws {
        var urlString = Constants.baseURL + Endpoints.recipe
        if let recipeID = recipeID {
            urlString = urlString + "/" + recipeID.uuidString
        }
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let recipeToUpdate = Recipe(id: recipeID, name: recipeName)
        try await HttpClient.shared.sendData(to: url, object: recipeToUpdate, httpMethod: HttpMethods.PUT.rawValue)
    }
}

