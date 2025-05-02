//
//  CardScrollView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/1/25.
//

import SwiftUI
import SwiftData
import CoreHaptics


struct CardScrollView: View {
  @Environment(\.screenSize) private var screenSize

  @Query(sort: \Recipe.dateCreated, order: .reverse) var recipes: [Recipe]

  @State private var scrollOffset = CGPoint.zero
  @State private var currentCardIndex: Int = 0
  @State private var engine: CHHapticEngine?

  private let leadingTrailingCardSpace: CGFloat = 120
  private let topBottomCardSpace: CGFloat = 200
  private let cardsPerSide: Int = 3

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: -1 * getCardWidth() + getCardPeekWidth()) {
        // Add two empty cards so the first card can be centered
        ForEach(0..<cardsPerSide, id: \.self) { _ in
          emptyCard()
        }
        ForEach(Array(zip(recipes.indices, recipes)), id: \.0) { index, recipe in
          let zIndex = Double(100 - abs(currentCardIndex - index))
          let cardOffset = getMiddleCardOffset(for: index, point: scrollOffset)
          NavigationLink(
            destination: {
              RecipeView(recipe: recipe)
            },
            label: {
              RecipeView(recipe: recipe)
                .frame(
                  width: getCardWidth(),
                  height: getCardDynamicHeight(for: index, offset: cardOffset)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 10)
            }
          )
          .offset(
            x: getXOffset(for: index, offset: cardOffset),
            y: 0
          )
          .zIndex(zIndex)
          .buttonStyle(NoHighlightLinkStyle())
        }
        ForEach(0..<cardsPerSide, id: \.self) { _ in
          emptyCard()
        }
      }
    }
    .onScrollGeometryChange(for: Int.self) { proxy in
      let _ = print("Scroll offset: \(proxy.contentOffset)")
      return getCardIndex(from: proxy.contentOffset)
    } action: { oldIndex, index in
      currentCardIndex = index
//      triggerHaptic()
    }
    .onScrollGeometryChange(for: CGPoint.self) { proxy in
      proxy.contentOffset
    } action: { oldOffset, offset in
      scrollOffset = offset
    }
//    .onAppear(perform: prepareHaptics)
    .sensoryFeedback(.increase, trigger: currentCardIndex)

    .scrollIndicators(.hidden)
    .scrollClipDisabled()
    .animation(.spring, value: recipes)
    
  }

  @ViewBuilder
  func emptyCard() -> some View {
    Rectangle()
      .foregroundStyle(Color.blue)
      .frame(
        width: getCardWidth(),
        height: getCardHeight() + 20
      )
      .opacity(0.3)
  }

  func getCardIndex(from point: CGPoint) -> Int {
    // There will be a zero content width until there is at least 2 cards
    guard recipes.count > 1 else { return 0 }

    let totalContentWidth = getCardPeekWidth() * CGFloat(recipes.count - 1)
    print("Total content width: \(totalContentWidth)")
    print("Point: \(point.x)")

    let index = Int(floor(point.x / totalContentWidth * CGFloat(recipes.count)))
    
    return min(max(index, 0), recipes.count - 1)
  }

  func getMiddleCardOffset(for index: Int, point: CGPoint) -> CGFloat {
/**
    (-10)       (0)         (10)          (20)        (30)
    |------------|------------|------------|------------|

*/
    let middleOffset = -1 * ((getCardPeekWidth() * CGFloat(index)) - point.x)
    print("Middle Offset: \(middleOffset)")
    print("Card peek: \(getCardPeekWidth())")
    return middleOffset
  }

  func getCardWidth() -> CGFloat {
    return screenSize.width - leadingTrailingCardSpace
  }

  func getCardHeight() -> CGFloat {
    return screenSize.height - topBottomCardSpace
  }

  func getXOffset(for index: Int, offset: CGFloat) -> CGFloat {
    if index == currentCardIndex {
      return offset
    } else if index == currentCardIndex - 1 {
      return 0
//      return offset - getCardPeekWidth() / 2
    }
    return 0
  }

  func getCardDynamicHeight(for index: Int, offset: CGFloat) -> CGFloat {
    let cardHeight = getCardHeight()
    var dynamicCardHeight = cardHeight
    let peekWidth = getCardPeekWidth()
    let correctedOffset = offset + (peekWidth / 2)

    if index == currentCardIndex {
      dynamicCardHeight += peekWidth * 2
    } else if index == currentCardIndex - 1 && index >= 0 {
      dynamicCardHeight += max(peekWidth * 2 - correctedOffset, 0)
    } else if index == currentCardIndex + 1 {
      dynamicCardHeight += max(peekWidth + correctedOffset, 0)
    }
    return dynamicCardHeight
  }

  func getCardPeekWidth() -> CGFloat {
    // Take the total card space on the sides,
    // divide it by 2 to get the space on one side,
    // then divide it by the number of cards that can appear on a side
    // and one empty space.
    return leadingTrailingCardSpace / 2 / CGFloat(cardsPerSide)
  }
}

// MARK: Haptics
extension CardScrollView {
  func prepareHaptics() {
      guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
      do {
          engine = try CHHapticEngine()
          try engine?.start()
      } catch {
          print("There was an error creating the engine: \(error.localizedDescription)")
      }
  }

  func triggerHaptic() {
      // make sure that the device supports haptics
      guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
      var events = [CHHapticEvent]()

      // create one intense, sharp tap
      let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
      let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
      let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
      events.append(event)

      // convert those events into a pattern and play it immediately
      do {
          let pattern = try CHHapticPattern(events: events, parameters: [])
          let player = try engine?.makePlayer(with: pattern)
          try player?.start(atTime: 0)
      } catch {
          print("Failed to play pattern: \(error.localizedDescription).")
      }
  }
}

#Preview {
  let previewContainer = PreviewContainer<Recipe>()
  previewContainer.addExamples(TestExamples.makeRecipes())
  return CardScrollView()
    .modelContainer(previewContainer.modelContainer)
}



