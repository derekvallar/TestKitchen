//
//  RecipeCarousel.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/11/25.
//

import SwiftUI

// MARK: - Backend Data Models

// MARK: - Backend Response Models (Codable)

struct CarouselDataResponse: Codable, Identifiable {
  let id: String
  let title: String
  let subtitle: String?
  let cardStyle: String
  let backgroundColor: String?
  let recipes: [CodableRecipe]
}

// MARK: - Frontend Models (Used throughout app)

struct CarouselData: Identifiable {
  let id: String
  let title: String
  let subtitle: String?
  let cardStyle: String
  let backgroundColor: String?
  let recipes: [Recipe]
  
  init(
    id: String = UUID().uuidString,
    title: String,
    subtitle: String? = nil,
    cardStyle: String = "standard",
    backgroundColor: String? = nil,
    recipes: [Recipe] = []
  ) {
    self.id = id
    self.title = title
    self.subtitle = subtitle
    self.cardStyle = cardStyle
    self.backgroundColor = backgroundColor
    self.recipes = recipes
  }
  
  init(from response: CarouselDataResponse) {
    self.id = response.id
    self.title = response.title
    self.subtitle = response.subtitle
    self.cardStyle = response.cardStyle
    self.backgroundColor = response.backgroundColor
    self.recipes = response.recipes.map { Recipe.fromCodable($0) }
  }
}

// MARK: - Backend Response Models

struct HomePageDataResponse: Codable {
  let carousels: [CarouselDataResponse]
  let featuredRecipes: [CodableRecipe]?
  let banners: [BannerData]?
}

// MARK: - Frontend Models

struct HomePageData {
  let carousels: [CarouselData]
  let featuredRecipes: [Recipe]?
  let banners: [BannerData]?
  
  init(
    carousels: [CarouselData] = [],
    featuredRecipes: [Recipe]? = nil,
    banners: [BannerData]? = nil
  ) {
    self.carousels = carousels
    self.featuredRecipes = featuredRecipes
    self.banners = banners
  }
  
  init(from response: HomePageDataResponse) {
    self.carousels = response.carousels.map { CarouselData(from: $0) }
    self.featuredRecipes = response.featuredRecipes?.map { Recipe.fromCodable($0) }
    self.banners = response.banners
  }
}

struct BannerData: Codable, Identifiable {
  let id: String
  let title: String
  let message: String
  let backgroundColor: String
  let textColor: String
  let actionText: String?
  let actionUrl: String?
  
  init(
    id: String = UUID().uuidString,
    title: String,
    message: String,
    backgroundColor: String = "#FF8133",
    textColor: String = "#FFFFFF",
    actionText: String? = nil,
    actionUrl: String? = nil
  ) {
    self.id = id
    self.title = title
    self.message = message
    self.backgroundColor = backgroundColor
    self.textColor = textColor
    self.actionText = actionText
    self.actionUrl = actionUrl
  }
}

// MARK: - Card Style Enum

enum CarouselCardStyle: String, CaseIterable {
  case standard = "standard"
  case compact = "compact"
  case featured = "featured"
  case minimal = "minimal"
  
  static func from(string: String) -> CarouselCardStyle {
    return CarouselCardStyle(rawValue: string) ?? .standard
  }
}

// MARK: - Recipe Carousel View

struct RecipeCarousel: View {
  let carouselData: CarouselData
  @Environment(\.navigationManager) var navigationManager
  
  private var cardStyle: CarouselCardStyle {
    CarouselCardStyle.from(string: carouselData.cardStyle)
  }
  
  private var backgroundColor: Color {
    if let bgColor = carouselData.backgroundColor {
      return Color(hex: bgColor) ?? Color.TKBackgroundDefault
    }
    return Color.TKBackgroundDefault
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: .large) {
      carouselHeader
      
      if carouselData.recipes.isEmpty {
        emptyStateView
      } else {
        carouselScrollView
      }
    }
    .padding(.vertical, .medium)
    .background(backgroundColor)
  }
  
  @ViewBuilder
  private var carouselHeader: some View {
    VStack(alignment: .leading, spacing: .xs) {
      Text(carouselData.title)
        .font(.TKTitle)
        .fontWeight(.bold)
        .foregroundStyle(Color.TKFontDefault)
      
      if let subtitle = carouselData.subtitle {
        Text(subtitle)
          .font(.TKBody2)
          .foregroundStyle(Color.TKFontDefaultSub)
      }
    }
    .padding(.horizontal, .pagePadding)
  }
  
  @ViewBuilder
  private var carouselScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: .xl) {
        ForEach(carouselData.recipes, id: \.self) { recipe in
          carouselCard(for: recipe)
            .onTapGesture {
              navigationManager.path.append(Destination.recipeDetails(recipe: recipe))
            }
        }
      }
      .padding(.horizontal, .pagePadding)
    }
  }
  
  @ViewBuilder
  private func carouselCard(for recipe: Recipe) -> some View {
    switch cardStyle {
    case .standard:
      StandardCarouselCard(recipe: recipe)
    case .compact:
      CompactCarouselCard(recipe: recipe)
    case .featured:
      FeaturedCarouselCard(recipe: recipe)
    case .minimal:
      MinimalCarouselCard(recipe: recipe)
    }
  }
  
  @ViewBuilder
  private var emptyStateView: some View {
    VStack(spacing: .medium) {
      Image(systemName: "fork.knife.circle")
        .font(.TKDisplay)
        .foregroundStyle(Color.TKFontGray)
      Text("No recipes found")
        .font(.TKBody2)
        .foregroundStyle(Color.TKFontGray)
    }
    .frame(height: TKSize.cardHeight)
    .frame(maxWidth: .infinity)
  }
}

