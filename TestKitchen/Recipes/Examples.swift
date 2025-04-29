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
        preparationSteps: [
          PreparationStep(text: "Heat oil in a large pot over medium heat."),
          PreparationStep(text: "Add onions and sauté until soft and translucent."),
          PreparationStep(text: "Add carrots and celery and cook for an additional 5 minutes."),
          PreparationStep(text: "Add cod fillets and cook until flaky and browned on all sides."),
          PreparationStep(text: "Add potatoes and simmer until tender."),
          PreparationStep(text: "Add salt and pepper to taste."),
          PreparationStep(text: "Serve hot.")
        ],
        ingredients: [
          Ingredient(ingredient: "1/2 onion, diced"),
          Ingredient(ingredient: "1 carrot"),
          Ingredient(ingredient: "2 stalks of celery"),
          Ingredient(ingredient: "A pinch of black pepper"),
          Ingredient(ingredient: "3 tablespoons of olive oil"),
          Ingredient(ingredient: "2 tablespoons of lemon juice"),
          Ingredient(ingredient: "1 lb of cod fillets (frozen)"),
          Ingredient(ingredient: "1lb of russet potatoes")
        ]
      ),
      Recipe(
        title: "Big Brownie",
        author: "Derek Vallar",
        recipeDescription: "Tasy broni",
        photos: [],
        prepTime: 10,
        cookTime: 45,
        preparationSteps: [
          PreparationStep(text: "Heat oil in a large pot over medium heat."),
          PreparationStep(text: "Add onions and sauté until soft and translucent."),
          PreparationStep(text: "Add carrots and celery and cook for an additional 5 minutes."),
          PreparationStep(text: "Add cod fillets and cook until flaky and browned on all sides."),
          PreparationStep(text: "Add potatoes and simmer until tender."),
          PreparationStep(text: "Add salt and pepper to taste."),
          PreparationStep(text: "Serve hot."),
        ],
        ingredients: [
          Ingredient(ingredient: "1 cup of chocolate chips"),
          Ingredient(ingredient: "2 cups of all purpose flour"),
          Ingredient(ingredient: "1 cup of granulated sugar"),
          Ingredient(ingredient: "2 large eggs"),
          Ingredient(ingredient: "1 cup of unsalted butter, melted"),
          Ingredient(ingredient: "1 teaspoon of vanilla extract"),
        ]
      ),
      Recipe(
        title: "Ratatouille",
        author: "Remi the Chef",
        recipeDescription: "An excellent dish, just the way that dang rat made it in that one kids movie.  I'm pretty sure I'm not a rat, but I'm pretty sure I'm not a chef either.  I'm just a guy who likes to eat good food.  And this is good food. Please try it. I'm sure you'll like it.",
        photos: [],
        prepTime: 10,
        cookTime: 45,
        preparationSteps: [
          PreparationStep(text: "Heat oil in a large pot over medium heat."),
          PreparationStep(text: "Add onions and sauté until soft and translucent."),
          PreparationStep(text: "Add carrots and celery and cook for an additional 5 minutes."),
          PreparationStep(text: "Add cod fillets and cook until flaky and browned on all sides."),
          PreparationStep(text: "Add potatoes and simmer until tender."),
          PreparationStep(text: "Add salt and pepper to taste."),
          PreparationStep(text: "Serve hot.")
        ],
        ingredients: [
          Ingredient(ingredient: "1 zucchini"),
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
