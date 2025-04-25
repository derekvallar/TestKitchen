//
//  RecipeCreatorView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 4/22/25.
//

import SwiftUI

struct RecipeCreatorView: View {

  enum Field: Hashable {
    case preparationStep
  }
  @FocusState private var focusedField: Field?

  var recipe: Recipe?

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
        NavigationLink(
          destination: {
            RecipeCreatorView()
          }, label: {
            Text("Save")
          }
        )
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

//struct ContentView: View {
//  @State var text = "Type here"
//  var body: some View {
//    TextEditor(text: self.$text)
//
//    // make the color of the placeholder gray
//      .foregroundColor(self.text == "Type here" ? .gray : .primary)
//      .onAppear {
//        // remove the placeholder text when keyboard appears
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
//          withAnimation {                        if self.text == "Type here" {
//            self.text = ""
//          }
//          }
//        }
//        // put back the placeholder text if the user dismisses the keyboard without adding any text
//        NotificationCenter.default
//          .addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
//            withAnimation {                        if self.text == "" {
//              self.text = "Type here"
//            }
//            }
//          }
//      }
//  }
//}
