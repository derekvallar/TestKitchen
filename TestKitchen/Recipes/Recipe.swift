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
  var recipeId: String?
  var isPublic: Bool = false
  var isArchived: Bool = false
  var dateCreated: Date

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
    preparationSteps: [String] = []
  ) {
    print("Prep time: \(prepTime ?? "")")
    self.title = title
    self.author = author
    self.recipeDescription = description
    self.prepTime = prepTime
    self.cookTime = cookTime
    self.totalTime = totalTime
    self.ingredients = ingredients
    self.preparationSteps = preparationSteps.map {
      PreparationStep(text: $0)
    }
  }
}

struct PreparationStep: Codable, Identifiable {
  var id = UUID()
  let text: String
  
  init(text: String) {
    self.text = text
  }
}

struct Photo: Codable, Hashable {
  
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
