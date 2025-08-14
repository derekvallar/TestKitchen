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
        prepTime: "10 mins",
        cookTime: "45 mins",
        totalTime: "55 mins",
        ingredients: IngredientList(
          id: "test123",
          text: "1/2 onion, diced\n1 carrot\n2 stalks of celery\nA pinch of black pepper\n3 tablespoons of olive oil\n2 tablespoons of lemon juice\n1 lb of cod fillets (frozen)\n1 lb of russet potatoes",
          recipeId: "recipe123"
        ),
        preparationSteps: [
          "Heat oil in a large pot over medium heat.",
          "Add onions and sauté until soft and translucent.",
          "Add carrots and celery and cook for an additional 5 minutes.",
          "Add cod fillets and cook until flaky and browned on all sides.",
          "Add potatoes and simmer until tender.",
          "Add salt and pepper to taste.",
          "Serve hot.",
        ]
      ),
      Recipe(
        title: "Big Brownie",
        author: "Derek Vallar",
        recipeDescription: "Tasy broni",
        photos: [],
        prepTime: nil,
        cookTime: "1 hour",
        totalTime: "1 hour",
        ingredients: IngredientList(
          id: "test123",
          text: "1 cup of chocolate chips\n2 cups of all purpose flour\n1 cup of granulated sugar\n2 large eggs\n1 cup of unsalted butter, melted\n1 teaspoon of vanilla extract",
          recipeId: "recipe123"
        ),
        preparationSteps: [
          "Heat oil in a large pot over medium heat.",
          "Add onions and sauté until soft and translucent.",
          "Add carrots and celery and cook for an additional 5 minutes.",
          "Add cod fillets and cook until flaky and browned on all sides.",
          "Add potatoes and simmer until tender.",
          "Add salt and pepper to taste.",
          "Serve hot.",
        ]
      ),
      Recipe(
        title: "Ratatouille",
        author: "Remi the Chef",
        recipeDescription: "An excellent dish, just the way that dang rat made it in that one kids movie.  I'm pretty sure I'm not a rat, but I'm pretty sure I'm not a chef either.  I'm just a guy who likes to eat good food.  And this is good food. Please try it. I'm sure you'll like it.",
        photos: [],
        prepTime: "15 mins",
        cookTime: "30 mins",
        totalTime: "45 mins",
        ingredients: IngredientList(
          id: "test123",
          text: "1 zucchini",
          recipeId: "recipe123"
        ),
        preparationSteps: [
          "Heat oil in a large pot over medium heat.",
          "Add onions and sauté until soft and translucent.",
          "Add carrots and celery and cook for an additional 5 minutes.",
          "Add cod fillets and cook until flaky and browned on all sides.",
          "Add potatoes and simmer until tender.",
          "Add salt and pepper to taste.",
          "Serve hot.",
        ]
      ),
    ]
  }

  static func makeCommunityComments() -> [Comment] {
    return [
      Comment(
        commentText: "This was lovely! I really enjoyed it.",
        user: User(userID: "3213", username: "Haekae", profileImage: Data()),
        upvoteCount: 27,
      ),
      Comment(
        commentText: "Meh",
        user: User(userID: "123", username: "DerkPutsInTheWerk", profileImage: Data()),
        upvoteCount: 1
      ),
      Comment(
        commentText: "According to all known laws of aviation, there is no way a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees don't care what humans think is impossible.",
        user: User(userID: "333", username: "Beeliever", profileImage: Data()),
        upvoteCount: 13
      ),
      Comment(
        commentText: "I like the soup",
        user: User(userID: "1", username: "SouperMan", profileImage: Data()),
        upvoteCount: 3
      ),
    ]
  }
}
