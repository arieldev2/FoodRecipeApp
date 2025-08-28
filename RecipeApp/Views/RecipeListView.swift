//
//  RecipeListView.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

struct RecipeListView: View {
    @Bindable var viewModel: RecipeViewModel
    
    var body: some View {
        VStack {
            
            if viewModel.isLoading && viewModel.recipes.isEmpty {
                ProgressView("Loading recipes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage, viewModel.recipes.isEmpty {
                ErrorView(message: errorMessage) {
                    Task {
                        await viewModel.loadRecipes()
                    }
                }
            } else {
                List {
                    ForEach(viewModel.filteredRecipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                            RecipeRowView(recipe: recipe)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .onAppear {
                            // Load more recipes when approaching the end
                            if recipe.id == viewModel.filteredRecipes.last?.id &&
                               viewModel.searchText.isEmpty &&
                               viewModel.hasMoreRecipes {
                                Task {
                                    await viewModel.loadMoreRecipes()
                                }
                            }
                        }
                    }
                    
                    // Show loading indicator at the bottom when loading more
                    if viewModel.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView("Loading more...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 8)
                    }
                    
                    // Show "No more recipes" message when all loaded
                    if !viewModel.hasMoreRecipes && !viewModel.recipes.isEmpty && viewModel.searchText.isEmpty {
                        HStack {
                            Spacer()
                            Text("No more recipes to load")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(PlainListStyle())
                .searchable(text: $viewModel.searchText, prompt: "Search recipes...")
            }
        }
        .refreshable {
            await viewModel.loadRecipes()
        }
    }
}
