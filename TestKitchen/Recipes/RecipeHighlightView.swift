//
//  RecipeHighlightView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI


struct User: Codable, Hashable {
  let userID: String
  let username: String
  let profileImage: Data
}

struct Comment: Codable, Hashable {
  var id = UUID()
  let commentText: String
  let user: User
  let upvoteCount: Int
  var dateCreated: Date? = Date()
}

struct RecipeHighlightView: View, NavigatableView {
  static let navigationTag: String = "recipeHighlightView"

  let text: String
  let comments: [Comment]

  init(text: String, comments: [Comment]) {
    self.text = text
    self.comments = comments
  }
  
  var body: some View {
    List {
      Text("Recipe Highlight")
        .TKFontBody1()
        .bold()
        .listRowSeparator(.hidden)

      ForEach(comments, id: \.self) { comment in
        CommunityCommentView(
          comment: comment
        )
        .padding([.top, .bottom], 2)
      }
      .listRowSeparator(.hidden)
    }
    .listStyle(.plain)

//    ScrollView {
//      VStack(alignment: .leading, spacing: Spacing.large) {
//        Text(text)
//          .TKTitle()
//        ForEach(comments, id: \.self) { comment in
//          CommunityCommentView(
//            comment: comment
//          )
//          .padding([.top, .bottom], 2)
//        }
//      }
//      .padding()
//      .background(Color.TKBackgroundDefault)
//      
//    }
//    .scrollIndicators(.hidden)
    .background(Color.TKBackgroundDefault)
  }
}

struct RecipeHighlightView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    let comments = TestExamples.makeCommunityComments()
    RecipeHighlightView(text: recipe.preparationSteps[0].text, comments: comments)
  }
}
