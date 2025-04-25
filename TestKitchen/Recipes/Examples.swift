//
//  Examples.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/4/25.
//

import SwiftUI

struct TestExamples {
  static func makeRecipes() -> [Recipe] {
    return [
      Recipe(
        title: "Norwegian Fish Soup",
        author: "seriouseats.com",
        recipeDescription: "Hearty, rich and easy Norwegian fish soup with vegetables and cod fish fillets (fiskesuppe mod torsk) made just the way fisherman make it",
        photos: [],
        prepTime: 10,
        cookTime: 45,
        instructions: [
          Instruction(text: "Heat oil in a large pot over medium heat."),
          Instruction(text: "Add onions and sauté until soft and translucent."),
          Instruction(text: "Add carrots and celery and cook for an additional 5 minutes."),
          Instruction(text: "Add cod fillets and cook until flaky and browned on all sides."),
          Instruction(text: "Add potatoes and simmer until tender."),
          Instruction(text: "Add salt and pepper to taste."),
          Instruction(text: "Serve hot.")
        ],
        ingredients: [
          RecipeIngredient(name: "Onion, diced", quantity: "1/2"),
          RecipeIngredient(name: "Carrots", quantity: "1"),
          RecipeIngredient(name: "Celery", quantity: "2 stalks"),
          RecipeIngredient(name: "Black pepper", quantity: "A pinch"),
          RecipeIngredient(name: "Olive oil", quantity: "3 tablespoons"),
          RecipeIngredient(name: "Lemon juice", quantity: "2 tablespoons"),
          RecipeIngredient(name: "Cod fillets (frozen)", quantity: "1 lb"),
          RecipeIngredient(name: "Russet Potatoes", quantity: "1 lb")
        ]
      ),
      Recipe(
        title: "Big Brownie",
        author: "Derek Vallar",
        recipeDescription: "Tasy broni",
        photos: [],
        prepTime: 10,
        cookTime: 45,
        instructions: [
          Instruction(text: "Heat oil in a large pot over medium heat."),
          Instruction(text: "Add onions and sauté until soft and translucent."),
          Instruction(text: "Add carrots and celery and cook for an additional 5 minutes."),
          Instruction(text: "Add cod fillets and cook until flaky and browned on all sides."),
          Instruction(text: "Add potatoes and simmer until tender."),
          Instruction(text: "Add salt and pepper to taste."),
          Instruction(text: "Serve hot."),
        ],
        ingredients: [
          RecipeIngredient(name: "Chocolate chips", quantity: "1 cup"),
          RecipeIngredient(name: "All purpose flour", quantity: "2 cups"),
          RecipeIngredient(name: "Granulated sugar", quantity: "1 cup"),
          RecipeIngredient(name: "Large eggs", quantity: "2"),
          RecipeIngredient(name: "Unsalted butter", quantity: "1 cup"),
          RecipeIngredient(name: "Vanilla extract", quantity: "1 teaspoon"),
        ]
      ),
      Recipe(
        title: "Ratatouille",
        author: "Remi the Chef",
        recipeDescription: "An excellent dish, just the way that dang rat made it in that one kids movie.  I'm pretty sure I'm not a rat, but I'm pretty sure I'm not a chef either.  I'm just a guy who likes to eat good food.  And this is good food. Please try it. I'm sure you'll like it.",
        photos: [],
        prepTime: 10,
        cookTime: 45,
        instructions: [
          Instruction(text: "Heat oil in a large pot over medium heat."),
          Instruction(text: "Add onions and sauté until soft and translucent."),
          Instruction(text: "Add carrots and celery and cook for an additional 5 minutes."),
          Instruction(text: "Add cod fillets and cook until flaky and browned on all sides."),
          Instruction(text: "Add potatoes and simmer until tender."),
          Instruction(text: "Add salt and pepper to taste."),
          Instruction(text: "Serve hot.")
        ],
        ingredients: [
          RecipeIngredient(name: "Zucchini", quantity: "1"),
          
        ]
      ),
    ]
  }
  
  static func makeCommunityComments() -> [Comment] {
    return [
      Comment(
        commentText: "This was lovely! I really enjoyed it.",
        userName: "Haehae K.",
        upvoteCount: 27
      ),
      Comment(
        commentText: "Meh",
        userName: "derkatterk",
        upvoteCount: 1
      ),
      Comment(
        commentText: "According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees don't care what humans think is impossible.",
        userName: "Beeliever",
        upvoteCount: 13
      ),
      Comment(
        commentText: "I like the soup",
        userName: "SouperMan",
        upvoteCount: 3
      ),
    ]
  }
}
