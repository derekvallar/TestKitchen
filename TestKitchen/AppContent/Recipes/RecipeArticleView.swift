//
//  RecipeArticleView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 8/27/25.
//


import SwiftUI

struct RecipeArticleView: View {

  @Environment(\.navigationManager) private var navigationManager
  let recipe: Recipe

  var body: some View {
    HStack(spacing: .TKSpacingCard) {
      Image("test_photo")
        .resizable()
        .scaledToFill()
        .frame(width: 120)
        .clipped()
      VStack(spacing: .TKSpacingDefault) {
        Title
        Author
        TestCount
        Status
        Spacer()
      }
      .padding([.leading, .trailing, .top], .TKSpacingCard)
      Spacer()

    }
    .frame(
      height: 120
    )
    .background(Color.TKBackgroundDefault)
//    .padding(.all, 10)
//    .border(Color.TKBackgroundDefault, width: 10)
    .clipShape(RoundedRectangle(cornerRadius: 2))
    .TKShadow()
//    .padding(.all, 10)
    .onTapGesture {
      navigationManager.path.append(
        Destination.recipeDetails(recipe: recipe)
      )
    }
  }

  @ViewBuilder
  private var Title: some View {
    Text("Norwegian fish soup yummy yummy in my tummy tummy I like it alot")
      .TKTitleItalic()
      .lineLimit(2)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  @ViewBuilder
  private var Author: some View {
    if let author = recipe.author,
       !author.isEmpty {
      Text(author)
        .TKFontBody2Gray()
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  @ViewBuilder
  private var Status: some View {
    HStack(spacing: 12) {
      CircleIcon(
        systemName: SFSymbols.test_tube,
        color: .blue,
        isHighlighted: false
      )
      CircleIcon(
        systemName: SFSymbols.fork_knife,
        color: .TKGreen,
        isHighlighted: false
      )

      CircleIcon(
        systemName: SFSymbols.birthday_cake,
        color: .orange,
        isHighlighted: true
      )
      Spacer()
    }
  }

  @ViewBuilder
  private var TestCount: some View {
    HStack {
      Text("21.1k tests")
        .TKFontBody2()

      if let totalTime = recipe.totalTime {
        Text("|")
          .TKFontBody2Gray()
        HStack(spacing: 4) {
          Image(systemName: SFSymbols.timer)
            .foregroundStyle(Color.TKFontGray)
            .font(.system(size: 12))
          Text(totalTime)
            .TKFontBody2()
        }
      }
      Spacer()
    }
  }
}

struct RecipeArticleView_Preview: PreviewProvider {
  static var previews: some View {
    let recipe = TestExamples.makeRecipes().first!
    RecipeArticleView(recipe: recipe)
  }
}
