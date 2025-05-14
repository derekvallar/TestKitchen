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
//    do {
//      try modelContext.delete(model: Recipe.self)
//    } catch {
//        print("Failed to delete all recipes.")
//    }


//    let appear = UINavigationBarAppearance()
//    let atters: [NSAttributedString.Key: Any] = [
//      .font: UIFont.TKDisplay
//    ]
//    appear.largeTitleTextAttributes = atters
//    UINavigationBar.appearance().standardAppearance = appear
  }

  var body: some View {
    @Bindable var navigationManager = navigationManager
    NavigationStack(path: $navigationManager.path) {
      CardScrollView()
//      .navigationTitle(
//        Text("Recipes")
//      )
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Test", systemImage: "minus") {
            navigationManager.path.append(Destination.recipeCreation(recipe: nil))

//            do {
//              try modelContext.delete(model: Recipe.self)
//            } catch {
//                print("Failed to delete all schools.")
//            }
//            try? modelContext.save()
          }
        }
      }
      .navigationDestination(for: Destination.self) { destination in
        switch destination {
        case .recipeCreation(let recipe):
          RecipeCreatorView(recipe: recipe)
        case .recipeDetails(let recipe):
          RecipeView(recipe: recipe)
        }
      }
    }
  }
}

#Preview {
  HomeView()
    .modelContainer(for: Recipe.self, inMemory: true)
}
