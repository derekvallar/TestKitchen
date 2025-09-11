//
//  Recipe.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/1/25.
//

import Foundation
import SwiftData
import SwiftUI
import _PhotosUI_SwiftUI

@Model
final class Recipe {
  // NOTE(dvallar): Make these recipes unique models depending on id (perhaps creator too?)
  var recipeId: String?
  var isPublic: Bool = false
  var isArchived: Bool = false
  var dateCreated: Date

  var parentRecipe: Recipe?
  var childRecipes: [Recipe] = []

  var title: String
  var author: String?
  var photos: [Photo]
  var recipeDescription: String?
  var recipeChangeDescription: String?
  
  // Social/Engagement properties
  var likeCount: Int = 0
  var bookmarkCount: Int = 0
  var commentCount: Int = 0
  var isLiked: Bool = false
  var isBookmarked: Bool = false
  
  // Recipe rating and status
  var experimentScore: Double?
  var recipeStatus: String?
  var takeCount: Int = 0
  
  // Recipe variations/takes
  var takes: [Recipe] = []

  var prepTime: String?
  var cookTime: String?
  var totalTime: String?
  var ingredients: IngredientList?
  var preparationSteps: [PreparationStep]

  init(
    title: String,
    author: String? = nil,
    recipeDescription: String? = nil,
    photos: [Photo] = [],
    prepTime: String? = nil,
    cookTime: String? = nil,
    totalTime: String? = nil,
    ingredients: IngredientList? = nil,
    preparationSteps: [String] = []
  ) {
    self.title = title
    self.author = author
    self.dateCreated = Date()
    self.recipeDescription = recipeDescription
    self.photos = photos
    self.prepTime = prepTime
    self.cookTime = cookTime
    self.totalTime = totalTime
    self.ingredients = ingredients
    self.preparationSteps = preparationSteps.map {
      PreparationStep(text: $0)
    }
    
    // Initialize social properties with defaults
    self.experimentScore = nil
    self.recipeStatus = "New Recipe"
  }

  func update(
    title: String,
    author: String? = nil,
    description: String? = nil,
    photos: [Photo] = [],
    prepTime: String? = nil,
    cookTime: String? = nil,
    totalTime: String? = nil,
    ingredients: IngredientList? = nil,
    preparationSteps: [PreparationStep] = []
  ) {
    // Remove debug print statement
    self.title = title
    self.author = author
    self.recipeDescription = description
    self.prepTime = prepTime
    self.cookTime = cookTime
    self.totalTime = totalTime
    self.ingredients = ingredients
    self.preparationSteps = preparationSteps
  }
}

struct IngredientList: Codable, Hashable {
  let id: String
  let text: String
  let recipeId: String?
}

struct PreparationStep: Codable, Hashable {
  var id: String = UUID().uuidString
  let text: String
  var recipeId: String?
  // This value should only be updated by the server
  let isTrending: Bool

  init(
    text: String,
    isTrending: Bool = false
  ) {
    self.text = text
    self.isTrending = isTrending
  }
}

enum Highlightable: Identifiable {
  case ingredients(IngredientList)
  case prepStep(PreparationStep)

  var id: String {
    switch self {
    case .ingredients(let list):
      return list.id
    case .prepStep(let step):
      return step.id
    }
  }

  var text: String {
    switch self {
    case .ingredients(let list):
      return list.text
    case .prepStep(let step):
      return step.text
    }
  }

  var recipeId: String? {
    switch self {
    case .ingredients(let list):
      return list.recipeId
    case .prepStep(let step):
      return step.recipeId
    }
  }
}

struct Photo: Codable, Hashable {
  let data: Data?

  func image() -> Image? {
    guard let data = data,
          let uiImage = UIImage(data: data)
    else {
      assertionFailure("Could not create image from data")
      return nil
    }
    return Image(uiImage: uiImage)
  }
}

// MARK: - Codable Recipe for API Communication

struct CodableRecipe: Codable, Hashable {
  let recipeId: String?
  let isPublic: Bool
  let isArchived: Bool
  let dateCreated: Date
  
