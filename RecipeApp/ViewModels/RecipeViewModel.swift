//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

protocol RecipeViewModelProtocol {
    var recipes: [Recipe] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var searchText: String { get set }
    var filteredRecipes: [Recipe] { get }
    var hasMoreRecipes: Bool { get }
    var isLoadingMore: Bool { get }
    
    func loadRecipes() async
    func loadMoreRecipes() async
}

@MainActor
@Observable
final class RecipeViewModel: RecipeViewModelProtocol {
    var recipes: [Recipe] = []
    var isLoading = false
    var errorMessage: String?
    var searchText = ""
    var isLoadingMore = false
    
    private let recipeService: RecipeServiceProtocol
    private let pageSize = 20
    private var currentPage = 0
    private var totalRecipes = 0
    private var isSearchMode = false
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText) ||
                recipe.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    var hasMoreRecipes: Bool {
        return recipes.count < totalRecipes
    }
    
    func loadRecipes() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = 0
        isSearchMode = false
        
        do {
            let response = try await recipeService.fetchRecipes(limit: pageSize, skip: 0)
            recipes = response.recipes
            totalRecipes = response.total
            currentPage = 1
        } catch {
            errorMessage = error.localizedDescription
            recipes = []
        }
        
        isLoading = false
    }
    
    func loadMoreRecipes() async {
        guard !isLoadingMore && hasMoreRecipes && !isLoading else { return }
        
        isLoadingMore = true
        
        do {
            let skip = currentPage * pageSize
            let response = try await recipeService.fetchRecipes(limit: pageSize, skip: skip)
            
            recipes.append(contentsOf: response.recipes)
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingMore = false
    }
    
    func resetPagination() {
        currentPage = 0
        totalRecipes = 0
        recipes = []
    }
    
}
