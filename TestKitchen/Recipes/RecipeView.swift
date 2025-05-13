//
//  RecipeView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/4/25.
//

import SwiftUI

struct RecipeView: View, NavigatableView {
  static let navigationTag: String = "recipeView"
  @Environment(\.screenSize) var screenSize
  @Environment(\.navigationManager) var navigationManager: NavigationManager

  var recipe: Recipe

  init(recipe: Recipe) {
    self.recipe = recipe

    // Test
    recipe.photos = Array(repeating: Photo(), count: 5)
  }

  var body: some View {
    ScrollView {
      VStack {
        ScrollView(.horizontal) {
          HStack(spacing: 0) {
            ForEach(recipe.photos, id: \.self) { photo in
              Image("test_photo")
                .resizable()
                .scaledToFill()

//              # if debug
                .frame(width: 410, height: 240)
//              # else
//                .frame(width: screenSize.width, height: 240)
            }
          }
        }
        .scrollTargetBehavior(.paging)
      }
      VStack(alignment: .leading, spacing: .TKPagePadding) {
        title
        if recipe.prepTime != nil || recipe.cookTime != nil {
          HStack {
            if recipe.prepTime != nil {
              prepTimeView
            }
            if recipe.cookTime != nil {
              cookTimeView
            }
          }
        }
        if recipe.totalTime != nil {
          totalTimeView
        }
        recipeDescription
        DividerView(top: 30, bottom: 30)
        ingredientList
        DividerView(top: 30, bottom: 30)
        preparationSteps
      }
      .padding(.all, .TKPagePadding)
    }
    .scrollIndicators(.hidden)
    .navigationTitle(recipe.title)
    .navigationBarTitleDisplayMode(.large)
    .background(Color.TKBackgroundDefault)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Edit") {
          navigationManager.path.append(
            Destination.recipeCreation(recipe: recipe)
          )
        }
      }
    }
  }

  @ViewBuilder
  private var title: some View {
    Text(recipe.title)
      .TKDisplay()
      .frame(alignment: .leading)
      .padding(.bottom, 10)
      .multilineTextAlignment(.leading)
  }

  @ViewBuilder
  var prepTimeView: some View {
    Text("Prep Time:")
      .TKFontBody1Gray()
    Text("\(recipe.prepTime ?? "")")
      .TKFontBody1()
  }

  @ViewBuilder
  var cookTimeView: some View {
    Text("Cook Time:")
      .TKFontBody1Gray()
    Text("\(recipe.cookTime ?? "")")
      .TKFontBody1()
  }

  @ViewBuilder
  var totalTimeView: (some View)? {
    Text("Total Time:")
      .TKFontBody1Gray()
    Text("\(recipe.totalTime ?? "")")
      .TKFontBody1()
  }

  @ViewBuilder
  private var recipeDescription: some View {
    NavigationLink(
      destination: {
        CommunityView(
          text: recipe.recipeDescription ?? "",
          comments: TestExamples.makeCommunityComments()
        )
      },
      label: {
        Text(recipe.recipeDescription ?? "")
          .TKFontBody1()
          .frame(alignment: .leading)
          .multilineTextAlignment(.leading)
      }
    )
  }

  @ViewBuilder
  private var ingredientList: some View {
    VStack(alignment: .leading, spacing: .TKLineSpacingIngredients) {
      ForEach(0..<recipe.ingredients.count, id: \.self) { index in
        Text("\(recipe.ingredients[index].ingredient)")
          .TKFontBody1()
          .frame(minHeight: 30)
      }
    }
  }

  @ViewBuilder
  private var preparationSteps: some View {
    ForEach(0..<recipe.preparationSteps.count, id: \.self) { index in
      VStack(alignment: .leading, spacing: 4) {
        Text("Step \(index + 1)")
          .TKFontBody1BoldGray()
        Text("\(recipe.preparationSteps[index].text)")
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
  let height: CGFloat = 2

  init(top: CGFloat = 0, bottom: CGFloat = 0) {
    self.topSpacing = top
    self.bottomSpacing = bottom
  }

  var body: some View {
    Rectangle()
      .frame(height: height)
      .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
//      .foregroundStyle(Color.TKFontDefault)
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

