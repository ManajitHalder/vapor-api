//
//  RecipeMigration.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation
import Vapor
import Fluent

struct RecipeMigration: AsyncMigration {
    let schema = "recipe"
    
    func prepare(on database: Database) async throws {
        try await database.schema(schema)
            .id()
            .field("name", .string, .required)
//            .field("ingredients", .string)
//            .field("instructions", .string)
//            .unique(on: "name")
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(schema)
            .delete()
    }
}
