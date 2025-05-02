//
//  CardScrollViewClaude.swift
//  TestKitchen
//
//  Created by Derek Vallar on 5/2/25.
//

import SwiftUI

struct CardScrollViewClaude: View {
  @State private var recipes: [Recipe]
  @State private var currentIndex = 0
  @State private var offset = CGSize.zero
  @State private var selectedCard: Recipe? = nil
  @State private var isCardExpanded = false
  @State private var expandedCardFrame: CGRect = .zero

  init(recipes: [Recipe]) {
    _recipes = State(initialValue: recipes)
  }

  var body: some View {
    ZStack {
//      ForEach(0..<(min(recipes.count, 3))) { test in
//        print("test: \(test)")
//      }
//      ForEach(0..<(min(recipes.count, 3))) { index in
//        print("test: \(index)")
//        let reversedIndex = min(recipes.count, 3) - 1 - index
//      }
      let minRecipeCount: Int = min(recipes.count, 3)

      ForEach(0..<minRecipeCount, id: \.self) { index in
        Text("count: \(index)")
      }
      ForEach(0..<minRecipeCount, id: \.self) { index in
//        print("test: \(index)")
        let reversedIndex = minRecipeCount - 1 - index
        let cardIndex = (currentIndex + reversedIndex) % recipes.count
        let card = recipes[cardIndex]

        Text("count: \(reversedIndex)")

//        RecipeCardView(
//          recipe: card,
//          index: reversedIndex == 0 ? currentIndex % 2 : 0,
//          onTap: {
//            if reversedIndex == 0 && !isCardExpanded {
//              selectedCard = card
//              expandedCardFrame = expandedCardFrame
//              withAnimation(.spring()) {
//                isCardExpanded = true
//              }
//            }
//          }
//        )
        RecipeCardView(recipe: card)
        .frame(width: calculateWidth(for: reversedIndex), height: calculateHeight(for: reversedIndex))
        .offset(
          x: calculateHorizontalOffset(for: reversedIndex),
          y: calculateVerticalOffset(for: reversedIndex)
        )
        .opacity(calculateOpacity(for: reversedIndex))
        .zIndex(Double(100 - reversedIndex))
        .offset(x: reversedIndex == 0 ? offset.width : 0)
        .gesture(
          reversedIndex == 0 && !isCardExpanded
          ? DragGesture()
            .onChanged { gesture in
              offset = gesture.translation
            }
            .onEnded { gesture in
              withAnimation(.spring()) {
                if gesture.translation.width < -50 {
                  // Swipe left - next card
                  currentIndex = (currentIndex + 1) % recipes.count
                } else if gesture.translation.width > 50 {
                  // Swipe right - previous card
                  currentIndex = (currentIndex - 1 + recipes.count) % recipes.count
                }
                offset = .zero
              }
            }
          : nil
        )
      }

      // Progress indicators at the bottom
      if !isCardExpanded {
        HStack(spacing: 8) {
          ForEach(0..<recipes.count) { i in
            Circle()
              .fill(i == currentIndex / 2 ? Color.orange : Color.gray.opacity(0.4))
              .frame(width: 8, height: 8)
          }
        }
        .padding(.bottom, 16)
        .offset(y: 280)
      }

      // Full screen detail view when card is expanded
      if isCardExpanded, let selectedCard = selectedCard {
        Color.black.opacity(0.001)
          .edgesIgnoringSafeArea(.all)
          .onTapGesture {
            withAnimation(.spring()) {
              isCardExpanded = false
            }
          }

        RecipeView(recipe: selectedCard)
          .transition(.opacity)
          .zIndex(1000)
        //                    .modifier(CardExpandTransition(isPresented: isCardExpanded, originalFrame: expandedCardFrame))
          .animation(.spring(), value: isCardExpanded)
      }
    }
    .frame(width: UIScreen.main.bounds.width)
  }

  // Helper functions to calculate card positions
  private func calculateWidth(for index: Int) -> CGFloat {
    let baseWidth: CGFloat = 380
    return baseWidth - CGFloat(index * 10)
  }

  private func calculateHeight(for index: Int) -> CGFloat {
    let baseHeight: CGFloat = 500
    return baseHeight - CGFloat(index * 10)
  }

  private func calculateHorizontalOffset(for index: Int) -> CGFloat {
    return CGFloat(index * 10)
  }

  private func calculateVerticalOffset(for index: Int) -> CGFloat {
    return CGFloat(index * 6)
  }

  private func calculateOpacity(for index: Int) -> Double {
    let opacities: [Double] = [1.0, 0.7, 0.4]
    return opacities[index]
  }
}
