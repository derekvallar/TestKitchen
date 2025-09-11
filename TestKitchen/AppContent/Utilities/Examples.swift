//
//  Examples.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/4/25.
//

import SwiftUI

struct TestExamples {
  static func makeRecipes() -> [Recipe] {
    // Create recipes with comprehensive data
    let recipes = [
      createHighRatedRecipe(),
      createExperimentalRecipe(),
      createPopularRecipe(),
      createNewRecipe(),
      createSimpleRecipe(),
    ]
    
    return recipes
  }
  
  // MARK: - Recipe Creation Helpers
  
  private static func createHighRatedRecipe() -> Recipe {
    let recipe = Recipe(
      title: "Perfect Sourdough Bread",
      author: "TheBreadMaster",
      recipeDescription: "A classic sourdough recipe that has been perfected over years of experimentation. The key is the long fermentation process that develops incredible flavor and creates that perfect chewy texture with a crispy crust.",
      photos: [],
      prepTime: "30 mins",
      cookTime: "45 mins",
      totalTime: "24 hours", // includes rise time
      ingredients: IngredientList(
        id: UUID().uuidString,
        text: "500g bread flour\n375g water (75% hydration)\n100g active sourdough starter\n10g salt\n1 tsp olive oil for greasing",
        recipeId: "sourdough-001"
      ),
      preparationSteps: [
        "Mix flour and water in a large bowl. Let autolyse for 30 minutes.",
        "Add active starter and salt. Mix until well combined.",
        "Perform 4 sets of stretch and folds, 30 minutes apart.",
        "First rise: 4-6 hours at room temperature until doubled.",
        "Shape the dough and place in banneton. Refrigerate overnight.",
        "Preheat Dutch oven to 500°F (260°C).",
        "Score the dough and bake covered for 20 minutes.",
        "Remove lid, reduce to 450°F, bake 20-25 minutes until golden.",
      ]
    )
    
    // Set social and experiment data
    recipe.recipeId = "sourdough-001"
    recipe.isPublic = true
    recipe.likeCount = 1247
    recipe.bookmarkCount = 892
    recipe.commentCount = 156
    recipe.isLiked = true
    recipe.isBookmarked = false
    recipe.experimentScore = 8.7
    recipe.recipeStatus = "Exceptional Recipe"
    recipe.takeCount = 23
    recipe.recipeChangeDescription = "Updated hydration ratio from 70% to 75% for better crumb structure. Added overnight cold fermentation step for improved flavor development."
    
    return recipe
  }
  
  private static func createExperimentalRecipe() -> Recipe {
    let recipe = Recipe(
      title: "Miso Caramel Ice Cream",
      author: "FlavorExplorer_2024",
      recipeDescription: "An adventurous fusion dessert combining the umami richness of white miso with sweet caramel. This recipe is still being perfected - help us improve it!",
      photos: [],
      prepTime: "45 mins",
      cookTime: "20 mins",
      totalTime: "6 hours", // includes chilling
      ingredients: IngredientList(
        id: UUID().uuidString,
        text: "2 cups heavy cream\n1 cup whole milk\n6 large egg yolks\n3/4 cup granulated sugar\n1/4 cup white miso paste\n1/2 cup caramel sauce\nPinch of sea salt",
        recipeId: "miso-ice-cream-001"
      ),
      preparationSteps: [
        "Heat cream and milk in a saucepan until just simmering.",
        "Whisk egg yolks and sugar until pale and thick.",
        "Temper the egg mixture with hot cream mixture.",
        "Cook custard until it coats the back of a spoon (170°F).",
        "Whisk in miso paste until smooth. Strain mixture.",
        "Cool completely, then churn in ice cream maker.",
        "Swirl in caramel sauce during last 2 minutes of churning.",
        "Freeze for at least 4 hours before serving.",
      ]
    )
    
    recipe.recipeId = "miso-ice-cream-001"
    recipe.isPublic = true
    recipe.likeCount = 89
    recipe.bookmarkCount = 234
    recipe.commentCount = 67
    recipe.isLiked = false
    recipe.isBookmarked = true
    recipe.experimentScore = 4.2
    recipe.recipeStatus = "Needs Improvement"
    recipe.takeCount = 8
    recipe.recipeChangeDescription = "Reduced miso from 1/3 cup to 1/4 cup - previous version was too salty. Still working on balancing the umami flavor."
    
    return recipe
  }
  
