//
//  SocialSectionView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/9/25.
//

import SwiftUI
import Charts

struct SocialSectionView: View {

  var recipe: Recipe

  var body: some View {
    VStack(alignment: .center, spacing: 12) {
      HStack(spacing: 20) {
        ExperimentScoreView
        StitchView
//        Spacer()
      }
//      .padding(8)
      RecipeChangeNoteView
    }
//    .padding(10)
    .background(Color.TKBackgroundDefault)
  }

  @ViewBuilder
  private var ExperimentScoreView: some View {
    HStack {
      Text("7.2")
        .font(.TKDisplay)
        .fontWeight(.semibold)
        .foregroundStyle(Color.TKGreen)
        .padding(6)
        .overlay {
          Circle()
            .stroke(Color.gray, lineWidth: 1)
        }
      VStack(alignment: .leading) {
        Text("Status:")
          .TKFontBody2()
          .fontWeight(.semibold)
        Text("Exceptional Recipe")
          .TKFontBody2Gray()
          .italic()
      }
    }
    .frame(width: 120, height: 60)
  }

  @ViewBuilder
  private var StitchView: some View {
    HStack(alignment: .top, spacing: 20) {
      ZStack {
        Rectangle()
          .frame(width: 20, height: 30)
          .foregroundStyle(Color.TKYellow)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .shadow(radius: 2)
          .rotationEffect(.degrees(10), anchor: .bottom)
          .offset(CGSize(width: 4, height: -8))
        Rectangle()
          .frame(width: 20, height: 30)
          .foregroundStyle(Color.TKYellow)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .shadow(radius: 2)
          .rotationEffect(.degrees(-10), anchor: .bottom)
          .offset(CGSize(width: -4, height: -4))
        Rectangle()
          .frame(width: 20, height: 30)
          .foregroundStyle(Color.TKYellow)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .shadow(radius: 2)
          .offset(CGSize(width: 0, height: 2))

      }
      .offset(CGSize(width: 0, height: 3))

      HStack {
        Text("See")
          .TKFontBody2Gray()
        + Text(" 12 ")
          .font(.TKBody2)
          .fontWeight(.semibold)
        + Text("\nTakes")
          .TKFontBody2Gray()
        Image(systemName: SFSymbols.chevron_right_circle)
          .font(.system(size: 16))
          .foregroundStyle(Color.TKFontGray)
      }

    }
    .padding(.horizontal, 6)

  }


  /**
   Unnecessary? They could already put the updates in the description
   */
  @ViewBuilder
  private var RecipeChangeNoteView: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("Changes from the previous recipe:")
          .TKFontBody1()
          .fontWeight(.semibold)
                .foregroundStyle(Color.TKFontDefault)
        Image(systemName: SFSymbols.chevron_right_circle)
          .foregroundStyle(Color.TKFontGray)
      }
      Text("The potatoes were a good choice to add but we wanted to give them a little more flavor. Maillard browning the potatoes beforehand allows a little bit extra flavor to the edges.")
        .TKFontBody1()
        .foregroundStyle(Color.TKFontDefault)
    }
//    .padding(12)
//    .background {
//      RoundedRectangle(cornerRadius: 8)
//        .fill(Color.TKBackgroundDefault)
//        .strokeBorder(lineWidth: 2)
//        .foregroundStyle(Color.TKOrange)
//    }
  }
}

#Preview {
  SocialSectionView(recipe: TestExamples.makeRecipes().first!)
}
