//
//  MyRecipesView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/11/25.
//

import SwiftUI
import SwiftData

struct MyRecipesView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.navigationManager) private var navigationManager

  @Query(sort: \Recipe.dateCreated, order: .reverse) var recipes: [Recipe]

  var body: some View {
    NavigationStack {
      ZStack {
        RecipeCardListView()
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              Button("Add Recipe", systemImage: "plus") {
                navigationManager.path.append(Destination.recipeCreation(recipe: nil))
              }
            }
          }
          .navigationTitle("My Recipes")
          .navigationDestination(for: Destination.self) { destination in
            switch destination {
            case .recipeCreation(let recipe):
              RecipeCreatorView(recipe: recipe)
            case .recipeDetails(let recipe):
              RecipeView(recipe: recipe)
            }
          }
      }
      .onAppear {
        // Update models here if needed
        for recipe in recipes {
          recipe.update(
            title: recipe.title,
            author: recipe.author,
            description: recipe.recipeDescription,
            photos: recipe.photos,
            prepTime: recipe.prepTime,
            cookTime: recipe.cookTime,
            totalTime: recipe.totalTime,
            ingredients: recipe.ingredients,
            preparationSteps: recipe.preparationSteps.map {
              PreparationStep(text: $0.text, isTrending: false)
            }
          )
        }
      }
    }
  }
}

#Preview {
  MyRecipesView()
    .modelContainer(for: Recipe.self)
}