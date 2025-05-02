//
//  NavigationLinkUtil.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/2/25.
//

import SwiftUI

struct NoHighlightLinkStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
  }
}
