//
//  HomeView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/1/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
  @Environment(\.navigationManager) private var navigationManager
  @State private var searchService = SearchService()
  @State private var searchText = ""
  @State private var homePageData = HomePageData()
  @State private var isLoading = true

  var body: some View {
    @Bindable var navigationManager = navigationManager
    NavigationStack(path: $navigationManager.path) {
      ScrollView {
        VStack(spacing: 0) {
          searchSection
          
          if searchService.searchResults.isEmpty && searchText.isEmpty {
            discoveryContent
          } else {
            searchResultsContent
          }
        }
      }
      .background(Color.TKBackgroundDefault)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("TestKitchen")
            .font(.TKTitle)
            .fontWeight(.bold)
            .foregroundStyle(Color.TKFontDefault)
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Button("My Recipes", systemImage: "book.closed") {
            // TODO: Navigate to MyRecipesView
            // This could be a tab or modal presentation
          }
        }
      }
      .navigationDestination(for: Destination.self) { destination in
        switch destination {
        case .recipeCreation(let recipe):
          RecipeCreatorView(recipe: recipe)
        case .recipeDetails(let recipe):
          RecipeView(recipe: recipe)
        }
      }
    }
    .onAppear {
      loadHomePageData()
    }
  }
  
  @ViewBuilder
  private var searchSection: some View {
    VStack(spacing: .xl) {
      RecipeSearchBar(
        searchText: $searchText,
        isSearching: $searchService.isSearching,
        onSearchSubmit: { query in
          searchService.search(query: query)
        },
        suggestions: searchService.searchSuggestions
      )
    }
    .padding(.horizontal, .pagePadding)
    .padding(.vertical, .xl)
  }
  
  @ViewBuilder
  private var discoveryContent: some View {
    LazyVStack(spacing: .xxxl) {
      // Banners
      if let banners = homePageData.banners, !banners.isEmpty {
        ForEach(banners) { banner in
          BannerView(banner: banner)
        }
      }
      
      // Carousels
      ForEach(homePageData.carousels) { carousel in
        RecipeCarousel(carouselData: carousel)
      }
      
      // Featured Recipes Section
      if let featuredRecipes = homePageData.featuredRecipes, !featuredRecipes.isEmpty {
        featuredRecipesSection(recipes: featuredRecipes)
      }
    }
    .padding(.bottom, .xxxxl)
  }
  
  @ViewBuilder
  private var searchResultsContent: some View {
    VStack(alignment: .leading, spacing: .xl) {
      HStack {
        Text("Search Results")
          .font(.TKTitle)
          .fontWeight(.bold)
        
        Spacer()
        
        if !searchText.isEmpty {
          Text("\(searchService.searchResults.count) results")
            .font(.TKBody2)
            .foregroundStyle(Color.TKFontDefaultSub)
        }
      }
      .padding(.horizontal, .pagePadding)
      
      LazyVStack(spacing: .xl) {
        ForEach(searchService.searchResults, id: \.self) { recipe in
          SearchResultCard(recipe: recipe)
            .onTapGesture {
              navigationManager.path.append(Destination.recipeDetails(recipe: recipe))
            }
        }
        
        if searchService.hasMoreResults {
          Button("Load More") {
            searchService.loadMoreResults()
          }
          .font(.TKBody1)
          .foregroundStyle(Color.TKBlue)
          .padding(.vertical, .xl)
        }
      }
      .padding(.horizontal, .pagePadding)
    }
  }
  
  @ViewBuilder
  private func featuredRecipesSection(recipes: [Recipe]) -> some View {
    VStack(alignment: .leading, spacing: .xl) {
      Text("Featured Today")
        .font(.TKTitle)
        .fontWeight(.bold)
        .foregroundStyle(Color.TKFontDefault)
        .padding(.horizontal, .pagePadding)
      
      LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
      ], spacing: .xl) {
        ForEach(recipes.prefix(4), id: \.self) { recipe in
          FeaturedRecipeCard(recipe: recipe)
            .onTapGesture {
              navigationManager.path.append(Destination.recipeDetails(recipe: recipe))
            }
        }
      }
      .padding(.horizontal, .pagePadding)
    }
  }
  
  private func loadHomePageData() {
    // TODO: Replace with actual API call
    // For now, using mock data
    Task {
      await loadMockHomePageData()
    }
  }
  
  @MainActor
  private func loadMockHomePageData() async {
    // Simulate network delay
    try? await Task.sleep(nanoseconds: 500_000_000)
    
    // Simulate backend API response
    let mockCodableRecipes = TestExamples.makeRecipes().map { $0.toCodableRecipe() }
    
    // Create mock backend response
    let mockResponse = HomePageDataResponse(
      carousels: [
        CarouselDataResponse(
          id: UUID().uuidString,
          title: "Top Recipes This Week",
          subtitle: "Trending in the community",
          cardStyle: "featured",
          backgroundColor: nil,
          recipes: mockCodableRecipes
        ),
        CarouselDataResponse(
          id: UUID().uuidString,
          title: "Experimental Recipes",
          subtitle: "Help improve these recipes",
          cardStyle: "standard",
          backgroundColor: "#F0F0F0",
          recipes: mockCodableRecipes
        ),
        CarouselDataResponse(
          id: UUID().uuidString,
          title: "Quick & Easy",
          subtitle: "Under 30 minutes",
          cardStyle: "compact",
          backgroundColor: nil,
          recipes: mockCodableRecipes
        )
      ],
      featuredRecipes: mockCodableRecipes,
      banners: [
        BannerData(
          title: "Welcome to TestKitchen!",
          message: "Discover and share amazing recipes with the community",
          backgroundColor: "#FF8133"
        )
      ]
    )
    
    // Convert backend response to frontend models
    homePageData = HomePageData(from: mockResponse)
    
    isLoading = false
  }
}

