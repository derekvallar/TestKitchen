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
    HStack(alignment: .top, spacing: 20) {
      VStack(alignment: .leading, spacing: .TKSpacingDefault) {
        Text(comment.commentText)
          .TKFontBody1()
        Text(comment.userName)
          .TKFontBody2Gray()
      }
      .layoutPriority(1)
      Spacer()
      Text("\(comment.upvoteCount)")
        .TKFontBody1Inverse()
        .frame(width: 35, height: 35)
        .background(Color(red: 0.6, green: 0.6, blue: 1))
        .clipShape(Circle())
    }
//    .padding(.all, .TKSpacingCard)
//    .background(Color.TKBackgroundDefault)
//    .cornerRadius(6)
//    .shadow(radius: 5)
  }
}

struct CommunityComment_Preview: PreviewProvider {
  static var previews: some View {
    let comment = TestExamples.makeCommunityComments().first!
    CommunityCommentView(comment: comment)
  }
}
