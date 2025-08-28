//
//  ImageCache.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/27/25.
//

import SwiftUI

protocol ImageCacheProtocol {
    func image(for url: String) async throws -> UIImage?
}


final class ImageCache: ImageCacheProtocol {
    private var cache = NSCache<NSString, UIImage>()
    
    static let shared = ImageCache()
    
    private init(){
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    func image(for url: String) async throws -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSString) {
            return cachedImage
        }
        
        guard let imageURL = URL(string: url) else {
            throw RecipeError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: imageURL)
        
        if let image = UIImage(data: data) {
            cache.setObject(image, forKey: url as NSString)
            return image
        }
        
        return nil
    }
    
}
