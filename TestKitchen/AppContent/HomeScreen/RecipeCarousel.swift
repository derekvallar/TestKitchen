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
    VStack(alignment: .leading, spacing: 12) {
      carouselHeader
      
      if carouselData.recipes.isEmpty {
        emptyStateView
      } else {
        carouselScrollView
      }
    }
    .padding(.vertical, 8)
    .background(backgroundColor)
  }
  
  @ViewBuilder
  private var carouselHeader: some View {
    VStack(alignment: .leading, spacing: 4) {
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
    .padding(.horizontal, .TKPagePadding)
  }
  
  @ViewBuilder
  private var carouselScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: 16) {
        ForEach(carouselData.recipes, id: \.self) { recipe in
          carouselCard(for: recipe)
            .onTapGesture {
              navigationManager.path.append(Destination.recipeDetails(recipe: recipe))
            }
        }
      }
      .padding(.horizontal, .TKPagePadding)
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
    VStack(spacing: 8) {
      Image(systemName: "fork.knife.circle")
        .font(.system(size: 32))
        .foregroundStyle(Color.TKFontGray)
      Text("No recipes found")
        .font(.TKBody2)
        .foregroundStyle(Color.TKFontGray)
    }
    .frame(height: 120)
    .frame(maxWidth: .infinity)
  }
}

// MARK: - Carousel Card Styles

struct StandardCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      recipeImage
      recipeInfo
    }
    .frame(width: 180)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
  }
  
  @ViewBuilder
  private var recipeImage: some View {
    Rectangle()
      .fill(Color.TKBackgroundLightGray)
      .frame(height: 120)
      .overlay {
        if let photo = recipe.photos.first,
           let image = photo.image() {
          image
            .resizable()
            .scaledToFill()
        } else {
          Image(systemName: "fork.knife")
            .foregroundStyle(Color.TKFontGray)
            .font(.system(size: 24))
        }
      }
      .clipped()
  }
  
  @ViewBuilder
  private var recipeInfo: some View {
    VStack(alignment: .leading, spacing: 4) {
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
          .font(.system(size: 12))
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
    .padding(.horizontal, 12)
    .padding(.bottom, 12)
  }
}

struct CompactCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    HStack(spacing: 12) {
      Rectangle()
        .fill(Color.TKBackgroundLightGray)
        .frame(width: 60, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
          if let photo = recipe.photos.first,
             let image = photo.image() {
            image
              .resizable()
              .scaledToFill()
          } else {
            Image(systemName: "fork.knife")
              .foregroundStyle(Color.TKFontGray)
              .font(.system(size: 16))
          }
        }
        .clipped()
      
      VStack(alignment: .leading, spacing: 4) {
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
    .frame(width: 220)
    .padding(12)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
  }
}

struct FeaturedCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      recipeImage
      recipeInfo
    }
    .frame(width: 240)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
  }
  
  @ViewBuilder
  private var recipeImage: some View {
    Rectangle()
      .fill(Color.TKBackgroundLightGray)
      .frame(height: 160)
      .overlay {
        if let photo = recipe.photos.first,
           let image = photo.image() {
          image
            .resizable()
            .scaledToFill()
        } else {
          Image(systemName: "fork.knife")
            .foregroundStyle(Color.TKFontGray)
            .font(.system(size: 32))
        }
      }
      .overlay(alignment: .topTrailing) {
        if recipe.likeCount > 100 {
          Text("TRENDING")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.TKOrange)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding(8)
        }
      }
      .clipped()
  }
  
  @ViewBuilder
  private var recipeInfo: some View {
    VStack(alignment: .leading, spacing: 8) {
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
        HStack(spacing: 4) {
          Image(systemName: SFSymbols.heart_fill)
            .foregroundStyle(Color.TKRed)
          Text("\(recipe.likeCount)")
            .font(.TKBody2)
            .fontWeight(.medium)
        }
        
        Spacer()
        
        if let score = recipe.experimentScore {
          HStack(spacing: 4) {
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
    .padding(16)
  }
}

struct MinimalCarouselCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(recipe.title)
        .font(.TKBody1)
        .fontWeight(.medium)
        .lineLimit(2)
        .multilineTextAlignment(.leading)
      
      Text(recipe.author ?? "Unknown")
        .font(.TKBody2)
        .foregroundStyle(Color.TKFontDefaultSub)
    }
    .frame(width: 140)
    .padding(12)
    .background(Color.TKBackgroundLightGray)
    .clipShape(RoundedRectangle(cornerRadius: 8))
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