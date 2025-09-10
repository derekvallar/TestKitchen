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
  @State private var scrollOffset = CGPoint.zero
  @State var tappedHighlightable: Highlightable?

  init(recipe: Recipe) {
    self.recipe = recipe

    // Test
    recipe.photos = Array(repeating: Photo(data: Data()), count: 5)
  }

  var body: some View {
    ScrollView() {
      VStack(spacing: .TKPagePadding) {
        photoCarousel
        infoStack
        if let ingredients = recipe.ingredients {
          IngredientListView(
            ingredients: ingredients,
            tappedHighlightable: $tappedHighlightable
          )
        }
        preparationSteps
      }
    }
    .ignoresSafeArea(edges: .top)
    .scrollIndicators(.hidden)
    .background(Color.TKBackgroundDefault)
    .toolbarBackground(.hidden, for: .navigationBar)
    .toolbarRole(.editor)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button("Edit") {
          navigationManager.path.append(
            Destination.recipeCreation(recipe: recipe)
          )
        }
        .foregroundStyle(Color.white)
      }
    }
    .onScrollGeometryChange(for: CGPoint.self) { proxy in
      proxy.contentOffset
    } action: { oldOffset, offset in
      scrollOffset = offset
    }
    .sheet(
      item: $tappedHighlightable,
      onDismiss: {
        tappedHighlightable = nil
      },
      content: { highlightable in
        RecipeHighlightView(
          highlightId: highlightable.id,
          text: highlightable.text,
          recipeId: highlightable.recipeId
        )
        .presentationDetents([.fraction(0.6)])
        .presentationDragIndicator(.visible)
      }
    )
  }

  @ViewBuilder
  private var photoCarousel: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 0) {
        ForEach(recipe.photos, id: \.self) { photo in
          Image("test_photo")
            .resizable()
            .scaledToFill()
            #if DEBUG
            .frame(width: 410, height: 240)
            #else
            .frame(width: screenSize.width, height: 240)
            #endif
        }
      }
    }
    .scrollTargetBehavior(.paging)
