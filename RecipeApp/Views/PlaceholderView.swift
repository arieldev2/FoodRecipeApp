//
//  PlaceholderView.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/28/25.
//

import SwiftUI

struct SmallPlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            )
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DetailImagePlaceholderView: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            )
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}
