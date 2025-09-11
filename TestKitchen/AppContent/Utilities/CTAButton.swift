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
    VStack(spacing: .small) {
      Image(systemName: icon)
        .foregroundStyle(isActive ? Color.white : Color.TKFontGray)
      Text(text)
        .font(.TKBody1)
        .foregroundStyle(isActive ? Color.white : Color.TKFontDefault)
    }
    .frame(maxWidth: .infinity)
    .padding(.medium)
    .background {
      RoundedRectangle(cornerRadius: TKCornerRadius.medium)
        .fill(isActive ? color : Color.TKBackgroundDefault)
        .tkShadowMedium()
    }
    .onTapGesture {
      isActive.toggle()
      tapGesture()
    }
  }

}
