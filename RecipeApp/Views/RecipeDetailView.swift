//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipeId: Int
    @State private var viewModel = RecipeDetailViewModel()
    @State private var image: UIImage?
    private let imageCache = ImageCache.shared
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView("Loading recipe...")                
            } else if let errorMessage = viewModel.errorMessage {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.loadRecipe(id: recipeId)
                    }
                }
            } else if let recipe = viewModel.recipe {
                ScrollView{
                    LazyVStack(alignment: .leading, spacing: 16) {
                        if let image{
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 250)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }else{
                            DetailImagePlaceholderView()
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            // Title and Rating
                            VStack(alignment: .leading, spacing: 4) {
                                Text(recipe.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    HStack(spacing: 4) {
                                        ForEach(0..<5) { star in
                                            Image(systemName: star < Int(recipe.rating) ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                        }
                                        Text("(\(recipe.reviewCount) reviews)")
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(recipe.difficulty)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .foregroundColor(.blue)
                                        .cornerRadius(16)
                                }
                            }
                            
                            // Recipe Info
                            HStack(spacing: 20) {
                                InfoItem(icon: "clock", text: "\(recipe.prepTimeMinutes + recipe.cookTimeMinutes) min")
                                InfoItem(icon: "person.2", text: "\(recipe.servings) servings")
                                InfoItem(icon: "flame", text: "\(recipe.caloriesPerServing) cal")
                            }
                            
                            // Tags
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(recipe.tags, id: \.self) { tag in
                                        Text(tag)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.green.opacity(0.1))
                                            .foregroundColor(.green)
                                            .cornerRadius(12)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Ingredients
                            SectionView(title: "Ingredients", items: recipe.ingredients)
                            
                            // Instructions
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Instructions")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                                    HStack(alignment: .top, spacing: 12) {
                                        Text("\(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(width: 24, height: 24)
                                            .background(Color.blue)
                                            .cornerRadius(12)
                                        
                                        Text(instruction)
                                            .font(.body)
                                            .lineLimit(nil)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .onAppear{
                    Task{
                        image = try await imageCache.image(for: recipe.image)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadRecipe(id: recipeId)
        }
    }
}


struct InfoItem: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct SectionView: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        
                        Text(item)
                            .font(.body)
                            .lineLimit(nil)
                    }
                }
            }
        }
    }
}
