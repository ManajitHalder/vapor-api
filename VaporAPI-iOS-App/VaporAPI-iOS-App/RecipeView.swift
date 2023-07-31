//
//  RecipeView.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct RecipeView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}
