//
//  RecipeCardListView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/20/25.
//

import SwiftData
import SwiftUI

struct RecipeCardListView: View {

  @Environment(\.screenSize) private var screenSize
  @Environment(\.navigationManager) private var navigationManager
//  @Query(sort: \Recipe.dateCreated, order: .reverse) var recipes: [Recipe]
  @Query(sort: \Recipe.dateCreated) var recipes: [Recipe]

  var body: some View {
    List {
      ForEach(Array(zip(recipes.indices, recipes)), id: \.0) { index, recipe in
        RecipeArticleView(recipe: recipe)

          .listRowSeparator(.hidden)
      }
    }
    .listStyle(.plain)
//    .scrollClipDisabled()
  }
}
