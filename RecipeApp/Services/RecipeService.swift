//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(limit: Int, skip: Int) async throws -> RecipeResponse
    func fetchRecipe(id: Int) async throws -> Recipe
}

// MARK: - Services
final class RecipeService: RecipeServiceProtocol {
    private let baseURL = "https://dummyjson.com"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchRecipes(limit: Int = 20, skip: Int = 0) async throws -> RecipeResponse {
            guard let url = URL(string: "\(baseURL)/recipes?limit=\(limit)&skip=\(skip)") else {
                throw RecipeError.invalidURL
            }
            
            do {
                let (data, response) = try await session.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw RecipeError.invalidResponse
                }
                
                return try JSONDecoder().decode(RecipeResponse.self, from: data)
            } catch {
                if error is DecodingError {
                    throw RecipeError.decodingError
                }
                throw RecipeError.networkError(error.localizedDescription)
            }
        }
    
    func fetchRecipe(id: Int) async throws -> Recipe {
        guard let url = URL(string: "\(baseURL)/recipes/\(id)") else {
            throw RecipeError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw RecipeError.invalidResponse
            }
            
            return try JSONDecoder().decode(Recipe.self, from: data)
        } catch {
            if error is DecodingError {
                throw RecipeError.decodingError
            }
            throw RecipeError.networkError(error.localizedDescription)
        }
    }
    
}
