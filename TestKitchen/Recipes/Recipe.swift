//
//  Recipe.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/1/25.
//

import Foundation
import SwiftData

@Model
final class Recipe {
  var title: String
  var author: String
  var recipeDescription: String
  var photos: [Photo]
  var prepTime: Int
  var cookTime: Int
  var totalTime: Int {
    prepTime + cookTime
  }
  var instructions: [Instruction]
  var ingredients: [RecipeIngredient]
  
  init(
    title: String,
    author: String,
    recipeDescription: String,
    photos: [Photo],
    prepTime: Int,
    cookTime: Int,
    instructions: [Instruction],
    ingredients: [RecipeIngredient]
  ) {
    self.title = title
    self.author = author
    self.recipeDescription = recipeDescription
    self.photos = photos
    self.prepTime = prepTime
    self.cookTime = cookTime
    self.instructions = instructions
    self.ingredients = ingredients
  }
}

struct Instruction: Codable, Identifiable {
  var id = UUID()
  let text: String
  
  init(text: String) {
    self.text = text
  }
}

struct RecipeIngredient: Codable {
//  var id = UUID()
  let name: String
  let quantity: String
}

class Photo: Codable {
  
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
