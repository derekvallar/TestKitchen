//
//  RecipeView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/4/25.
//

import SwiftUI

struct RecipeView: View {
  let recipe: Recipe

  init(recipe: Recipe) {
    self.recipe = recipe
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        Spacer()
          .frame(minHeight: 10)
        recipeDescription
        DividerView(top: 30, bottom: 30)
        ingredientList
        DividerView(top: 30, bottom: 30)
        preparationSteps
      }
      .padding([.leading, .trailing], 8)
    }
    .scrollIndicators(.hidden)
    .navigationTitle(recipe.title)
    .navigationBarTitleDisplayMode(.large)
//    .background(Color.TKBackgroundDefault)
  }

  @ViewBuilder
  private var recipeDescription: some View {
    NavigationLink(
      destination: {
        CommunityView(
          text: recipe.recipeDescription,
          comments: TestExamples.makeCommunityComments()
        )
      },
      label: {
        Text(recipe.recipeDescription)
          .TKFontBody1()
          .frame(alignment: .leading)
          .multilineTextAlignment(.leading)
      }
    )
  }

  @ViewBuilder
  private var ingredientList: some View {
    ForEach(0..<recipe.ingredients.count, id: \.self) { index in
      
      (Text("\(recipe.ingredients[index].quantity) ")
        .TKFontBody1()
      + Text(recipe.ingredients[index].name)
        .TKFontBody1Gray())
        .frame(minHeight: 30)
    }
  }

  @ViewBuilder
  private var preparationSteps: some View {
    ForEach(0..<recipe.instructions.count, id: \.self) { index in
      VStack(alignment: .leading, spacing: 4) {
        Text("Step \(index + 1)")
          .TKFontBody1BoldGray()
//          .TKFontBody1Gray()
        Text("\(recipe.instructions[index].text)")
          .TKFontBody1()
          .lineSpacing(4)
      }
      .padding(.bottom, 24)
    }
  }
}

struct DividerView: View {
  let topSpacing: CGFloat
  let bottomSpacing: CGFloat
  let height: CGFloat = 3

  init(top: CGFloat = 0, bottom: CGFloat = 0) {
    self.topSpacing = top
    self.bottomSpacing = bottom
  }

  var body: some View {
    Rectangle()
      .frame(height: height)
      .foregroundColor(Color.TKFontDefault)
      .clipShape(RoundedRectangle(cornerRadius: height/2))
      .padding(EdgeInsets(top: topSpacing, leading: 20, bottom: bottomSpacing, trailing: 20))
  }
}

struct RecipeView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    RecipeView(recipe: recipe)
  }
}

