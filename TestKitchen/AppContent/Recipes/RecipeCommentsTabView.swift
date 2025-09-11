//
//  RecipeCommentsTabView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/10/25.
//

import SwiftUI

struct RecipeCommentsTabView: View {
  static let navigationTag: String = "recipeCommentsTab"

  var comments: [Comment]
  @Binding private var currentTab: RecipeView.Tab?
  @State private var searchText = ""
  @State private var searchIsActive = false

  init(comments: [Comment], currentTab: Binding<RecipeView.Tab?>) {
    self.comments = comments
    self._currentTab = currentTab
  }

  var body: some View {
    VStack {
      HStack {
        Spacer()
        if currentTab == .comments {
          Text("")
            .searchable(text: $searchText, isPresented: $searchIsActive, placement: .toolbar)
        }
        Text("Sort by: ")
        Text("Most Popular")
        Image(systemName: SFSymbols.chevron_right)
      }
      ScrollView {
        VStack(spacing: 16) {
          ForEach(comments, id: \.self) { comment in
            CommunityCommentView(comment: comment)
          }
        }
      }
    }
    .navigationTitle("Comments")
  }
}

#Preview {
  @Previewable @State var tab: RecipeView.Tab? = .comments

  RecipeCommentsTabView(comments: TestExamples.makeCommunityComments(), currentTab: $tab)
}
