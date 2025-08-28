//
//  RecipeViewModelTests.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/28/25.
//

@testable import RecipeApp
import Testing

@Suite("Recipe ViewModel Tests")
struct RecipeViewModelTests {
    
    @Test("Load recipes with pagination updates state correctly")
    func testLoadRecipesWithPaginationUpdatesState() async {
        // Given
        let mockService = MockRecipeService()
        let viewModel = await RecipeViewModel(recipeService: mockService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            #expect(!viewModel.isLoading)
            #expect(viewModel.recipes.count == 1)
            #expect(viewModel.errorMessage == nil)
            #expect(viewModel.hasMoreRecipes == true) // Mock service returns total: 50
        }
    }
    
    @Test("Load more recipes appends to existing recipes")
    func testLoadMoreRecipesAppendsToExisting() async {
        // Given
        let mockService = MockRecipeService()
        let viewModel = await RecipeViewModel(recipeService: mockService)
        await viewModel.loadRecipes()
        
        let initialCount = await MainActor.run { viewModel.recipes.count }
        
        // When
        await viewModel.loadMoreRecipes()
        
        // Then
        await MainActor.run {
            #expect(viewModel.recipes.count == initialCount + 1) // Mock adds one more recipe
            #expect(!viewModel.isLoadingMore)
        }
    }
    
    @Test("Filtered recipes work correctly")
    func testFilteredRecipes() async {
        // Given
        let mockService = MockRecipeService()
        let viewModel = await RecipeViewModel(recipeService: mockService)
        await viewModel.loadRecipes()
        
        // When & Then
        await MainActor.run {
            viewModel.searchText = "Pizza"
            #expect(viewModel.filteredRecipes.count == 1)
            
            viewModel.searchText = "NonExistent"
            #expect(viewModel.filteredRecipes.count == 0)
        }
    }
    
    @Test("Has more recipes property works correctly")
    func testHasMoreRecipesProperty() async {
        // Given
        let mockService = MockRecipeService()
        let viewModel = await RecipeViewModel(recipeService: mockService)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        await MainActor.run {
            #expect(viewModel.hasMoreRecipes == true) // Mock service returns total: 50, loaded: 1
        }
    }
    
    @Test("Loading states are managed correctly")
    func testLoadingStatesManagement() async {
        // Given
        let mockService = MockRecipeService()
        let viewModel = await RecipeViewModel(recipeService: mockService)
        
        // Initially not loading
        await MainActor.run {
            #expect(!viewModel.isLoading)
            #expect(!viewModel.isLoadingMore)
        }
        
        // Test that we can check loading state during load
        // Note: This is a simplified test as the actual loading happens very quickly with mock data
        await viewModel.loadRecipes()
        
        await MainActor.run {
            #expect(!viewModel.isLoading) // Should be false after completion
        }
    }
}
