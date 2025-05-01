//
//  CardScrollView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/1/25.
//

import SwiftUI
import SwiftData

struct CardScrollView: View {

  @Query(sort: \Recipe.dateCreated, order: .reverse) var recipes: [Recipe]

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: .TKSpacingDefault) {

        if recipes.isEmpty {
          Spacer(minLength: 160)
          HStack {
            Spacer()
            Text("No recipes found")
              .TKTitle()
            Spacer()
          }
        } else {
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
    }
    .padding()
    .background(Color.TKBackgroundDefault)
    .animation(.spring, value: recipes)
  }
}
