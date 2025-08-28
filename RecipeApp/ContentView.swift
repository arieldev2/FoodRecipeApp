//
//  ContentView.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = RecipeViewModel()
    
    var body: some View {
        NavigationStack {
            RecipeListView(viewModel: viewModel)
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
}

#Preview {
    ContentView()
}
