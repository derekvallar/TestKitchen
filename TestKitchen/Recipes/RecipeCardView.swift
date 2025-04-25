//
//  RecipeCardView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

struct RecipeCardView: View {
  
  var image: Image?
  var title: String
  var author: String
  var prepTime: Int
  var totalTime: Int
  
  init(recipe: Recipe) {
    self.title = recipe.title
    self.author = recipe.author
    self.prepTime = recipe.prepTime
    self.totalTime = recipe.totalTime
  }
  
  var body: some View {
    HStack(alignment: .top, spacing: .TKSpacingCard) {
      Text("Image go here")
        .font(.headline)
        .lineLimit(2)
        .frame(width: 100, height: 100)
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 8))
      VStack(alignment: .leading, spacing: .TKSpacingDefault) {
        Text(title)
          .TKTitle()
          .lineLimit(2)
        Text(author)
          .TKFontBody1()
          .lineLimit(1)
        HStack(spacing: .TKSpacingDefault) {
          (Text("Prep: ")
            .TKFontBody2Gray()
          + Text("\(prepTime) min"))
            .TKFontBody2()
          Text("|")
            .TKFontBody2Gray()
          Text("Total: ")
            .TKFontBody2Gray()
          + Text("\(totalTime) min")
            .TKFontBody2()
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
  }
}

struct RecipeCardView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    RecipeCardView(recipe: recipe)
  }
}
