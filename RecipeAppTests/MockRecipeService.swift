//
//  MockRecipeService.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/28/25.
//

@testable import RecipeApp


class MockRecipeService: RecipeServiceProtocol {
    private var currentPage = 0
    
    func fetchRecipes(limit: Int = 20, skip: Int = 0) async throws -> RecipeResponse {
        let recipes = [
            Recipe(
                id: skip + 1,
                name: "Mock Pizza \(skip + 1)",
                ingredients: ["Dough", "Sauce"],
                instructions: ["Step 1", "Step 2"],
                prepTimeMinutes: 20,
                cookTimeMinutes: 15,
                servings: 4,
                difficulty: "Easy",
                cuisine: "Italian",
                caloriesPerServing: 300,
                tags: ["Pizza"],
                userId: 1,
                image: "https://example.com/pizza.jpg",
                rating: 4.5,
                reviewCount: 100,
                mealType: ["Dinner"]
            )
        ]
        
        return RecipeResponse(
            recipes: recipes,
            total: 50, // Mock total to enable pagination
            skip: skip,
            limit: limit
        )
    }
    
    func fetchRecipe(id: Int) async throws -> Recipe {
        return Recipe(
            id: id,
            name: "Mock Pizza \(id)",
            ingredients: ["Dough", "Sauce"],
            instructions: ["Step 1", "Step 2"],
            prepTimeMinutes: 20,
            cookTimeMinutes: 15,
            servings: 4,
            difficulty: "Easy",
            cuisine: "Italian",
            caloriesPerServing: 300,
            tags: ["Pizza"],
            userId: 1,
            image: "https://example.com/pizza.jpg",
            rating: 4.5,
            reviewCount: 100,
            mealType: ["Dinner"]
        )
    }
    
}
