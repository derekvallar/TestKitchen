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
  @Environment(\.screenSize) var screenSize

  enum Field: Hashable {
    case title
    case preparationStep
  }

  let imageUploadList =  ImageUploadList()

  @FocusState private var focusedField: Field?
  @State var showSaveAlert: Bool = false

  var pendingRecipe: Recipe? {
    return makeRecipe()
  }

  init(recipe: Recipe?) {

  }

  @State private var title: String = ""
  @State private var author: String = ""
  @State private var prepTime: String = ""
  @State private var cookTime: String = ""
  @State private var totalTime: String = ""

  @State private var description: String = ""
  @State private var ingredients: String = ""
  @State private var preparationSteps: [String] = [""]
  @State private var numberOfPrepSteps = 1

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        let imageSize = ImageUploadList.calculateImageSize(from: screenSize.width - 2 * .TKPagePadding)
        imageUploadList
          .frame(minHeight: imageSize)
        recipeTitleView
        authorView
        HStack(alignment: .top) {
          prepTimeView
          cookTimeView
        }
        totalTimeView
        descriptionView
        ingredientsView
        preparationStepsView
      }
    }
    .padding(.all, 20)
    .scrollIndicators(.hidden)
    .scrollClipDisabled(true)
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
          saveRecipe()
        }
      }
    }
    .alert("Please enter a recipe title", isPresented: $showSaveAlert) {
      Button("Okay!", role: .cancel) {
        showSaveAlert = false
      }
    }
    .onAppear {
      focusedField = .title
    }
  }

  @ViewBuilder
  var recipeTitleView: some View {
    HStack(alignment: .top) {
      Text("Recipe Title")
        .TKFontBody1()
        .bold()
      TextField(
        "Fish n' Chips",
        text: $title,
        axis: .vertical
      )
      .TKFontBody1()
      .focused($focusedField, equals: .title)
    }
  }

  @ViewBuilder
  var authorView: some View {
    HStack(alignment: .top) {

      Text("Author")
        .TKFontBody1()
        .bold()
      TextField(
        "Julia Child",
        text: $author,
        axis: .vertical
      )
      .font(.TKBody1)
    }
  }

  @ViewBuilder
  var prepTimeView: some View {
    Text("Prep Time")
      .TKFontBody1()
      .bold()
    TextField(
      "30 mins",
      text: $prepTime,
      axis: .vertical
    )
    .TKFontBody1()
  }

  @ViewBuilder
  var cookTimeView: some View {
    Text("Cook Time")
      .TKFontBody1()
      .bold()
    TextField(
      "1 hour",
      text: $cookTime,
      axis: .vertical
    )
    .TKFontBody1()
  }

  @ViewBuilder
  var totalTimeView: some View {
    Text("Total Time")
      .TKFontBody1()
      .bold()
    TextField(
      "1 1/2 hours",
      text: $totalTime,
      axis: .vertical
    )
    .TKFontBody1()
  }


  @ViewBuilder
  var descriptionView: some View {
    Text("Description")
      .TKFontBody1()
      .bold()
    TextEditor(text: $description)
      .frame(minHeight: 58)
      .defaultTextBoxStyle(
        for: $description,
        placeholder: "A simple family recipe made with a little bit of love and a lot of fish!"
      )
  }

  @ViewBuilder
  var ingredientsView: some View {
    Text("Ingredients")
      .TKFontBody1()
      .bold()
    TextEditor(text: $ingredients)
      .lineSpacing(.TKLineSpacingIngredients)
      .frame(minHeight: 68)
      .defaultTextBoxStyle(
        for: $ingredients,
        placeholder: "4 cod fillets\n1 cup all-purpose flour",
        lineSpacing: .TKLineSpacingIngredients
      )
  }

  @ViewBuilder
  var preparationStepsView: some View {
    Text("Preparation Steps")
      .TKFontBody1()
      .bold()

    ForEach(0..<numberOfPrepSteps, id: \.self) { index in
      Text("Step \(index + 1)")
        .TKFontBody1()
      TextEditor(text: $preparationSteps[index])
        .frame(minHeight: 68)
        .defaultTextBoxStyle(
          for: $preparationSteps[index],
          placeholder: "Prepare the fillets"
        )
        .focused($focusedField, equals: .preparationStep)
    }
  }

  private func makeRecipe() -> Recipe? {
    guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }

    return Recipe(
      title: title,
      author: author,
      recipeDescription: description,
      photos: [],
      prepTime: prepTime,
      cookTime: cookTime,
      totalTime: totalTime,
      preparationSteps: preparationSteps,
      ingredients: ingredients
    )
  }

  private func saveRecipe() {
    guard let recipe = pendingRecipe else {
      showSaveAlert = true
      return
    }

    navigationManager.popLast()
    // Animate the recipe inserting in the homeview after a brief delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      modelContext.insert(recipe)
      try? modelContext.save()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
      navigationManager.path.append(recipe)
    }
  }
}

extension View {
  func defaultTextBoxStyle(
    for textBinding: Binding<String>,
    placeholder: String? = nil,
    lineSpacing: CGFloat = 0
  ) -> some View {

    return self
      .font(.TKBody1)
      .foregroundStyle(Color.TKFontDefault)
      .scrollContentBackground(.hidden)
//      .background(Color.TKBackgroundLightGray)
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .padding(.horizontal, -5)
      .padding(.vertical, -8)
      .overlay(alignment: .topLeading) {
        if textBinding.wrappedValue == "",
           let placeholder = placeholder {
          HStack(spacing: 0) {
            Text(placeholder)
              .TKFontPlaceholder()
              .lineSpacing(lineSpacing)
              .lineLimit(2)
              .frame(alignment: .topLeading)
            Spacer()
          }
        }
      }
  }
}

struct RecipeCreatorView_Preview: PreviewProvider {
  static var previews: some View {
    RecipeCreatorView(recipe: nil)
  }
}
