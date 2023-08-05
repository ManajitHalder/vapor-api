//
//  Recipe.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID?
    var name: String
}
