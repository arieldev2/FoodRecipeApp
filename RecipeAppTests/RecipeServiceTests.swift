//
//  RecipeServiceTests.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/28/25.
//

@testable import RecipeApp
import Testing
import SwiftUI

@Suite("Recipe Service Tests")
struct RecipeServiceTests {
    
    @Test("Fetch recipes with pagination successfully")
    func testFetchRecipesWithPaginationSuccess() async throws {
        // Given
        let mockData = """
        {
            "recipes": [
                {
                    "id": 1,
                    "name": "Classic Margherita Pizza",
                    "ingredients": ["Pizza dough", "Tomato sauce"],
                    "instructions": ["Preheat oven", "Roll out dough"],
                    "prepTimeMinutes": 20,
                    "cookTimeMinutes": 15,
                    "servings": 4,
                    "difficulty": "Easy",
                    "cuisine": "Italian",
                    "caloriesPerServing": 300,
                    "tags": ["Pizza", "Italian"],
                    "userId": 1,
                    "image": "https://example.com/pizza.jpg",
                    "rating": 4.6,
                    "reviewCount": 98,
                    "mealType": ["Dinner"]
                }
            ],
            "total": 50,
            "skip": 0,
            "limit": 20
        }
        """.data(using: .utf8)!
        
        let mockSession = MockURLSession(data: mockData, response: HTTPURLResponse(
            url: URL(string: "https://dummyjson.com/recipes?limit=20&skip=0")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!)
        
        let service = RecipeService(session: mockSession)
        
        // When
        let response = try await service.fetchRecipes(limit: 20, skip: 0)
        
        // Then
        #expect(response.recipes.count == 1)
        #expect(response.total == 50)
        #expect(response.skip == 0)
        #expect(response.limit == 20)
        #expect(response.recipes.first?.name == "Classic Margherita Pizza")
    }
    
    @Test("Fetch recipe by ID successfully")
    func testFetchRecipeByIdSuccess() async throws {
        // Given
        let mockData = """
        {
            "id": 1,
            "name": "Classic Margherita Pizza",
            "ingredients": ["Pizza dough", "Tomato sauce"],
            "instructions": ["Preheat oven", "Roll out dough"],
            "prepTimeMinutes": 20,
            "cookTimeMinutes": 15,
            "servings": 4,
            "difficulty": "Easy",
            "cuisine": "Italian",
            "caloriesPerServing": 300,
            "tags": ["Pizza", "Italian"],
            "userId": 1,
            "image": "https://example.com/pizza.jpg",
            "rating": 4.6,
            "reviewCount": 98,
            "mealType": ["Dinner"]
        }
        """.data(using: .utf8)!
        
        let mockSession = MockURLSession(data: mockData, response: HTTPURLResponse(
            url: URL(string: "https://dummyjson.com/recipes/1")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!)
        
        let service = RecipeService(session: mockSession)
        
        // When
        let recipe = try await service.fetchRecipe(id: 1)
        
        // Then
        #expect(recipe.id == 1)
        #expect(recipe.name == "Classic Margherita Pizza")
    }
}
