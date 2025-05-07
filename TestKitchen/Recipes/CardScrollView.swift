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

  @State private var scrollPosition = ScrollPosition()
  @State private var scrollOffset = CGPoint.zero
  @State private var middleCardOffset = CGFloat.zero
  @State private var currentCardIndex: Int = 0
  @State private var engine: CHHapticEngine?

  static let leadingTrailingCardSpace: CGFloat = 120
  static let topBottomCardSpace: CGFloat = 400
  static let cardsPerSide: Int = 2

  var body: some View {
    ScrollView(.horizontal) {
      HStack(spacing: -1 * getCardWidth() + CardScrollView.getCardPeekWidth()) {
        // Add two empty cards so the first card can be centered
        ForEach(0..<CardScrollView.cardsPerSide, id: \.self) { _ in
          emptyCard()
        }
        ForEach(Array(zip(recipes.indices, recipes)), id: \.0) { index, recipe in
          let zIndex = Double(100 - abs(currentCardIndex - index))
          NavigationLink(
            destination: {
              RecipeView(recipe: recipe)
            },
            label: {
              RecipeCardView(recipe: recipe)
                .frame(
                  width: getCardWidth(),
                  height: getCardDynamicHeight(for: index)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 10)
            }
          )
          .offset(
            x: getXOffset(for: index),
            y: 0
          )
          .zIndex(zIndex)
          .buttonStyle(NoHighlightLinkStyle())
        }
        ForEach(0..<CardScrollView.cardsPerSide + 1, id: \.self) { _ in
          emptyCard()
        }
      }
    }
    .scrollPosition($scrollPosition)
    .onAppear() {
      scrollPosition.scrollTo(x: CardScrollView.getCardPeekWidth()/2)
    }
    .onScrollGeometryChange(for: CGPoint.self) { proxy in
      proxy.contentOffset
    } action: { oldOffset, offset in
      scrollOffset = offset
      middleCardOffset = getMiddleCardOffset(from: offset)
    }
    .onScrollGeometryChange(for: Int.self) { proxy in
      return getCardIndex(from: proxy.contentOffset)
    } action: { oldIndex, index in
      currentCardIndex = index
    }
    .scrollTargetBehavior(CardScrollTargetBehavior(recipes: recipes))
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

    let totalContentWidth = CardScrollView.getCardPeekWidth() * CGFloat(recipes.count)
    print("Point: \(point.x)")

    let index = Int(floor(point.x / totalContentWidth * CGFloat(recipes.count)))
    return min(max(index, 0), recipes.count - 1)
  }

  func getMiddleCardOffset(from scrollOffset: CGPoint) -> CGFloat {
/**
    (-10)       (0)         (10)          (20)        (30)
    |------------|------------|------------|------------|
    <------(First card)------->
 
*/

    let middleOffset = -1 * ((CardScrollView.getCardPeekWidth() * CGFloat(currentCardIndex)) - scrollOffset.x)
    return middleOffset
  }

  func getCardWidth() -> CGFloat {
    return screenSize.width - CardScrollView.leadingTrailingCardSpace
  }

  func getCardHeight() -> CGFloat {
    return screenSize.height - CardScrollView.topBottomCardSpace
  }

  func getXOffset(for index: Int) -> CGFloat {
    if index == currentCardIndex {
//      print("Index: \(index), offset: \(middleCardOffset)")
      return middleCardOffset
    } else if index < currentCardIndex  {
      return CardScrollView.getCardPeekWidth()
    }
    return 0
  }

  func getCardDynamicHeight(for index: Int) -> CGFloat {
    let cardHeight = getCardHeight()
    var dynamicCardHeight = cardHeight
    let peekWidth = CardScrollView.getCardPeekWidth()
    let correctedOffset = middleCardOffset + (peekWidth / 2)

    if index == currentCardIndex {
      dynamicCardHeight += peekWidth * 2
    } else if index == currentCardIndex - 1 && index >= 0 {
      dynamicCardHeight += peekWidth * 3 - correctedOffset * 2
    } else if index == currentCardIndex + 1 {
      dynamicCardHeight += correctedOffset * 2 - peekWidth
    }
    return dynamicCardHeight
  }

  static func getCardPeekWidth() -> CGFloat {
    // Take the total card space on the sides,
    // divide it by 2 to get the space on one side,
    // then divide it by the number of cards that can appear on a side
    // and one empty space.
    return CardScrollView.leadingTrailingCardSpace
      / 2
      / CGFloat(CardScrollView.cardsPerSide)
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

struct CardScrollTargetBehavior: ScrollTargetBehavior {
  var recipes: [Recipe]

  init(recipes: [Recipe]) {
    self.recipes = recipes
  }

  func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
    // Align to every mid point between each card, or every half a peek width.
    var targetedIndex = floor(target.rect.origin.x / CardScrollView.getCardPeekWidth())
    targetedIndex = min(targetedIndex, CGFloat(recipes.count - 1))
    target.rect.origin.x = (targetedIndex + 1) * CardScrollView.getCardPeekWidth() - CardScrollView.getCardPeekWidth() / 2
  }
}

#Preview {
  let previewContainer = PreviewContainer<Recipe>()
  previewContainer.addExamples(TestExamples.makeRecipes())
  return CardScrollView()
    .modelContainer(previewContainer.modelContainer)
}



