//
//  File.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/19/25.
//

import SwiftUI

struct CTAButton: View {

  let icon: String
  let text: String
  let color: Color

  @State var isActive: Bool = false
  let tapGesture: () -> Void

  var body: some View {
    VStack(spacing: Spacing.small) {
      Image(systemName: icon)
        .foregroundStyle(isActive ? Color.white : Color.gray)
      Text(text)
        .font(.TKBody1)
        .foregroundStyle(isActive ? Color.white : Color.TKFontDefault)
    }
    .frame(maxWidth: .infinity)
    .padding(Spacing.medium)
    .background {
      RoundedRectangle(cornerRadius: 8)
        .fill(isActive ? color : Color.TKBackgroundDefault)
        .shadow(radius: 3, x: 2, y: 2)
    }
    .onTapGesture {
      isActive.toggle()
      tapGesture()
    }
  }

}
