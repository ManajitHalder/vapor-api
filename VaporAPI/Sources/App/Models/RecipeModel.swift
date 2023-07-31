//
//  RecipeModel.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation
import Vapor
import Fluent

final class RecipeModel: Model, Content {
    static let schema = "recipe"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
//    @Field(key: "ingredients")
//    var ingredients: String
//
//    @Field(key: "instructions")
//    var instructions: String
    
    init() {}
    
//    init(id: UUID? = nil, name: String, ingredients: String, instructions: String) {
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
//        self.ingredients = ingredients
//        self.instructions = instructions
    }
}
