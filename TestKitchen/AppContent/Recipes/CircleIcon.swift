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
      .font(.TKBody2)
      .foregroundStyle(Color.white)
      .padding(.xs)
      .background {
        Circle()
          .foregroundStyle(isHighlighted ? color : Color.TKFontGray)
          .frame(width: TKSize.iconMedium, height: TKSize.iconMedium)
      }
  }
}
