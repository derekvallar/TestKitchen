//
//  NavigationManager.swift
//  TestKitchen
//
//  Created by Derek Vallar on 4/29/25.
//

import SwiftUI

@Observable
final class NavigationManager {

  var path = NavigationPath()
  var testID: String

  init(testID: String = "test") {
    self.testID = testID
  }

  func popToRoot() {
    print("popToRoot, count: \(path.count)")
    path.removeLast(path.count)
  }

  func popLast() {
    print("popLast, count: \(path.count)")
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func popLast(_ count: Int) {
    print("popLast(\(count)), count: \(path.count)")
    guard count > 0 else { return }
    path.removeLast(count)
  }

  func goToSettings() {
    //        ...
  }
}

extension EnvironmentValues {
  @Entry var navigationManager: NavigationManager = NavigationManager(testID: "anotherTest")
}

//struct Destination: Hashable {
//  let destination: String
//  let recipe: Recipe?
//
//
//}

enum Destination: Hashable {
  case recipeCreation(recipe: Recipe?)
  case recipeDetails(recipe: Recipe)
  case recipeHighlightView(recipe: Recipe, comment: Comment?)
}
