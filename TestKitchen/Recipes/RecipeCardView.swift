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
    print("Prep time2: \(recipe.prepTime ?? "")")

  }

  var body: some View {
    VStack(spacing: .TKSpacingCard) {
      //      Image("test_photo")
      Image("test_vertical")
        .resizable()
        .scaledToFill()
        .frame(height: 200)
        .clipped()
      VStack(spacing: .TKSpacingCard) {
        title
        author
        timeStack
//        recipeDescription
      }
      .padding([.leading, .trailing, .bottom], .TKSpacingCard)
//      .background(Color.TKBlue)
//      .padding(.bottom, .TKSpacingCard)
    }
    .padding(.all, 10)
    .background(Color.TKBackgroundDefault)
    .border(Color.TKYellow, width: 10)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }

  @ViewBuilder
  private var title: some View {
    Text(recipe.title + "\n")
      .TKFontBody1()
      .lineLimit(2)
  }

  @ViewBuilder
  private var author: some View {
    if let author = recipe.author,
       !author.isEmpty {
      Text(author)
        .TKFontBody1()
        .lineLimit(1)
    }
  }

  @ViewBuilder
  private var timeStack: some View {
    HStack(spacing: 24) {
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

  @ViewBuilder
  private var recipeDescription: some View {
    Text(recipe.recipeDescription ?? "")
      .TKFontBody1()
      .lineLimit(3)
  }
}

struct RecipeCardView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    RecipeCardView(recipe: recipe)
  }
}