  private static func createPopularRecipe() -> Recipe {
    let recipe = Recipe(
      title: "Ultimate Crispy Fried Chicken",
      author: "ChefSouthernComfort",
      recipeDescription: "The crispiest, most flavorful fried chicken you'll ever make. Secret ingredients include buttermilk brine and a double-dredge technique that creates an incredibly crunchy coating.",
      photos: [],
      prepTime: "20 mins",
      cookTime: "25 mins",
      totalTime: "4 hours", // includes marinating
      ingredients: IngredientList(
        id: UUID().uuidString,
        text: "3 lbs chicken pieces\n2 cups buttermilk\n2 tbsp hot sauce\n2 cups all-purpose flour\n1 cup cornstarch\n2 tbsp paprika\n1 tbsp garlic powder\n1 tbsp onion powder\n2 tsp cayenne pepper\n1 tsp black pepper\n2 tsp salt\nVegetable oil for frying",
        recipeId: "fried-chicken-001"
      ),
      preparationSteps: [
        "Marinate chicken in buttermilk and hot sauce for 2-4 hours.",
        "Mix flour, cornstarch, and all spices in a large bowl.",
        "Remove chicken from buttermilk, letting excess drip off.",
        "Dredge chicken in seasoned flour mixture twice for extra crunch.",
        "Heat oil to 350°F (175°C) in a heavy pot or deep fryer.",
        "Fry chicken pieces in batches, 12-15 minutes until golden brown.",
        "Internal temperature should reach 165°F (74°C).",
        "Rest on wire rack for 5 minutes before serving.",
      ]
    )
    
    recipe.recipeId = "fried-chicken-001"
    recipe.isPublic = true
    recipe.likeCount = 3422
    recipe.bookmarkCount = 1876
    recipe.commentCount = 298
    recipe.isLiked = true
    recipe.isBookmarked = true
    recipe.experimentScore = 7.9
    recipe.recipeStatus = "Community Favorite"
    recipe.takeCount = 47
    recipe.recipeChangeDescription = nil
    
    return recipe
  }
  
  private static func createNewRecipe() -> Recipe {
    let recipe = Recipe(
      title: "Big Brownie (But Actually Good This Time)",
      author: "Derek Vallar",
      recipeDescription: "Okay, my last brownie recipe was... let's call it 'a learning experience'. This time I actually measured things and didn't just wing it. These brownies are fudgy, chocolatey, and won't break your teeth. Promise.",
      photos: [],
      prepTime: "15 mins",
      cookTime: "35 mins",
      totalTime: "50 mins",
      ingredients: IngredientList(
        id: UUID().uuidString,
        text: "1 cup unsalted butter\n2 cups granulated sugar\n4 large eggs\n3/4 cup unsweetened cocoa powder\n1 cup all-purpose flour\n1/2 tsp salt\n1/2 tsp baking powder\n2 cups chocolate chips\n1 tsp vanilla extract",
        recipeId: "big-brownie-002"
      ),
      preparationSteps: [
        "Preheat oven to 350°F (175°C). Grease a 9x13 inch pan.",
        "Melt butter in a large bowl (microwave works fine).",
        "Stir in sugar until combined. Add eggs one at a time.",
        "Mix in cocoa powder, flour, salt, and baking powder.",
        "Fold in chocolate chips and vanilla extract.",
        "Pour into prepared pan and spread evenly.",
        "Bake for 30-35 minutes until toothpick comes out with fudgy crumbs.",
        "Let cool completely before cutting. Seriously. Wait.",
      ]
    )
    
    recipe.recipeId = "big-brownie-002"
    recipe.isPublic = true
    recipe.likeCount = 423
    recipe.bookmarkCount = 267
    recipe.commentCount = 84
    recipe.isLiked = false
    recipe.isBookmarked = false
    recipe.experimentScore = 6.8
    recipe.recipeStatus = "Redemption Arc"
    recipe.takeCount = 15
    recipe.recipeChangeDescription = "Complete overhaul from the disaster that was version 1.0. Added proper measurements, baking powder, and actual chocolate chips instead of 'whatever was in the pantry'."
    
    return recipe
  }
  
  private static func createSimpleRecipe() -> Recipe {
    let recipe = Recipe(
      title: "Ratatouille",
      author: "Remi the Chef",
      recipeDescription: "An excellent dish, just the way that dang rat made it in that one kids movie. I'm pretty sure I'm not a rat, but I'm pretty sure I'm not a chef either. I'm just a guy who likes to eat good food. And this is good food. Please try it. I'm sure you'll like it.",
      photos: [],
      prepTime: "15 mins",
      cookTime: "30 mins",
      totalTime: "45 mins",
      ingredients: IngredientList(
        id: UUID().uuidString,
        text: "1 medium zucchini, sliced\n1 medium eggplant, sliced\n2 medium tomatoes, sliced\n1 yellow bell pepper, sliced\n1 red onion, sliced\n3 cloves garlic, minced\n2 tbsp olive oil\n1 tsp dried thyme\n1 tsp dried oregano\nSalt and pepper to taste\nFresh basil for garnish",
        recipeId: "ratatouille-001"
      ),
      preparationSteps: [
        "Preheat oven to 375°F (190°C). Lightly grease a baking dish.",
        "Arrange sliced vegetables in an overlapping pattern in the dish.",
        "In a small bowl, mix olive oil, garlic, thyme, and oregano.",
        "Drizzle the herb mixture over the arranged vegetables.",
        "Season generously with salt and pepper.",
        "Cover with foil and bake for 30 minutes until vegetables are tender.",
        "Remove foil and bake 10 more minutes for slight browning.",
        "Garnish with fresh basil and serve hot. Bon appétit!",
      ]
    )
    
    recipe.recipeId = "ratatouille-001"
    recipe.isPublic = true
    recipe.likeCount = 2847
    recipe.bookmarkCount = 1293
    recipe.commentCount = 189
    recipe.isLiked = true
    recipe.isBookmarked = true
    recipe.experimentScore = 9.2
    recipe.recipeStatus = "Legendary Recipe"
    recipe.takeCount = 67
    recipe.recipeChangeDescription = "Anyone can cook! Updated with proper vegetable layering technique after watching that documentary about the fancy restaurant critic."
    
    return recipe
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
