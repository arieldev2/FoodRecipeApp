//
//  RecipeRowView.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    @State private var image: UIImage?
    private let imageCache = ImageCache.shared
    
    var body: some View {
        HStack(spacing: 12) {
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))

            }else{
                SmallPlaceholderView()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("\(recipe.rating, specifier: "%.1f")")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text("\(recipe.prepTimeMinutes + recipe.cookTimeMinutes) min")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .onAppear{
            Task{
                image = try await imageCache.image(for: recipe.image)
            }
        }
    }
}
