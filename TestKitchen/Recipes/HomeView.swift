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
  @Query private var items: [Item]
  
  var recipes: [Recipe] = TestExamples.makeRecipes()
  
  init() {
    
    //Check which fonts available
    for family: String in UIFont.familyNames
    {
       print("\(family)")
      for names: String in UIFont.fontNames(forFamilyName: family)
       {
           print("== \(names)")
      }
      
      let appear = UINavigationBarAppearance()
      
      let atters: [NSAttributedString.Key: Any] = [
        .font: UIFont.TKDisplay
//        .font: UIFont.TKDisplay2
      ]
      
      appear.largeTitleTextAttributes = atters
//      appear.titleTextAttributes = atters
      UINavigationBar.appearance().standardAppearance = appear
//      UINavigationBar.appearance().compactAppearance = appear
//      UINavigationBar.appearance().scrollEdgeAppearance = appear
    }
  }
  
//  var body: some View {
//    NavigationSplitView {
//      List {
//        ForEach(items) { item in
//          NavigationLink {
//            RecipeView(recipe: TestExamples.makeRecipes().first!)
//          } label: {
//            Text(
//              item.timestamp,
//              format: Date.FormatStyle(
//                date: .numeric,
//                time: .standard
//              )
//            )
//            .background(Color.green)
//          }
//        }
//        .onDelete(perform: deleteItems)
//      }
//      .background(Color.blue)
//      .toolbar {
//        ToolbarItem(placement: .navigationBarTrailing) {
//          EditButton()
//        }
//        ToolbarItem {
//          Button(action: addItem) {
//            Label("Add Item", systemImage: "plus")
//          }
//        }
//      }
//
//    } detail: {
//      Text("Select an item")
//    }
//    .background(Color.TKBackgroundDefault)
//  }

  var body: some View {
    NavigationView {
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
      .navigationTitle(
        Text("Recipes")
      )
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          NavigationLink(
            destination: {
              RecipeCreatorView()
            }, label: {
              Label("New Recipe", systemImage: "plus")
            }
          )
        }
      }
      .background(Color.TKBackgroundDefault)
    }
  }

  private func addItem() {
    withAnimation {
      let newItem = Item(timestamp: Date())
      modelContext.insert(newItem)
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(items[index])
      }
    }
  }
}

#Preview {
  HomeView()
    .modelContainer(for: Item.self, inMemory: true)
}
