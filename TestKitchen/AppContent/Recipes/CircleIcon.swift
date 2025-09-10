//
//  CircleIcon.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/2/25.
//

import SwiftUI

struct CircleIcon: View {

  let systemName: String
  let color: Color
  var isHighlighted: Bool

  var body: some View {
    Image(systemName: systemName)
      .font(.system(size: 10))
      .foregroundStyle(Color.white)
      .padding(4)
      .background {
        Circle()
          .foregroundStyle(isHighlighted ? color : Color.TKFontGray)
          .frame(width: 20, height: 20)
      }
  }
}
