//
//  User.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/10/25.
//

import Foundation

struct User: Codable, Hashable {
  let userID: String
  let username: String
  let profileImage: Data?
  let bio: String?
  let joinDate: Date

  init(
    userID: String,
    username: String,
    profileImage: Data? = nil,
    bio: String? = nil
  ) {
    self.userID = userID
    self.username = username
    self.profileImage = profileImage
    self.bio = bio
    self.joinDate = Date()
  }
}
