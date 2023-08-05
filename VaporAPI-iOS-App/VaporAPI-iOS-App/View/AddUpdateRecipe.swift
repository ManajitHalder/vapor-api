//
//  AddUpdateRecipe.swift
//  
//  Created by Manajit Halder on 02/08/23 using Swift 5.0 on MacOS 13.4
//  

import SwiftUI

struct AddUpdateRecipe: View {
    @ObservedObject var vm: AddUpdateVM
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("recipe name", text: $vm.recipeName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button {
                vm.addUpdateAction {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text(vm.buttonTitle)
            }

        }
    }
}

struct AddUpdateRecipe_Previews: PreviewProvider {
    static var previews: some View {
        AddUpdateRecipe(vm: AddUpdateVM())
    }
}
