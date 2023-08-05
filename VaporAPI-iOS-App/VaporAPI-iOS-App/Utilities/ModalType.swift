//
//  ModalType.swift
//  
//  Created by Manajit Halder on 02/08/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

enum ModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    
    case add
    case update(Recipe)
}
