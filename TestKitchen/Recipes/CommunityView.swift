//
//  CommunityView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

struct Comment: Codable, Identifiable {
  var id = UUID()
  let commentText: String
  let userName: String
  let upvoteCount: Int
  
  init(
    commentText: String,
    userName: String,
    upvoteCount: Int
  ) {
    self.commentText = commentText
    self.userName = userName
    self.upvoteCount = upvoteCount
  }
}

struct CommunityView: View {
  let text: String
  let comments: [Comment]

  init(text: String, comments: [Comment]) {
    self.text = text
    self.comments = comments
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text(text)
          .TKTitle()
        ForEach(comments) { comment in
          CommunityCommentView(
            comment: comment
          )
          .padding([.top, .bottom], 2)
        }
      }
      .padding()
      .background(Color.TKBackgroundDefault)
      
    }
    .scrollIndicators(.hidden)
    .background(Color.TKBackgroundDefault)
  }
}

struct CommunityView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    let comments = TestExamples.makeCommunityComments()
    CommunityView(text: recipe.preparationSteps[0].text, comments: comments)
  }
}
