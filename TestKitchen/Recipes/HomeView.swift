//
//  HomeView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/1/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.navigationManager) private var navigationManager

  @Query(sort: \Recipe.dateCreated, order: .reverse) var recipes: [Recipe]

//  var recipes: [Recipe] = TestExamples.makeRecipes()

  init() {
    let appear = UINavigationBarAppearance()
    let atters: [NSAttributedString.Key: Any] = [
      .font: UIFont.TKDisplay
    ]
    appear.largeTitleTextAttributes = atters
    UINavigationBar.appearance().standardAppearance = appear
  }

  var body: some View {
    @Bindable var navigationManager = navigationManager
    NavigationStack(path: $navigationManager.path) {
      CardScrollView()
      .navigationTitle(
        Text("Recipes")
      )
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Test", systemImage: "minus") {
            print("Test minus")
            navigationManager.path.append(RecipeCreatorView.navigationTag)
//            for recipe in recipes {
//              modelContext.delete(recipe)
//            }
//            try? modelContext.save()
          }
        }
      }
      .navigationDestination(for: Recipe.self) { recipe in
          RecipeView(recipe: recipe)
      }
      .navigationDestination(for: String.self) { destination in
        // destination == recipeCreation
        RecipeCreatorView()
      }
    }
  }
}

#Preview {
  HomeView()
    .modelContainer(for: Recipe.self, inMemory: true)
}
