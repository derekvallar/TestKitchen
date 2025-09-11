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
  }

  var body: some View {
    ScrollView() {
      VStack(spacing: 0) {
        // Hero photo section
        photoCarousel
        
        // Recipe header with subtle social integration
        recipeHeaderSection
        
        // Social engagement and scoring system (prominent placement)
        socialEngagementTopSection
        
        // Cooking essentials - time, servings, difficulty  
        cookingEssentialsBar
        
        // Ingredients section (most important for cooking)
        if let ingredients = recipe.ingredients {
          ModernIngredientListView(
            ingredients: ingredients,
            tappedHighlightable: $tappedHighlightable
          )
        }
        
        // Instructions section
        modernPreparationSteps
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
    ZStack(alignment: .topTrailing) {
      if recipe.photos.isEmpty {
        // Elegant placeholder when no photos
        Rectangle()
          .fill(
            LinearGradient(
              colors: [Color.TKBackgroundLightGray, Color.TKBackgroundDefault],
              startPoint: .top,
              endPoint: .bottom
            )
          )
          .frame(height: 280)
          .overlay {
            VStack(spacing: 12) {
              Image(systemName: "fork.knife")
                .font(.system(size: 48))
                .foregroundStyle(Color.TKFontGray.opacity(0.6))
              Text(recipe.title)
                .font(.TKTitle)
                .fontWeight(.medium)
                .foregroundStyle(Color.TKFontDefault)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            }
            .padding(.horizontal, 32)
          }
      } else {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 0) {
            ForEach(recipe.photos, id: \.self) { photo in
              if let image = photo.image() {
                image
                  .resizable()
                  .scaledToFill()
                  .frame(width: screenSize.width, height: 280)
                  .clipped()
              }
            }
          }
        }
        .scrollTargetBehavior(.paging)
      }
      
      // Floating like/bookmark buttons (subtle, top-right)
      HStack(spacing: 12) {
        floatingActionButton(
          icon: recipe.isBookmarked ? SFSymbols.bookmark_fill : "bookmark",
          isActive: recipe.isBookmarked,
          activeColor: Color.TKBlue
        )
        
        floatingActionButton(
          icon: recipe.isLiked ? SFSymbols.heart_fill : "heart",
          isActive: recipe.isLiked,
          activeColor: Color.TKRed
        )
      }
      .padding(.top, 60)
      .padding(.trailing, 16)
    }
  }

  @ViewBuilder
  private var recipeHeaderSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Title and author
      VStack(alignment: .leading, spacing: 8) {
        Text(recipe.title)
          .font(.TKDisplay)
          .fontWeight(.bold)
          .foregroundStyle(Color.TKFontDefault)
        
        if let author = recipe.author {
          HStack(spacing: 8) {
            Text("by \(author)")
              .font(.TKBody1)
              .foregroundStyle(Color.TKFontDefaultSub)
            
            // Subtle social proof
            if recipe.likeCount > 0 || recipe.bookmarkCount > 0 {
              Text("•")
                .foregroundStyle(Color.TKFontGray)
              
              HStack(spacing: 4) {
                Image(systemName: SFSymbols.heart_fill)
                  .font(.system(size: 12))
                  .foregroundStyle(Color.TKRed)
                Text("\(recipe.likeCount)")
                  .font(.system(size: 12))
                  .foregroundStyle(Color.TKFontDefaultSub)
              }
            }
          }
        }
      }
      
      // Description
      if let description = recipe.recipeDescription, !description.isEmpty {
        Text(description)
          .font(.TKBody1)
          .foregroundStyle(Color.TKFontDefault)
          .lineSpacing(2)
      }
    }
    .padding(.horizontal, .TKPagePadding)
    .padding(.top, 24)
    .background(Color.white)
  }
  
  @ViewBuilder
  private var cookingEssentialsBar: some View {
    HStack(spacing: 0) {
      if let prepTime = recipe.prepTime {
        cookingInfoItem(icon: "clock", title: "Prep", value: prepTime)
      }
      
      if let cookTime = recipe.cookTime {
        cookingInfoItem(icon: "flame", title: "Cook", value: cookTime)
      }
      
      if let totalTime = recipe.totalTime {
        cookingInfoItem(icon: "timer", title: "Total", value: totalTime)
      }
      
      // Experiment score if available
      if let score = recipe.experimentScore {
        Divider()
          .frame(height: 40)
        
        VStack(spacing: 4) {
          Text(String(format: "%.1f", score))
            .font(.TKTitle)
            .fontWeight(.bold)
            .foregroundStyle(score >= 7.0 ? Color.TKGreen : Color.TKOrange)
          
          Text("Score")
            .font(.system(size: 11))
            .fontWeight(.medium)
            .foregroundStyle(Color.TKFontDefaultSub)
        }
        .frame(maxWidth: .infinity)
      }
    }
    .padding(.vertical, 20)
    .padding(.horizontal, .TKPagePadding)
    .background(Color.TKBackgroundLightGray)
  }
  
  @ViewBuilder
  private var socialEngagementTopSection: some View {
    VStack(spacing: 20) {
      // Social stats bar
      HStack(spacing: 0) {
        socialStatItem(icon: SFSymbols.heart_fill, count: recipe.likeCount, label: "likes", color: Color.TKRed)
        
        Divider()
          .frame(height: 30)
          .padding(.horizontal, 8)
        
        socialStatItem(icon: SFSymbols.bookmark_fill, count: recipe.bookmarkCount, label: "saves", color: Color.TKBlue)
        
        Divider()
          .frame(height: 30)
          .padding(.horizontal, 8)
        
        socialStatItem(icon: SFSymbols.quote_bubble, count: recipe.commentCount, label: "comments", color: Color.TKOrange)
        
        if recipe.takeCount > 0 {
          Divider()
            .frame(height: 30)
            .padding(.horizontal, 8)
          
          socialStatItem(icon: "fork.knife", count: recipe.takeCount, label: "takes", color: Color.TKGreen)
        }
      }
      .padding(.horizontal, .TKPagePadding)
      
      // Scoring system and status (brought back from SocialSectionView)
      if let score = recipe.experimentScore, let status = recipe.recipeStatus {
        HStack(spacing: 20) {
          // Experiment Score Circle
          VStack(spacing: 4) {
            Text(String(format: "%.1f", score))
              .font(.system(size: 28, weight: .bold))
              .foregroundStyle(score >= 7.0 ? Color.TKGreen : (score >= 5.0 ? Color.TKOrange : Color.TKRed))
              .frame(width: 60, height: 60)
              .overlay {
                Circle()
                  .stroke(score >= 7.0 ? Color.TKGreen : (score >= 5.0 ? Color.TKOrange : Color.TKRed), lineWidth: 2)
              }
            
            Text("Recipe Score")
              .font(.system(size: 11, weight: .medium))
              .foregroundStyle(Color.TKFontDefaultSub)
          }
          
          // Recipe Status and Changes
          VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
              Text("Status:")
                .font(.TKBody2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.TKFontDefault)
              
              Text(status)
                .font(.TKBody2)
                .foregroundStyle(Color.TKFontDefaultSub)
                .italic()
            }
            
            // Takes/Variations indicator
            if recipe.takeCount > 0 {
              HStack(spacing: 8) {
                ZStack {
                  // Stacked recipe cards effect
                  Rectangle()
                    .frame(width: 16, height: 20)
                    .foregroundStyle(Color.TKYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .rotationEffect(.degrees(10), anchor: .bottom)
                    .offset(x: 2, y: -2)
                  
                  Rectangle()
                    .frame(width: 16, height: 20)
                    .foregroundStyle(Color.TKYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    .rotationEffect(.degrees(-10), anchor: .bottom)
                    .offset(x: -2, y: 0)
                  
                  Rectangle()
                    .frame(width: 16, height: 20)
                    .foregroundStyle(Color.TKYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                }
                
                Text("See \(recipe.takeCount) Takes")
                  .font(.TKBody2)
                  .foregroundStyle(Color.TKFontDefault)
                  .fontWeight(.medium)
                
                Image(systemName: SFSymbols.chevron_right_circle)
                  .font(.system(size: 14))
                  .foregroundStyle(Color.TKFontGray)
              }
            }
          }
          
          Spacer()
        }
        .padding(.all, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.horizontal, .TKPagePadding)
      }
      
      // Recipe changes/updates section
      if let changeDescription = recipe.recipeChangeDescription, !changeDescription.isEmpty {
        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Text("Changes from previous version:")
              .font(.TKBody1)
              .fontWeight(.semibold)
              .foregroundStyle(Color.TKFontDefault)
            
            Spacer()
            
            Image(systemName: SFSymbols.chevron_right_circle)
              .foregroundStyle(Color.TKFontGray)
          }
          
          Text(changeDescription)
            .font(.TKBody1)
            .foregroundStyle(Color.TKFontDefault)
            .lineSpacing(2)
        }
        .padding(.all, 16)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(Color.TKBackgroundLightGray)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.TKOrange.opacity(0.3), lineWidth: 1)
            )
        )
        .padding(.horizontal, .TKPagePadding)
      }
    }
    .padding(.top, 16)
    .padding(.bottom, 8)
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
  private var modernPreparationSteps: some View {
    VStack(spacing: 0) {
      // Section header
      HStack {
        Text("Instructions")
          .font(.TKTitle)
          .fontWeight(.bold)
          .foregroundStyle(Color.TKFontDefault)
        
        Spacer()
        
        Text("\(recipe.preparationSteps.count) steps")
          .font(.TKBody2)
          .foregroundStyle(Color.TKFontDefaultSub)
      }
      .padding(.horizontal, .TKPagePadding)
      .padding(.top, 32)
      .padding(.bottom, 20)
      
      // Steps
      VStack(spacing: 20) {
        ForEach(0..<recipe.preparationSteps.count, id: \.self) { index in
          ModernPreparationStepView(
            recipe: recipe,
            stepNumber: index + 1,
            prepStep: recipe.preparationSteps[index],
            tappedHighlightable: $tappedHighlightable
          )
        }
      }
      .padding(.horizontal, .TKPagePadding)
      .padding(.bottom, 32)
    }
    .background(Color.TKBackgroundDefault)
  }
  
  
  // MARK: - Helper Views
  
  @ViewBuilder
  private func floatingActionButton(icon: String, isActive: Bool, activeColor: Color) -> some View {
    Button {
      // Handle action
    } label: {
      Image(systemName: icon)
        .font(.system(size: 16, weight: .medium))
        .foregroundStyle(isActive ? activeColor : Color.white)
        .frame(width: 40, height: 40)
        .background(
          Circle()
            .fill(isActive ? Color.white : Color.black.opacity(0.3))
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
  }
  
  @ViewBuilder
  private func cookingInfoItem(icon: String, title: String, value: String) -> some View {
    VStack(spacing: 6) {
      Image(systemName: icon)
        .font(.system(size: 18))
        .foregroundStyle(Color.TKOrange)
      
      VStack(spacing: 2) {
        Text(value)
          .font(.TKBody1)
          .fontWeight(.semibold)
          .foregroundStyle(Color.TKFontDefault)
        
        Text(title)
          .font(.system(size: 11))
          .fontWeight(.medium)
          .foregroundStyle(Color.TKFontDefaultSub)
      }
    }
    .frame(maxWidth: .infinity)
  }
  
  @ViewBuilder
  private func socialStatView(icon: String, count: Int, label: String, color: Color) -> some View {
    VStack(spacing: 4) {
      HStack(spacing: 6) {
        Image(systemName: icon)
          .font(.system(size: 16))
          .foregroundStyle(color)
        
        Text("\(count)")
          .font(.TKBody1)
          .fontWeight(.semibold)
          .foregroundStyle(Color.TKFontDefault)
      }
      
      Text(label)
        .font(.system(size: 11))
        .foregroundStyle(Color.TKFontDefaultSub)
    }
  }
  
  @ViewBuilder
  private func socialStatItem(icon: String, count: Int, label: String, color: Color) -> some View {
    VStack(spacing: 6) {
      HStack(spacing: 4) {
        Image(systemName: icon)
          .font(.system(size: 14))
          .foregroundStyle(color)
        
        Text("\(count)")
          .font(.TKBody1)
          .fontWeight(.semibold)
          .foregroundStyle(Color.TKFontDefault)
      }
      
      Text(label)
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(Color.TKFontDefaultSub)
    }
    .frame(maxWidth: .infinity)
  }
}

// MARK: - Modern Components

struct ModernIngredientListView: View {
  let ingredients: IngredientList
  @Binding var tappedHighlightable: Highlightable?

  var body: some View {
    VStack(spacing: 0) {
      // Section header
      HStack {
        Text("Ingredients")
          .font(.TKTitle)
          .fontWeight(.bold)
          .foregroundStyle(Color.TKFontDefault)
        
        Spacer()
        
        Button("View Details") {
          tappedHighlightable = .ingredients(ingredients)
        }
        .font(.TKBody2)
        .foregroundStyle(Color.TKBlue)
      }
      .padding(.horizontal, .TKPagePadding)
      .padding(.top, 24)
      .padding(.bottom, 16)
      
      // Ingredients content
      VStack(alignment: .leading, spacing: 12) {
        Text(ingredients.text)
          .font(.TKBody1)
          .lineSpacing(6)
          .foregroundStyle(Color.TKFontDefault)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.all, .TKPagePadding)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .padding(.horizontal, .TKPagePadding)
      .padding(.bottom, 8)
      .onTapGesture {
        tappedHighlightable = .ingredients(ingredients)
      }
    }
    .background(Color.TKBackgroundDefault)
  }
}

struct ModernPreparationStepView: View {
  @Environment(\.navigationManager) var navigationManager: NavigationManager

  let recipe: Recipe
  let stepNumber: Int
  let prepStep: PreparationStep
  
  @Binding var tappedHighlightable: Highlightable?

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      // Step number circle
      Text("\(stepNumber)")
        .font(.TKBody1)
        .fontWeight(.bold)
        .foregroundStyle(Color.white)
        .frame(width: 32, height: 32)
        .background(
          Circle()
            .fill(Color.TKOrange)
        )
      
      // Step content
      VStack(alignment: .leading, spacing: 8) {
        HStack {
          Text("Step \(stepNumber)")
            .font(.TKBody1)
            .fontWeight(.semibold)
            .foregroundStyle(Color.TKFontDefault)
          
          Spacer()
          
          if stepNumber.isMultiple(of: 4) {
            Button {
              tappedHighlightable = .prepStep(prepStep)
            } label: {
              Image(systemName: SFSymbols.quote_bubble)
                .font(.system(size: 16))
                .foregroundStyle(Color.TKBlue)
            }
          }
        }
        
        Text(prepStep.text)
          .font(.TKBody1)
          .lineSpacing(4)
          .foregroundStyle(Color.TKFontDefault)
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
    .padding(.all, 16)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .onTapGesture {
      tappedHighlightable = .prepStep(prepStep)
    }
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