// MARK: - Supporting Views

struct BannerView: View {
  let banner: BannerData
  
  var body: some View {
    VStack(alignment: .leading, spacing: .medium) {
      Text(banner.title)
        .font(.TKTitle)
        .fontWeight(.bold)
        .foregroundStyle(Color(hex: banner.textColor) ?? .white)
      
      Text(banner.message)
        .font(.TKBody1)
        .foregroundStyle(Color(hex: banner.textColor) ?? .white)
        .multilineTextAlignment(.leading)
      
      if let actionText = banner.actionText {
        Button(actionText) {
          // Handle banner action
        }
        .font(.TKBody1)
        .fontWeight(.semibold)
        .foregroundStyle(Color(hex: banner.textColor) ?? .white)
        .padding(.top, 4)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.all, .pagePadding)
    .background(Color(hex: banner.backgroundColor) ?? Color.TKOrange)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.large))
    .padding(.horizontal, .pagePadding)
  }
}

struct SearchResultCard: View {
  let recipe: Recipe
  
  var body: some View {
    HStack(spacing: .large) {
      Rectangle()
        .fill(Color.TKBackgroundLightGray)
        .frame(width: TKSize.avatarLarge, height: TKSize.avatarLarge)
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
          .fontWeight(.semibold)
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        if let author = recipe.author {
          Text("by \(author)")
            .font(.TKBody2)
            .foregroundStyle(Color.TKFontDefaultSub)
        }
        
        HStack {
          HStack(spacing: 4) {
            Image(systemName: SFSymbols.heart_fill)
              .foregroundStyle(Color.TKRed)
              .font(.system(size: 12))
            Text("\(recipe.likeCount)")
              .font(.TKBody2)
              .foregroundStyle(Color.TKFontDefaultSub)
          }
          
          if let score = recipe.experimentScore {
            HStack(spacing: 4) {
              Text(String(format: "%.1f", score))
                .font(.TKBody2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.TKGreen)
              Text("score")
                .font(.TKBody2)
                .foregroundStyle(Color.TKFontDefaultSub)
            }
          }
        }
      }
      
      Spacer()
    }
    .padding(.large)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.large))
    .tkShadowLight()
  }
}

struct FeaturedRecipeCard: View {
  let recipe: Recipe
  
  var body: some View {
    VStack(alignment: .leading, spacing: .medium) {
      Rectangle()
        .fill(Color.TKBackgroundLightGray)
        .aspectRatio(4/3, contentMode: .fit)
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
        .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.medium))
      
      VStack(alignment: .leading, spacing: .xs) {
        Text(recipe.title)
          .font(.TKBody1)
          .fontWeight(.semibold)
          .lineLimit(2)
          .multilineTextAlignment(.leading)
        
        if let author = recipe.author {
          Text(author)
            .font(.TKBody2)
            .foregroundStyle(Color.TKFontDefaultSub)
            .lineLimit(1)
        }
      }
    }
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: TKCornerRadius.large))
    .tkShadowLight()
  }
}

#Preview {
  HomeView()
}
