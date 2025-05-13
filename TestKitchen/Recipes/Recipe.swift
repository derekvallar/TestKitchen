//
//  Recipe.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/1/25.
//

import Foundation
import SwiftData
import _PhotosUI_SwiftUI

@Model
final class Recipe {
  // NOTE(dvallar): Make these recipes unique models depending on id (perhaps creator too?)
//  var id: UUID = UUID()
  var title: String
  var author: String?
  var dateCreated: Date
  var recipeDescription: String?
  var photos: [Photo]
  var prepTime: String?
  var cookTime: String?
  var totalTime: String?
  var preparationSteps: [PreparationStep]
  var ingredients: [Ingredient]
  
  init(
    title: String,
    author: String?,
    recipeDescription: String?,
    photos: [Photo],
    prepTime: String?,
    cookTime: String?,
    totalTime: String?,
    preparationSteps: [PreparationStep],
    ingredients: [Ingredient]
  ) {
    self.title = title
    self.author = author
    self.dateCreated = Date()
    self.recipeDescription = recipeDescription
    self.photos = photos
    self.prepTime = prepTime
    self.cookTime = cookTime
    self.totalTime = totalTime
    self.preparationSteps = preparationSteps
    self.ingredients = ingredients
  }

  init(
    title: String,
    author: String?,
    recipeDescription: String?,
    photos: [Photo],
    prepTime: String?,
    cookTime: String?,
    totalTime: String?,
    preparationSteps: [String],
    ingredients: String
  ) {
    self.title = title
    self.author = author
    self.dateCreated = Date()
    self.recipeDescription = recipeDescription
    self.photos = photos
    self.prepTime = prepTime
    self.cookTime = cookTime
    self.totalTime = totalTime
    self.preparationSteps = preparationSteps.map {
      PreparationStep(text: $0)
    }
    self.ingredients = ingredients.split(separator: "\n").map {
      $0.trimmingCharacters(in: .whitespaces)
    }.compactMap {
      Ingredient(ingredient: $0)
    }
  }}

struct PreparationStep: Codable, Identifiable {
  var id = UUID()
  let text: String
  
  init(text: String) {
    self.text = text
  }
}

struct Ingredient: Codable {
//  var id = UUID()
  let ingredient: String
}

struct Photo: Codable, Hashable {
  
}

extension Int {
  func recipeDisplayTime() -> String {
    let hours = self / 60
    let minutes = self % 60
    
    if hours > 0 {
      return "\(hours) hours \(minutes) minutes"
    }
    return "\(minutes) minutes"
  }
  
  func recipeDisplayTimeShort() -> String {
    let hours = self / 60
    let minutes = self % 60
    
    if hours > 0 {
      return "\(hours) hrs \(minutes) mins"
    }
    return "\(minutes) mins"
  }
}