  let parentRecipeId: String?
  let childRecipeIds: [String]
  
  let title: String
  let author: String?
  let photos: [Photo]
  let recipeDescription: String?
  let recipeChangeDescription: String?
  
  // Social/Engagement properties
  let likeCount: Int
  let bookmarkCount: Int
  let commentCount: Int
  let isLiked: Bool
  let isBookmarked: Bool
  
  // Recipe rating and status
  let experimentScore: Double?
  let recipeStatus: String?
  let takeCount: Int
  
  let prepTime: String?
  let cookTime: String?
  let totalTime: String?
  let ingredients: IngredientList?
  let preparationSteps: [PreparationStep]
  
  init(from recipe: Recipe) {
    self.recipeId = recipe.recipeId
    self.isPublic = recipe.isPublic
    self.isArchived = recipe.isArchived
    self.dateCreated = recipe.dateCreated
    
    self.parentRecipeId = recipe.parentRecipe?.recipeId
    self.childRecipeIds = recipe.childRecipes.compactMap { $0.recipeId }
    
    self.title = recipe.title
    self.author = recipe.author
    self.photos = recipe.photos
    self.recipeDescription = recipe.recipeDescription
    self.recipeChangeDescription = recipe.recipeChangeDescription
    
    self.likeCount = recipe.likeCount
    self.bookmarkCount = recipe.bookmarkCount
    self.commentCount = recipe.commentCount
    self.isLiked = recipe.isLiked
    self.isBookmarked = recipe.isBookmarked
    
    self.experimentScore = recipe.experimentScore
    self.recipeStatus = recipe.recipeStatus
    self.takeCount = recipe.takeCount
    
    self.prepTime = recipe.prepTime
    self.cookTime = recipe.cookTime
    self.totalTime = recipe.totalTime
    self.ingredients = recipe.ingredients
    self.preparationSteps = recipe.preparationSteps
  }
}

// MARK: - Recipe Extensions

extension Recipe {
  func toCodableRecipe() -> CodableRecipe {
    return CodableRecipe(from: self)
  }
  
  static func fromCodable(_ codableRecipe: CodableRecipe) -> Recipe {
    let recipe = Recipe(
      title: codableRecipe.title,
      author: codableRecipe.author,
      recipeDescription: codableRecipe.recipeDescription,
      photos: codableRecipe.photos,
      prepTime: codableRecipe.prepTime,
      cookTime: codableRecipe.cookTime,
      totalTime: codableRecipe.totalTime,
      ingredients: codableRecipe.ingredients,
      preparationSteps: codableRecipe.preparationSteps.map { $0.text }
    )
    
    // Set additional properties
    recipe.recipeId = codableRecipe.recipeId
    recipe.isPublic = codableRecipe.isPublic
    recipe.isArchived = codableRecipe.isArchived
    recipe.dateCreated = codableRecipe.dateCreated
    recipe.recipeChangeDescription = codableRecipe.recipeChangeDescription
    
    recipe.likeCount = codableRecipe.likeCount
    recipe.bookmarkCount = codableRecipe.bookmarkCount
    recipe.commentCount = codableRecipe.commentCount
    recipe.isLiked = codableRecipe.isLiked
    recipe.isBookmarked = codableRecipe.isBookmarked
    
    recipe.experimentScore = codableRecipe.experimentScore
    recipe.recipeStatus = codableRecipe.recipeStatus
    recipe.takeCount = codableRecipe.takeCount
    
    return recipe
  }
}

//extension Int {
//  func recipeDisplayTime() -> String {
//    let hours = self / 60
//    let minutes = self % 60
//    
//    if hours > 0 {
//      return "\(hours) hours \(minutes) minutes"
//    }
//    return "\(minutes) minutes"
//  }
//  
//  func recipeDisplayTimeShort() -> String {
//    let hours = self / 60
//    let minutes = self % 60
//    
//    if hours > 0 {
//      return "\(hours) hrs \(minutes) mins"
//    }
//    return "\(minutes) mins"
//  }
//}
