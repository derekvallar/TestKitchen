//
//  RecipeCardView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

struct RecipeCardView: View {

  var recipe: Recipe

  init(recipe: Recipe) {
    self.recipe = recipe
  }

  var body: some View {
    VStack(spacing: 16) {
      //      Image("test_photo")
      Image("test_vertical")
        .resizable()
        .scaledToFill()
        .frame(height: 200)
        .clipped()
      VStack(spacing: 8) {
        Text(recipe.title)
          .TKTitle()
          .lineLimit(2)
        if let author = recipe.author,
           !author.isEmpty {
          Text(author)
            .TKFontBody1()
            .lineLimit(1)
        }
        HStack(spacing: .TKSpacingDefault) {
          (Text("Prep: ")
            .TKFontBody2Gray()
           + Text("\(recipe.prepTime ?? "")"))
          .TKFontBody2()
          Text("|")
            .TKFontBody2Gray()
          Text("Total: ")
            .TKFontBody2Gray()
          + Text("\(recipe.totalTime ?? "")")
            .TKFontBody2()
        }
        Text(recipe.recipeDescription ?? "")
          .TKFontBody1()
          .lineLimit(3)
      }
      .padding()
      Spacer()
    }
    .background(Color.TKBackgroundDefault)
    .border(Color.TKYellow, width: 8)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

struct RecipeCardView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    RecipeCardView(recipe: recipe)
  }
}
