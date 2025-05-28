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

  var prepTime: String?
  var cookTime: String?
  var totalTime: String?
  var ingredients: String?
  var preparationSteps: [PreparationStep]

  init(
    title: String,
    author: String? = nil,
    recipeDescription: String? = nil,
    photos: [Photo] = [],
    prepTime: String? = nil,
    cookTime: String? = nil,
    totalTime: String? = nil,
    ingredients: String? = nil,
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
  }

  func update(
    title: String,
    author: String? = nil,
    description: String? = nil,
    photos: [Photo] = [],
    prepTime: String? = nil,
    cookTime: String? = nil,
    totalTime: String? = nil,
    ingredients: String? = nil,
    preparationSteps: [PreparationStep] = []
  ) {
    print("Prep time: \(prepTime ?? "")")
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

struct PreparationStep: Codable, Highlightable {
  var id: String = UUID().uuidString
  let text: String
  let parentRecipeId: String?
  // This value should only be updated by the server
  let isTrending: Bool

  init(
    text: String,
    parentRecipeId: String? = "test123",
    isTrending: Bool = false
  ) {
    self.text = text
    self.parentRecipeId = parentRecipeId
    self.isTrending = isTrending
  }
}

protocol Highlightable {
  var id: String { get }
  var text: String { get }
  var parentRecipeId: String? { get }
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
