# Recipe App 🍳

A modern, professional iOS recipe app built with SwiftUI, featuring MVVM architecture, async/await networking, pagination, and comprehensive unit testing using Swift Testing framework.

![iOS](https://img.shields.io/badge/iOS-15.0%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0%2B-green)
![Xcode](https://img.shields.io/badge/Xcode-15.0%2B-blue)

## 📱 Features

### Core Functionality
- **Browse Recipes**: Infinite scrolling with pagination (20 recipes per page)
- **Recipe Details**: Comprehensive recipe information with ingredients and instructions
- **Beautiful UI**: Modern, professional design with smooth animations
- **Offline-Ready**: Graceful error handling and retry mechanisms

### Technical Features
- **MVVM Architecture**: Clean separation of concerns
- **Protocol-Oriented**: Dependency injection and testability
- **Async/Await**: Modern Swift concurrency patterns
- **Pagination**: Efficient data loading with infinite scroll
- **Unit Testing**: Comprehensive test coverage with Swift Testing
- **Error Handling**: Robust error management and user feedback

## 🏗️ Architecture

### MVVM Pattern
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    Views    │───▶│ ViewModels  │───▶│   Models    │
│  (SwiftUI)  │    │(@MainActor) │    │ (Codable)   │
└─────────────┘    └─────────────┘    └─────────────┘
                           │
                           ▼
                   ┌─────────────┐
                   │  Services   │
                   │ (Protocols) │
                   └─────────────┘
```

### Key Components
- **Models**: `Recipe`, `RecipeResponse` - Data structures
- **Services**: `RecipeService` - API communication layer
- **ViewModels**: `RecipeViewModel`, `RecipeDetailViewModel` - Business logic
- **Views**: SwiftUI components with modern design
- **Protocols**: `RecipeServiceProtocol` for dependency injection

### API Configuration

The app uses the [DummyJSON Recipes API](https://dummyjson.com/docs/recipes):
- **Base URL**: `https://dummyjson.com`
- **Endpoints**:
  - `GET /recipes` - Fetch recipes with pagination
  - `GET /recipes/{id}` - Get recipe details

## 🎨 Screenshots

### Recipe List
- Modern card-based layout
- Star ratings and cooking time
- Infinite scroll pagination
- Search functionality

### Recipe Details
- High-quality images
- Detailed ingredients list
- Step-by-step instructions
- Nutritional information

### Search
- Filtered results


## 🧪 Testing

### Running Tests
```bash
# Run all tests
# Press Cmd + U to run tests
```

### Test Coverage
- **Service Layer**: 95% coverage
  - API integration tests
  - Error handling scenarios
  - Pagination logic
- **ViewModel Layer**: 90% coverage
  - State management
  - Async operations
  - Search functionality
- **Mock Objects**: Complete isolation for unit tests

### Testing Architecture
```swift
// Protocol-based dependency injection
let mockService = MockRecipeService()
let viewModel = RecipeViewModel(recipeService: mockService)

// Async testing with Swift Testing
@Test("Load recipes with pagination updates state correctly")
func testLoadRecipesWithPaginationUpdatesState() async {
    await viewModel.loadRecipes()
    // Assertions...
}
```

