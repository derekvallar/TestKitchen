//
//  Comment.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/10/25.
//

import Foundation

struct Comment: Codable, Hashable {
  let id: String
  let commentText: String
  let user: User
  let upvoteCount: Int
  let downvoteCount: Int
  let dateCreated: Date
  let recipeId: String?

  init(
    commentText: String,
    user: User,
    upvoteCount: Int = 0,
    downvoteCount: Int = 0,
    recipeId: String? = nil
  ) {
    self.id = UUID().uuidString
    self.commentText = commentText
    self.user = user
    self.upvoteCount = upvoteCount
    self.downvoteCount = downvoteCount
    self.dateCreated = Date()
    self.recipeId = recipeId
  }
}
