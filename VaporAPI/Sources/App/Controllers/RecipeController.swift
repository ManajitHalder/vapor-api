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
    }
    
    // GET request for route /recipe
    func index(req: Request) async throws -> [RecipeModel] {
        try await RecipeModel.query(on: req.db).all()
    }
    
    // POST request for route /recipe
    func create(req: Request) async throws -> RecipeModel {
        let recipe = try req.content.decode(RecipeModel.self)
        try await recipe.save(on: req.db)
        return recipe
    }
}
