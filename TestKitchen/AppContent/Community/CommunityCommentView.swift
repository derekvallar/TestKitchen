//
//  CommunityCommentView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI


struct CommunityCommentView: View {
  let comment: Comment

  var body: some View {
    HStack(alignment: .top, spacing: .medium) {
//      Image(uiImage: UIImage(data: comment.user.profileImage))
      Image(systemName: "person.circle")
      VStack(alignment: .leading, spacing: .medium) {
        HStack(spacing: .small) {
          Text(comment.user.username)
            .font(.TKBody2)
            .bold()
            .foregroundStyle(Color.TKFontDefault)
          Text("2h")
            .font(.TKBody2)
            .foregroundStyle(Color.gray)
        }
        Text(comment.commentText)
          .TKFontBody1()
        HStack(spacing: .large) {
          HStack(spacing: .small) {
            Image(systemName: SFSymbols.heart_fill)
              .foregroundStyle(Color.TKRed)
            Text("103")
              .font(.TKBody2)
              .foregroundStyle(Color.TKFontDefault)
          }
          Text("See \(comment.user.username)'s Version")
            .font(.TKBody2)
            .foregroundStyle(Color.white)
            .lineLimit(1)
            .padding(.vertical, .xxs)
            .padding(.horizontal, .small)
            .background {
              RoundedRectangle(cornerRadius: TKCornerRadius.xsmall)
                .fill(Color.TKOrange)
            }
        }
      }
      Spacer()
    }
  }
}

struct CommunityComment_Preview: PreviewProvider {
  static var previews: some View {
    let comment = TestExamples.makeCommunityComments().first!
    CommunityCommentView(comment: comment)
  }
}
