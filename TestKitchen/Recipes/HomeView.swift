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
  
  //  @Query private var items: [Item]

  @Query(sort: \Recipe.dateCreated) var recipes2: [Recipe]
  var recipes: [Recipe] = TestExamples.makeRecipes()

  init() {
    //Check which fonts available
//    for family: String in UIFont.familyNames
//    {
//       print("\(family)")
//      for names: String in UIFont.fontNames(forFamilyName: family)
//       {
//           print("== \(names)")
//      }
//    }

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
      ScrollView {
        VStack(alignment: .leading, spacing: .TKSpacingDefault) {
          ForEach(recipes) { recipe in
            NavigationLink(
              destination: {
                RecipeView(recipe: recipe)
              },
              label: {
                RecipeCardView(recipe: recipe)
                  .background(Color.TKBackgroundDefault)
              }
            )
          }
        }
      }

      .padding()
      .background(Color.TKBackgroundDefault)
      .navigationTitle(
        Text("Recipes")
      )
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
//          NavigationLink(
//            value: RecipeCreatorView.navigationTag,
//            label: {
//              Label(
//                "New Recipe",
//                systemImage: "plus"
//              )
//            }
//          )
          Button("Test", systemImage: "minus") {
            print("Test minus")
            navigationManager.path.append(RecipeCreatorView.navigationTag)
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

//  private func addItem() {
//    withAnimation {
//      let newItem = Item(timestamp: Date())
//      modelContext.insert(newItem)
//    }
//  }
//  
//  private func deleteItems(offsets: IndexSet) {
//    withAnimation {
//      for index in offsets {
//        modelContext.delete(items[index])
//      }
//    }
//  }
}

#Preview {
  HomeView()
    .modelContainer(for: Item.self, inMemory: true)
}
