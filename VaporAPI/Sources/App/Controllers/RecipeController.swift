//
//  RecipeController.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import Vapor
import Fluent

struct RecipeController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let recipe = routes.grouped("recipe")
        recipe.get(use: index)
        recipe.post(use: create)
        recipe.patch(":id", use: partialUpdate)
        recipe.put(":id", use: update)
        recipe.group(":id") { recipe in
            recipe.delete(use: delete)
        }
    }
    
    // GET request for route /recipe
    func index(req: Request) async throws -> [RecipeModel] {
        try await RecipeModel.query(on: req.db).all()
    }
    
    // POST request for route /recipe
    func create(req: Request) async throws -> HTTPStatus {
        let recipe = try req.content.decode(RecipeModel.self)
        try await recipe.save(on: req.db)
        
        return .ok
    }
    
    // PATCH request for route /recipe/id
    func partialUpdate(req: Request) async throws -> RecipeModel {
        let recipe = try req.content.decode(RecipeModel.self)
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        let existingRecipe = try await findRecipe(by: id, on: req)
        existingRecipe.name = recipe.name
        try await existingRecipe.save(on: req.db)

        return existingRecipe
    }

    // PUT request for route /recipe/id
    func update(req: Request) async throws -> HTTPStatus {
        // Decode the updated RecipeModel from the request body
        let updatedRecipe = try req.content.decode(RecipeModel.self)
        
        // Get the id from the URL parameter
        guard let recipeID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        // Find the RecipeModel model with the given ID from the database
        let existingRecipe = try await findRecipe(by: recipeID, on: req)
        
        // Update the properties of the existing RecipeModel with the updated one from the request body
        existingRecipe.name = updatedRecipe.name
        
        // Save the updated RecipeModel back to the database
        try await existingRecipe.save(on: req.db)
        
        return .ok
    }
    
    func findRecipe(by id: UUID, on req: Request) async throws -> RecipeModel {
        guard let recipe = try await RecipeModel.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        return recipe
    }
    
    // PUT request /recipe route
    func update2(req: Request) async throws -> HTTPStatus {
        let recipe = try req.content.decode(RecipeModel.self)
        
        guard let recipeFromDB = try await RecipeModel.find(recipe.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        recipeFromDB.name = recipe.name
        try await recipeFromDB.update(on: req.db)
        
        return .ok
    }
    
    // DELETE request /recipe/id route
    func delete(req: Request) async throws -> HTTPStatus {
        guard let recipe = try await RecipeModel.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        try await recipe.delete(on: req.db)
        
        return .ok
    }
}
