//
//  SearchService.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/11/25.
//

import SwiftUI

// MARK: - Search Models

struct SearchQuery: Codable {
  let query: String
  let filters: SearchFilters?
  let limit: Int
  let offset: Int
  
  init(
    query: String,
    filters: SearchFilters? = nil,
    limit: Int = 20,
    offset: Int = 0
  ) {
    self.query = query
    self.filters = filters
    self.limit = limit
    self.offset = offset
  }
}

struct SearchFilters: Codable {
  let cuisineType: String?
  let prepTimeMax: Int?
  let difficulty: String?
  let hasImages: Bool?
  
  init(
    cuisineType: String? = nil,
    prepTimeMax: Int? = nil,
    difficulty: String? = nil,
    hasImages: Bool? = nil
  ) {
    self.cuisineType = cuisineType
    self.prepTimeMax = prepTimeMax
    self.difficulty = difficulty
    self.hasImages = hasImages
  }
}

// MARK: - Backend Response Model

struct SearchResponse: Codable {
  let recipes: [CodableRecipe]
  let totalCount: Int
  let hasMore: Bool
  let suggestions: [String]?
}

// MARK: - Search Service

@Observable
class SearchService {
  private let session = URLSession.shared
  private let baseURL = "https://api.testkitchen.com" // Replace with your backend URL
  
  var isSearching = false
  var searchResults: [Recipe] = []
  var searchSuggestions: [String] = []
  var hasMoreResults = false
  var currentQuery = ""
  
  private var searchTask: Task<Void, Never>?
  
  func search(query: String, filters: SearchFilters? = nil) {
    guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
      clearResults()
      return
    }
    
    // Cancel previous search
    searchTask?.cancel()
    
    currentQuery = query
    isSearching = true
    
    searchTask = Task {
      await performSearch(query: query, filters: filters)
    }
  }
  
  func loadMoreResults() {
    guard !isSearching, hasMoreResults, !currentQuery.isEmpty else { return }
    
    searchTask = Task {
      await performSearch(
        query: currentQuery,
        offset: searchResults.count,
        append: true
      )
    }
  }
  
  func clearResults() {
    searchTask?.cancel()
    searchResults = []
    searchSuggestions = []
    hasMoreResults = false
    currentQuery = ""
    isSearching = false
  }
  
  @MainActor
  private func performSearch(
    query: String,
    filters: SearchFilters? = nil,
    offset: Int = 0,
    append: Bool = false
  ) async {
    let searchQuery = SearchQuery(
      query: query,
      filters: filters,
      offset: offset
    )
    
    do {
      let response = try await makeSearchRequest(searchQuery)
      
      if append {
        searchResults.append(contentsOf: response.recipes.map { Recipe.fromCodable($0) })
      } else {
        searchResults = response.recipes.map { Recipe.fromCodable($0) }
      }
      
      hasMoreResults = response.hasMore
      searchSuggestions = response.suggestions ?? []
      isSearching = false
      
    } catch {
      print("Search error: \(error)")
      isSearching = false
      
      // For now, return mock data when backend is not available
      if !append {
        searchResults = mockSearchResults(for: query)
        hasMoreResults = false
        searchSuggestions = mockSuggestions(for: query)
      }
    }
  }
  
  private func makeSearchRequest(_ searchQuery: SearchQuery) async throws -> SearchResponse {
    guard let url = URL(string: "\(baseURL)/search") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(searchQuery)
    
    let (data, _) = try await session.data(for: request)
    return try JSONDecoder().decode(SearchResponse.self, from: data)
  }
  
  // MARK: - Mock Data (for when backend is not available)
  
  private func mockSearchResults(for query: String) -> [Recipe] {
    let allRecipes = TestExamples.makeRecipes()
    
    return allRecipes.filter { recipe in
      recipe.title.localizedCaseInsensitiveContains(query) ||
      recipe.author?.localizedCaseInsensitiveContains(query) == true ||
      recipe.recipeDescription?.localizedCaseInsensitiveContains(query) == true
    }
  }
  
  private func mockSuggestions(for query: String) -> [String] {
    let commonTerms = ["soup", "pasta", "chicken", "vegetarian", "dessert", "salad", "pizza"]
    return commonTerms.filter { $0.hasPrefix(query.lowercased()) }
  }
}

// MARK: - Search Bar Component

struct RecipeSearchBar: View {
  @Binding var searchText: String
  @Binding var isSearching: Bool
  let onSearchSubmit: (String) -> Void
  let suggestions: [String]
  
  @FocusState private var isTextFieldFocused: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Image(systemName: "magnifyingglass")
          .foregroundStyle(Color.TKFontGray)
        
        TextField("Search recipes...", text: $searchText)
          .focused($isTextFieldFocused)
          .onSubmit {
            onSearchSubmit(searchText)
            isTextFieldFocused = false
          }
          .onChange(of: searchText) { _, newValue in
            if newValue.isEmpty {
              onSearchSubmit("")
            }
          }
        
        if isSearching {
          ProgressView()
            .scaleEffect(0.8)
        } else if !searchText.isEmpty {
          Button {
            searchText = ""
            onSearchSubmit("")
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(Color.TKFontGray)
          }
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(Color.TKBackgroundLightGray)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      
      if isTextFieldFocused && !suggestions.isEmpty {
        suggestionsList
      }
    }
  }
  
  @ViewBuilder
  private var suggestionsList: some View {
    VStack(alignment: .leading, spacing: 0) {
      ForEach(suggestions.prefix(5), id: \.self) { suggestion in
        Button {
          searchText = suggestion
          onSearchSubmit(suggestion)
          isTextFieldFocused = false
        } label: {
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundStyle(Color.TKFontGray)
              .font(.system(size: 14))
            Text(suggestion)
              .font(.TKBody2)
              .foregroundStyle(Color.TKFontDefault)
            Spacer()
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 12)
        }
        .background(Color.white)
        
        if suggestion != suggestions.prefix(5).last {
          Divider()
            .padding(.leading, 16)
        }
      }
    }
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    .padding(.top, 4)
  }
}

#Preview {
  @Previewable @State var searchText = ""
  @Previewable @State var isSearching = false
  
  RecipeSearchBar(
    searchText: $searchText,
    isSearching: $isSearching,
    onSearchSubmit: { _ in },
    suggestions: ["soup", "salad", "pasta"]
  )
  .padding()
}
