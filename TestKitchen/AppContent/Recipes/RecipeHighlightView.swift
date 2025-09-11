//
//  RecipeHighlightView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

struct RecipeHighlightView: View, NavigatableView {
  static let navigationTag: String = "recipeHighlightView"

  let highlightId: String
  let text: String
  let recipeId: String?
  let comments: [Comment] = TestExamples.makeCommunityComments()

  @State private var hasScrolled: Bool = false

  var body: some View {
    VStack(spacing: 0) {
      Text("Recipe Highlight")
        .TKFontBody1()
        .bold()
        .padding(.top, .xl)
        .padding(.bottom, .large)
      Rectangle()
        .foregroundStyle(hasScrolled ? Color.TKFontGray : Color.white)
        .frame(height: 0.25)

      List {
        Section(
          content: {
            ForEach(comments, id: \.self) { comment in
              CommunityCommentView(
                comment: comment
              )
              .padding([.top, .bottom], 2)
            }
            .listRowSeparator(.hidden)
          },
          header: {

        })
      }
      .listStyle(.plain)
      .background(Color.TKBackgroundDefault)
      .onScrollGeometryChange(for: Bool.self) { proxy in
        return proxy.contentOffset.y > 0.0
      } action: { _, hasScrolled in
        self.hasScrolled = hasScrolled
      }
    }
  }
}

struct RecipeHighlightView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
//    let comments = TestExamples.makeCommunityComments()
    RecipeHighlightView(
      highlightId: "test123",
      text: recipe.preparationSteps[0].text,
      recipeId: recipe.recipeId
    )
  }
}
