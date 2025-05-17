//
//  RecipeCardView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

struct RecipeCardView: View {

  let recipe: Recipe
  let width: CGFloat
  let height: CGFloat

  init(recipe: Recipe, width: CGFloat, height: CGFloat) {
    self.recipe = recipe
    self.width = width
    self.height = height
  }

  var body: some View {
    VStack(spacing: .TKSpacingCard) {
      VStack(spacing: .TKSpacingCard) {
        title
        author
        timeStack
//        recipeDescription
      }
      .padding([.leading, .trailing, .top], .TKSpacingCard)
      Spacer()
      Image("test_photo")
//      Image("test_vertical")
        .resizable()
        .scaledToFill()
        .frame(height: 200)
        .clipped()

//      .background(Color.TKBlue)
//      .padding(.bottom, .TKSpacingCard)
    }
    .frame(
      width: width,
      height: height
    )
    .background(Color.TKBackgroundDefault)
    .padding(.all, 10)
    .border(Color.TKYellow, width: 10)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(radius: 1, x: 8, y: 8)
  }

  @ViewBuilder
  private var title: some View {
    // Adding the \n helps force max height of the text
    Text(recipe.title)
      .TKDisplay()
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
//      .background(Color.TKBlue)
//      .padding(.TKSpacingCard)
  }

  @ViewBuilder
  private var author: some View {
    if let author = recipe.author,
       !author.isEmpty {
      // Adding the \n helps force max height of the text
      Text("Crafted by: " + author)
        .TKFontBody2Gray()
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
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
    RecipeCardView(recipe: recipe, width: 300, height: 500)
  }
}
