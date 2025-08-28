//
//  MockURLSession.swift
//  RecipeApp
//
//  Created by Ariel Ortiz on 8/28/25.
//

@testable import RecipeApp
import SwiftUI


class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    let mockData: Data
    let mockResponse: URLResponse
    let shouldThrowError: Bool
    let error: Error?
    
    init(data: Data, response: URLResponse, shouldThrowError: Bool = false, error: Error? = nil) {
        self.mockData = data
        self.mockResponse = response
        self.shouldThrowError = shouldThrowError
        self.error = error
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if shouldThrowError {
            throw error ?? URLError(.networkConnectionLost)
        }
        return (mockData, mockResponse)
    }
}
