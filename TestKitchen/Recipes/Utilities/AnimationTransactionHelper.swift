//
//  AnimationTransactionHelper.swift
//  TestKitchen
//
//  Created by Derek Vallar on 4/29/25.
//

import SwiftUI

struct AnimationTransactionHelper {
  @MainActor
  static func withoutAnimations_new(
    perform job: @MainActor @escaping () -> Void
  ) {
    var noAnimationTransaction = Transaction()
    noAnimationTransaction.disablesAnimations = true

    Task {
      try await Task.sleep(for: .defaultAnimation())
      withTransaction(noAnimationTransaction, job)
    }
  }

  @MainActor
  static func slowlyAnimate(_ job: @MainActor @escaping () -> Void
  ) {
    
  }
}

private extension Duration {
  static func defaultAnimation() -> Self {
    .milliseconds(CATransaction.animationDurationMs())
  }
}

private extension CATransaction {
  static func animationDurationMs() -> UInt {
    UInt(animationDuration() * 1000)
  }
}
