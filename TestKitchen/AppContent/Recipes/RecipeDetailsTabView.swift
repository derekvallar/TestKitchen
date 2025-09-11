//
//  RecipeView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/4/25.
//

import SwiftUI

struct RecipeDetailsTabView: View, NavigatableView {
  static let navigationTag: String = "recipeDetailsTab"

  @Environment(\.screenSize) var screenSize
  @Environment(\.navigationManager) var navigationManager: NavigationManager

  var recipe: Recipe
  @Binding var currentTab: RecipeView.Tab?
  @State private var scrollOffset = CGPoint.zero
  @State var tappedHighlightable: Highlightable?

  init(recipe: Recipe, currentTab: Binding<RecipeView.Tab?>) {
    self.recipe = recipe
    self._currentTab = currentTab

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
        if currentTab == .details {
          Button("Edit") {
            navigationManager.path.append(
              Destination.recipeCreation(recipe: recipe)
            )
          }
          .foregroundStyle(Color.white)
        }
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
      HStack {
        title
        Spacer()
        VStack(spacing: 8) {
          LikeView
          BookmarkView
        }
      }
      SocialSectionView(recipe: recipe)
      recipeDescription
      RecipeTimeStackView(recipe: recipe)
    }
    .padding(.horizontal, .TKPagePadding)
    .background(Color.TKBackgroundDefault)
  }

  @ViewBuilder
  private var title: some View {
    Text(recipe.title)
      .TKDisplay()
  }

  @ViewBuilder
  private var LikeView: some View {
    HStack(spacing: 6) {
      Image(systemName: SFSymbols.heart_fill)
        .foregroundStyle(Color.TKRed)
        .font(.system(size: 24))
      Text("1.2k")
        .TKFontBody1()
    }
  }

  @ViewBuilder
  private var BookmarkView: some View {
    HStack(spacing: 6) {
      Image(systemName: SFSymbols.bookmark_fill)
        .foregroundStyle(Color.TKBlue)
        .font(.system(size: 24))
      Text("1.2k")
        .TKFontBody1()
    }
  }


  @ViewBuilder
  private var recipeDescription: some View {
    Text(recipe.recipeDescription ?? "")
      .TKFontBody1()
      .frame(alignment: .leading)
      .multilineTextAlignment(.leading)
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

#Preview {
  @Previewable @State var tab: RecipeView.Tab? = .details
  RecipeCommentsTabView(comments: TestExamples.makeCommunityComments(), currentTab: $tab)
}
