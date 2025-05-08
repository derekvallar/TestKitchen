//
//  Design.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

extension Color {
  public static var TKBackgroundDefault = Color(red: 0.97, green: 0.97, blue: 0.95)
  public static var TKFontDefault = Color(red: 0.2, green: 0.2, blue: 0.2)
  public static var TKFontDefaultSub = Color(red: 0.5, green: 0.5, blue: 0.5)
  public static var TKFontGray = Color(red: 0.7, green: 0.7, blue: 0.7)
  public static var TKBackgroundLightGray = Color(red: 0.94, green: 0.94, blue: 0.94)
}

/**
  Font Hierarchy
 1. Display
 2. Headline
 3. Title
 4. Body
 */
extension Font {
  public static var TKDisplay = Font.custom("NewYork-Regular", size: 24)
  public static var TKTitle = Font.custom("ScotchModern", size: 18)
  public static var TKBody1 = Font.custom("NewYork-Regular", size: 16)
  public static var TKBody2 = Font.custom("NewYork-Regular", size: 14)
}

extension UIFont {
  public static var TKDisplay = UIFont(name: "ScotchModern", size: 30)!
  public static var TKDisplay2 = UIFont(name: "NewYork-Regular", size: 30)!

}

extension Text {
  public func TKDisplay() -> Text {
    return self
      .font(.TKDisplay)
      .foregroundStyle(Color.TKFontDefault)
  }
    
  public func TKTitle() -> Text {
      return self
      .font(.TKTitle)
      .foregroundStyle(Color.TKFontDefault)
    }
    
  public func TKFontBody1() -> Text {
    return self
      .font(.TKBody1)
      .foregroundStyle(Color.TKFontDefault)
  }

  public func TKFontBody1BoldGray() -> Text {
    return self
      .font(.TKBody1)
      .bold()
      .foregroundStyle(Color.gray)
  }

  public func TKFontBody1Gray() -> Text {
    return self
      .font(.TKBody1)
      .foregroundStyle(Color.gray)
  }

  public func TKFontPlaceholder() -> Text {
    return self
      .font(.TKBody1)
      .foregroundStyle(Color.TKFontGray)
  }

  public func TKFontBody1Inverse() -> Text {
    return self
      .font(.TKBody1)
      .foregroundStyle(Color.white)
  }
  
  public func TKFontBody1Italics() -> Text {
    return self
      .font(.TKBody1)
      .italic()
      .foregroundStyle(Color.TKFontDefault)
  }

  public func TKFontBody2() -> Text {
    return self
      .font(.TKBody2)
      .foregroundStyle(Color.TKFontDefault)
  }
  
  public func TKFontBody2Gray() -> Text {
    return self
      .font(.TKBody2)
      .foregroundStyle(Color.gray)
  }
}

extension TextField {
  public func TKFontBody1() -> some View {
    return self
      .font(.TKBody1)
      .foregroundStyle(Color.TKFontDefault)
  }
}

extension CGFloat {
  public static var TKPagePadding: CGFloat = 16
  public static var TKSpacingDefault: CGFloat = 4
  public static var TKSpacingCard: CGFloat = 8
  public static var TKLineSpacingIngredients: CGFloat = 10
}
