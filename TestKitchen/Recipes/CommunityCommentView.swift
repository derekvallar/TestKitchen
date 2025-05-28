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
    HStack(alignment: .top, spacing: Spacing.medium) {
//      Image(uiImage: UIImage(data: comment.user.profileImage))
      Image(systemName: "person.circle")
      VStack(alignment: .leading, spacing: Spacing.medium) {
        HStack(spacing: Spacing.small) {
          Text(comment.user.username)
            .font(Font.system(size: 12))
            .bold()
            .foregroundStyle(Color.TKFontDefault)
          Text("2h")
            .font(Font.system(size: 12))
            .foregroundStyle(Color.gray)
        }
        Text(comment.commentText)
          .TKFontBody1()
        HStack(spacing: Spacing.large) {
          HStack(spacing: Spacing.small) {
            Image(systemName: SFSymbols.heart_fill)
              .foregroundStyle(Color.TKRed)
            Text("103")
              .font(Font.system(size: 12))
              .foregroundStyle(Color.TKFontDefault)
          }
          Text("See \(comment.user.username)'s Version")
            .font(Font.system(size: 12))
            .foregroundStyle(Color.white)
            .lineLimit(1)
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background {
              RoundedRectangle(cornerRadius: 3)
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
