//
//  RecipeDetailViewModel.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

@MainActor
@Observable
class RecipeDetailViewModel {
    var recipe: Recipe?
    var isLoading = false
    var errorMessage: String?
    
    private let recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    func loadRecipe(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            recipe = try await recipeService.fetchRecipe(id: id)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
