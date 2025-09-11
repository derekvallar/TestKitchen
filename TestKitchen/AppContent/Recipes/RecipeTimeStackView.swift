//
//  RecipeTimeStackView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/19/25.
//

import SwiftUI

struct RecipeTimeStackView: View {

  let recipe: Recipe

  var body: some View {
    HStack(spacing: .xl) {
      VStack {
        Text("Prep")
          .TKFontBody2Gray()
        Text("\(recipe.prepTime ?? "-")")
        .TKFontBody2()
        .lineLimit(2)
      }
      .frame(maxWidth: .infinity)
      VStack {
        Text("Cook")
          .TKFontBody2Gray()
        Text("\(recipe.cookTime ?? "-")")
        .TKFontBody2()
        .lineLimit(2)
      }
      .frame(maxWidth: .infinity)
      VStack {
        Text("Total")
          .TKFontBody2Gray()
        Text("\(recipe.totalTime ?? "-")")
        .TKFontBody2()
        .lineLimit(2)
      }
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  RecipeTimeStackView(recipe: TestExamples.makeRecipes().first!)
}
