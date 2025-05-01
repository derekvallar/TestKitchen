//
//  RecipeCreatorView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 4/22/25.
//

import SwiftUI

struct RecipeCreatorView: View, NavigatableView {
  static var navigationTag = "recipeCreatorView"

  @Environment(\.modelContext) private var modelContext
  @Environment(\.navigationManager) var navigationManager: NavigationManager

  enum Field: Hashable {
    case preparationStep
  }
  @FocusState private var focusedField: Field?

  var pendingRecipe: Recipe? {
    return makeRecipe()
  }

  @State var showSaveAlert: Bool = false

  @State private var title: String = ""
  @State private var description: String = "A simple family recipe made with a little bit of love and a lot of fish!"
  @State private var ingredients: String = "4 cod fillets\n1 cup all-purpose flour"
  @State private var preparationSteps: [String] = [""]
  @State private var numberOfPrepSteps = 1

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 4) {
        RecipeTitleView
        DescriptionView
        IngredientsView
        PreparationStepsView
      }
    }
    .padding()
    .scrollIndicators(.hidden)
    .toolbar {
      ToolbarItemGroup(placement: .keyboard) {
        if focusedField == .preparationStep {
          if numberOfPrepSteps > 1 {
            Button("Remove section") {
              print("Removed section")
              preparationSteps.removeLast()
              numberOfPrepSteps = preparationSteps.count
            }
          }
          Button("Add section") {
            print("Added section")
            preparationSteps.append("")
            numberOfPrepSteps = preparationSteps.count
          }
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button("Save") {
          guard let recipe = pendingRecipe else {
            showSaveAlert = true
            return
          }

          navigationManager.popLast()
          // Animate the recipe inserting in the homeview after a brief delay
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.smooth) {
              modelContext.insert(recipe)
            }
            try? modelContext.save()
          }

          DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            navigationManager.path.append(recipe)
          }
        }
      }
    }
    .alert("Please enter a recipe title", isPresented: $showSaveAlert) {
      Button("Okay!", role: .cancel) {
        showSaveAlert = false
      }
    }
  }

  @ViewBuilder
  var RecipeTitleView: some View {
    Text("Recipe Title")
      .TKFontBody1()
      .bold()
    TextField(
      "Fish n' Chips",
      text: $title,
      axis: .vertical
    )
      .font(.TKDisplay)
    Spacer().frame(height: 16)
  }

  @ViewBuilder
  var DescriptionView: some View {
    Text("Description")
      .TKFontBody1()
      .bold()
    TextEditor(text: $description)
      .frame(minHeight: 54)
      .DefaultTextBoxStyle()
    Spacer().frame(height: 16)
  }

  @ViewBuilder
  var IngredientsView: some View {
    Text("Ingredients")
      .TKFontBody1()
      .bold()
    TextEditor(text: $ingredients)
      .lineSpacing(10)
      .frame(minHeight: 65)
      .DefaultTextBoxStyle()
    Spacer().frame(height: 16)
  }

  @ViewBuilder
  var PreparationStepsView: some View {
    Text("Preparation Steps")
      .TKFontBody1()
      .bold()
    Spacer().frame(height: 8)

    ForEach(0..<numberOfPrepSteps, id: \.self) { index in
      Text("Step \(index + 1)")
        .TKFontBody1()
      TextEditor(text: $preparationSteps[index])
        .lineSpacing(10)
        .frame(minHeight: 70)
        .DefaultTextBoxStyle()
        .focused($focusedField, equals: .preparationStep)
    }
  }

  private func makeRecipe() -> Recipe? {
    print("nav name: \(navigationManager.testID)")

    guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }

    return Recipe(
      title: title,
      author: "",
      recipeDescription: description,
      photos: [],
      prepTime: 0,
      cookTime: 0,
      preparationSteps: preparationSteps,
      ingredients: ingredients
    )
  }

  private func saveRecipe(_ recipe: Recipe) {
    
  }
}

extension View {
  func DefaultTextBoxStyle() -> some View {
    return self
      .font(.TKBody1)
      .scrollContentBackground(.hidden)
      .background(Color.TKBackgroundLightGray)
//      .padding(.horizontal, -5)
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}

struct RecipeCreatorView_Preview: PreviewProvider {
  static var previews: some View {
    RecipeCreatorView()
  }
}
