//
//  RecipeListView.swift
//  
//  Created by Manajit Halder on 31/07/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel = RecipeListVM()
    @State var modal: ModalType?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.recipes) { recipe in
                    Button {
                        modal = .update(recipe)
                    } label: {
                        Text(recipe.name)
                            .font(.title3)
                            .foregroundColor(Color(.label))
                    }
                }
                .onDelete(perform: viewModel.delete )
            }
            .navigationTitle(Text("🍛 🥞 🍨 Recipes"))
            .toolbar {
                Button {
                    modal = .add
                } label: {
                    Label("Add Recipes", systemImage: "plus.app")
                }

            }
        }
        .sheet(item: $modal, onDismiss: {
            Task {
                do {
                    try await viewModel.fetchRecipes()
                } catch {
                    print("🤬 something worng: \(error)")
                }
            }
        }, content: { modal in
            switch modal {
            case .add:
                AddUpdateRecipe(vm: AddUpdateVM())
            case .update(let recipe):
                AddUpdateRecipe(vm: AddUpdateVM(newRecipe: recipe))
            }
        })
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchRecipes()
                } catch {
                    print("🤬 Error while fetching Recipes \(error)")
                }
            }
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