//    .scaleEffect(scrollOffset)
  }

  @ViewBuilder
  private var infoStack: some View {
    VStack(alignment: .leading, spacing: .TKPagePadding) {
      title
      CTAStack
      RecipeTimeStackView(recipe: recipe)
      recipeDescription
    }
    .padding(.all, .TKPagePadding)
    .background(Color.TKBackgroundDefault)
  }

  @ViewBuilder
  private var title: some View {
    Text(recipe.title)
      .TKDisplay()
//      .frame(alignment: .leading)
//      .padding(.bottom, .TKPagePadding)
//      .multilineTextAlignment(.leading)
  }

  @ViewBuilder
  var timeViewStack: some View {
    if recipe.prepTime == nil && recipe.cookTime == nil && recipe.totalTime == nil {
      EmptyView()
    } else {
      VStack(spacing: .TKSpacingDefault) {
        if recipe.prepTime != nil || recipe.cookTime != nil {
          HStack {
            if let prepTime = recipe.prepTime{
              HStack {
                Text("Prep Time:")
                  .TKFontBody1Gray()
                Text("\(prepTime)")
                  .TKFontBody1()
              }
              .frame(maxWidth: .infinity, alignment: .leading)
            }
            if let cookTime = recipe.cookTime {
              HStack {
                Text("Cook Time:")
                  .TKFontBody1Gray()
                Text("\(cookTime)")
                  .TKFontBody1()
              }
              .frame(maxWidth: .infinity, alignment: .leading)
            }
          }
        }
        if let totalTime = recipe.totalTime {
          HStack {
            Text("Total Time:")
              .TKFontBody1Gray()
            Text("\(totalTime)")
              .TKFontBody1()
            Spacer()
          }
        }
      }
    }
  }

  @ViewBuilder
  var totalTimeView: some View {
    if let totalTime = recipe.totalTime{
      Text("Total Time:")
        .TKFontBody1Gray()
      Text("\(totalTime)")
        .TKFontBody1()
    } else {
      EmptyView()
    }
  }

  @ViewBuilder
  var CTAStack: some View {
    HStack(spacing: Spacing.extraLarge) {
      CTAButton(
        icon: SFSymbols.heart_fill,
        text: "103 likes",
        color: .TKRed,
        isActive: true,
        tapGesture: {}
      )
      CTAButton(
        icon: SFSymbols.frying_pan_fill,
        text: "22 tries",
        color: .TKGreen,
        isActive: true,
        tapGesture: {}
      )
      CTAButton(
        icon: SFSymbols.newspaper_fill,
        text: "4 crafts",
        color: .TKOrange,
        tapGesture: {}
      )
    }
  }

  @ViewBuilder
  private var recipeDescription: some View {
//    HStack {
//      NavigationLink(
//        destination: {
//          RecipeHighlightView(highlightId: "123", text: recipe., recipeId: <#T##String?#>)
//          RecipeHighlightView(
//            text: recipe.recipeDescription ?? "",
//            comments: TestExamples.makeCommunityComments()
//          )
//        },
//        label: {
          Text(recipe.recipeDescription ?? "")
            .TKFontBody1()
            .frame(alignment: .leading)
            .multilineTextAlignment(.leading)
//        }
//      )
//      // For some reason, the title section wont fill up the whole width of the screen, so we'll add a spacer here.
////      Spacer()
//    }
  }

  @ViewBuilder
  private var preparationSteps: some View {
    VStack(spacing: 0) {
      Text("Preparation")
        .TKTitle()
        .bold()
        .frame(
          maxWidth: .infinity,
          alignment: .leading
        )
        .padding(.bottom, Spacing.large)
      VStack(spacing: Spacing.extraLarge) {
        ForEach(0..<recipe.preparationSteps.count, id: \.self) { index in
          PreparationStepView(
            recipe: recipe,
            stepNumber: index + 1,
            prepStep: recipe.preparationSteps[index],
            tappedHighlightable: $tappedHighlightable
          )
        }
      }
    }
    .padding(.all, .TKPagePadding)
    .background(Color.TKBackgroundDefault)
  }
}

struct IngredientListView: View {

  let ingredients: IngredientList
  @Binding var tappedHighlightable: Highlightable?

  var body: some View {
    VStack(spacing: Spacing.large) {
      Text("Ingredients")
        .TKTitle()
        .bold()
        .frame(
          maxWidth: .infinity,
          alignment: .leading
        )
      Text(ingredients.text)
        .TKFontBody1()
        .lineSpacing(.TKLineSpacingIngredients)
        .frame(
          maxWidth: .infinity,
          minHeight: 30,
          alignment: .leading
        )
    }
    .padding(.all, .TKPagePadding)
    .background(Color.TKBackgroundDefault)
    .onTapGesture {
      tappedHighlightable = .ingredients(ingredients)
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

struct PreparationStepView: View {
  @Environment(\.navigationManager) var navigationManager: NavigationManager

  let recipe: Recipe
  let stepNumber: Int
  let prepStep: PreparationStep

  @Binding var tappedHighlightable: Highlightable?

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: Spacing.medium) {
        HStack(alignment: .center) {
          Text("Step \(stepNumber)")
            .font(Font.TKBody1)
            .bold()
            .foregroundStyle(Color.TKFontDefault)
          if stepNumber.isMultiple(of: 4) {

            Image(systemName: SFSymbols.quote_bubble)
              .foregroundStyle(Color.TKOrange)
          }
        }
        Text("\(prepStep.text)")
          .TKFontBody1()
          .lineSpacing(4)
      }
      .frame(
        maxWidth: .infinity,
        alignment: .leading
      )
      //      if prepStep.isTrending {
      if stepNumber.isMultiple(of: 4) {
        Image(systemName: SFSymbols.chevron_right_circle)
          .foregroundStyle(Color.TKOrange)
      }
    }
    .onTapGesture {
        tappedHighlightable = .prepStep(prepStep)
    }
  }
}

struct RecipeView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    RecipeView(recipe: recipe)
  }
}

