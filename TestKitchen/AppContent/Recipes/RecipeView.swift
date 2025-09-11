//
//  RecipeNavigatorView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/10/25.
//

import SwiftUI

struct RecipeView: View {

  enum Tab: Hashable {
    case details
    case comments
  }

  var recipe: Recipe
  @State var currentTab: Tab? = .details

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        RecipeDetailsTabView(
          recipe: recipe,
          currentTab: $currentTab
        )
        .id(Tab.details)
        .containerRelativeFrame(.horizontal)
        .containerRelativeFrame(.vertical)

        RecipeCommentsTabView(
          comments: TestExamples.makeCommunityComments(),
          currentTab: $currentTab
        )
        .id(Tab.comments)
        .containerRelativeFrame(.horizontal)
        .containerRelativeFrame(.vertical)

      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.paging)
    .scrollPosition(id: $currentTab)
  }
}

#Preview {
  RecipeView(recipe: TestExamples.makeRecipes().first!)
}