// MARK: - Carousel Card Styles

struct StandardCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: .medium) {
      recipeImage
      recipeInfo
    }
    .frame(width: TKSize.cardWidthMedium)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.large))
    .tkShadowMedium()
  }
  
  @ViewBuilder
  private var recipeImage: some View {
    Rectangle()
      .fill(Color.TKBackgroundLightGray)
      .frame(height: TKSize.cardHeight)
      .overlay {
        if let photo = recipe.photos.first,
           let image = photo.image() {
          image
            .resizable()
            .scaledToFill()
        } else {
          Image(systemName: "fork.knife")
            .foregroundStyle(Color.TKFontGray)
            .font(.TKTitle)
        }
      }
      .clipped()
  }
  
  @ViewBuilder
  private var recipeInfo: some View {
    VStack(alignment: .leading, spacing: .xs) {
      Text(recipe.title)
        .font(.TKBody1)
        .fontWeight(.semibold)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      if let author = recipe.author {
        Text("by \(author)")
          .font(.TKBody2)
          .foregroundStyle(Color.TKFontDefaultSub)
          .lineLimit(1)
      }
      
      HStack {
        Image(systemName: SFSymbols.heart_fill)
          .foregroundStyle(Color.TKRed)
          .font(.TKBody2)
        Text("\(recipe.likeCount)")
          .font(.TKBody2)
          .foregroundStyle(Color.TKFontDefaultSub)
        
        Spacer()
        
        if let score = recipe.experimentScore {
          Text(String(format: "%.1f", score))
            .font(.TKBody2)
            .fontWeight(.semibold)
            .foregroundStyle(Color.TKGreen)
        }
      }
    }
    .padding(.horizontal, .large)
    .padding(.bottom, .large)
  }
}

struct CompactCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    HStack(spacing: .large) {
      Rectangle()
        .fill(Color.TKBackgroundLightGray)
        .frame(width: TKSize.avatarMedium, height: TKSize.avatarMedium)
        .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.medium))
        .overlay {
          if let photo = recipe.photos.first,
             let image = photo.image() {
            image
              .resizable()
              .scaledToFill()
          } else {
            Image(systemName: "fork.knife")
              .foregroundStyle(Color.TKFontGray)
              .font(.TKBody1)
          }
        }
        .clipped()
      
      VStack(alignment: .leading, spacing: .xs) {
        Text(recipe.title)
          .font(.TKBody1)
          .fontWeight(.medium)
          .lineLimit(2)
        
        Text(recipe.author ?? "Unknown")
          .font(.TKBody2)
          .foregroundStyle(Color.TKFontDefaultSub)
          .lineLimit(1)
      }
      
      Spacer()
    }
    .frame(width: TKSize.cardWidthLarge)
    .padding(.large)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.large))
    .tkShadowLight()
  }
}

struct FeaturedCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      recipeImage
      recipeInfo
    }
    .frame(width: TKSize.cardWidthXL)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.xlarge))
    .tkShadowHeavy()
  }
  
  @ViewBuilder
  private var recipeImage: some View {
    Rectangle()
      .fill(Color.TKBackgroundLightGray)
      .frame(height: TKSize.cardHeightLarge)
      .overlay {
        if let photo = recipe.photos.first,
           let image = photo.image() {
          image
            .resizable()
            .scaledToFill()
        } else {
          Image(systemName: "fork.knife")
            .foregroundStyle(Color.TKFontGray)
            .font(.TKDisplay)
        }
      }
      .overlay(alignment: .topTrailing) {
        if recipe.likeCount > 100 {
          Text("TRENDING")
            .font(.TKBody2).fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, .medium)
            .padding(.vertical, .xs)
            .background(Color.TKOrange)
            .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.small))
            .padding(.medium)
        }
      }
      .clipped()
  }
  
  @ViewBuilder
  private var recipeInfo: some View {
    VStack(alignment: .leading, spacing: .medium) {
      Text(recipe.title)
        .font(.TKTitle)
        .fontWeight(.bold)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      if let description = recipe.recipeDescription {
        Text(description)
          .font(.TKBody2)
          .foregroundStyle(Color.TKFontDefaultSub)
          .lineLimit(3)
          .multilineTextAlignment(.leading)
      }
      
      HStack {
        HStack(spacing: .xs) {
          Image(systemName: SFSymbols.heart_fill)
            .foregroundStyle(Color.TKRed)
          Text("\(recipe.likeCount)")
            .font(.TKBody2)
            .fontWeight(.medium)
        }
        
        Spacer()
        
        if let score = recipe.experimentScore {
          HStack(spacing: .xs) {
            Text(String(format: "%.1f", score))
              .font(.TKBody1)
              .fontWeight(.bold)
              .foregroundStyle(Color.TKGreen)
            Text("score")
              .font(.TKBody2)
              .foregroundStyle(Color.TKFontDefaultSub)
          }
        }
      }
    }
    .padding(.xl)
  }
}

struct MinimalCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: .small) {
      Text(recipe.title)
        .font(.TKBody1)
        .fontWeight(.medium)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      Text(recipe.author ?? "Unknown")
        .font(.TKBody2)
        .foregroundStyle(Color.TKFontDefaultSub)
    }
    .frame(width: TKSize.cardWidthSmall)
    .padding(.large)
    .background(Color.TKBackgroundLightGray)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.medium))
  }
}

// MARK: - Color Extension for Hex Support

extension Color {
  init?(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      return nil
    }
    
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

#Preview {
  let sampleCarousel = CarouselData(
    title: "Top Recipes This Week",
    subtitle: "Trending in the community",
    cardStyle: "featured",
    recipes: TestExamples.makeRecipes()
  )
  
  RecipeCarousel(carouselData: sampleCarousel)
}