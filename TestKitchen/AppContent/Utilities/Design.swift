//
//  Design.swift
//  TestKitchen
//
//  Created by Derek Vallar on 3/5/25.
//

import SwiftUI

extension Color {
  public static var TKBackgroundDefault = Color(red: 0.98, green: 0.98, blue: 0.96)
//  public static var TKBackgroundDefault = Color(red: 0.97, green: 0.97, blue: 0.95)
  public static var TKFontDefault = Color(red: 0.15, green: 0.15, blue: 0.15)
  public static var TKFontDefaultSub = Color(red: 0.5, green: 0.5, blue: 0.5)
  public static var TKFontGray = Color(red: 0.7, green: 0.7, blue: 0.7)
  public static var TKBackgroundLightGray = Color(red: 0.94, green: 0.94, blue: 0.94)

//  public static var TKYellow = Color(red: 0.9803921569, green: 0.9411764706, blue: 0.5882352941)
  public static var TKYellow = Color(red: 0.9725490196, green: 0.9215686275, blue: 0.4666666667)
//  public static var TKOrange = Color(red: 1.0, green: 0.5764705882, blue: 0.3098039216)
  public static var TKOrange = Color(red: 1.0, green: 0.5058823529, blue: 0.2)
  public static var TKLightOrange = Color(red: 1.0, green: 0.7529411765, blue: 0.4039215686)
  public static var TKGreen = Color(red: 0.1490196078, green: 0.662745098, blue: 0.4235294118)
  public static var TKBlue = Color(red: 0.0, green: 0.5333333333, blue: 1.0)
  public static var TKDarkBlue = Color(red: 0.03921568627, green: 0.06666666667, blue: 0.1568627451)
  public static var TKRed = Color(red: 0.9411764706, green: 0.3098039216, blue: 0.3098039216)
}

/**
  Font Hierarchy
 1. Display
 2. Headline
 3. Title
 4. Body
 */
extension Font {
  public static var TKDisplay = Font.custom("NewYork-Regular", size: 20)
//  public static var TKDisplayItalic = Font.custom("NewYork-Italic", size: 20)
  public static var TKTitle = Font.custom("NewYork-Regular", size: 16)
  public static var TKBody1 = Font.custom("NewYork-Regular", size: 14)
  public static var TKBody2 = Font.custom("NewYork-Regular", size: 12)
}

extension UIFont {
  public static var TKDisplay = UIFont(name: "NewYork-Regular", size: 30)!
  public static var TKDisplay2 = UIFont(name: "NewYork-Regular", size: 30)!

}

extension Text {
  public func TKDisplay() -> Text {
    return self
      .font(.TKDisplay)
      .fontWeight(.semibold)
      .foregroundStyle(Color.TKFontDefault)
  }

  public func TKDisplayItalic() -> Text {
    return self
      .font(.TKDisplay)
      .italic()
      .fontWeight(.semibold)

      .foregroundStyle(Color.TKFontDefault)
  }

  public func TKTitle() -> Text {
      return self
      .font(.TKTitle)
      .fontWeight(.semibold)
      .foregroundStyle(Color.TKFontDefault)
    }

  public func TKTitleItalic() -> Text {
      return self
      .font(.TKTitle)
      .italic()
      .fontWeight(.semibold)
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

// MARK: - Design System

struct TKSpacing {
  public static let xxsmall: CGFloat = 2
  public static let xsmall: CGFloat = 4
  public static let small: CGFloat = 6
  public static let medium: CGFloat = 8
  public static let large: CGFloat = 12
  public static let xlarge: CGFloat = 16
  public static let xxlarge: CGFloat = 20
  public static let xxxlarge: CGFloat = 24
  public static let xxxxlarge: CGFloat = 32
  
  // Common page-level spacing
  public static let pagePadding: CGFloat = 16
  public static let sectionSpacing: CGFloat = 24
  public static let cardSpacing: CGFloat = 12
  public static let lineSpacing: CGFloat = 10
}

struct TKCornerRadius {
  public static let xsmall: CGFloat = 2
  public static let small: CGFloat = 4
  public static let medium: CGFloat = 8
  public static let large: CGFloat = 12
  public static let xlarge: CGFloat = 16
}

extension CGFloat {
  // Spacing
  public static var xxs: CGFloat { TKSpacing.xxsmall }
  public static var xs: CGFloat { TKSpacing.xsmall }
  public static var small: CGFloat { TKSpacing.small }
  public static var medium: CGFloat { TKSpacing.medium }
  public static var large: CGFloat { TKSpacing.large }
  public static var xl: CGFloat { TKSpacing.xlarge }
  public static var xxl: CGFloat { TKSpacing.xxlarge }
  public static var xxxl: CGFloat { TKSpacing.xxxlarge }
  public static var xxxxl: CGFloat { TKSpacing.xxxxlarge }

  // Common spacing
  public static var pagePadding: CGFloat { TKSpacing.pagePadding }
  public static var sectionSpacing: CGFloat { TKSpacing.sectionSpacing }
  public static var cardSpacing: CGFloat { TKSpacing.cardSpacing }
  public static var lineSpacing: CGFloat { TKSpacing.lineSpacing }
}

struct TKSize {
  public static let iconSmall: CGFloat = 16
  public static let iconMedium: CGFloat = 20
  public static let iconLarge: CGFloat = 24
  public static let iconXL: CGFloat = 32

  public static let avatarSmall: CGFloat = 40
  public static let avatarMedium: CGFloat = 60
  public static let avatarLarge: CGFloat = 80

  public static let cardHeight: CGFloat = 120
  public static let cardHeightLarge: CGFloat = 160
  public static let cardHeightXL: CGFloat = 200

  public static let cardWidthSmall: CGFloat = 140
  public static let cardWidthMedium: CGFloat = 180
  public static let cardWidthLarge: CGFloat = 220
  public static let cardWidthXL: CGFloat = 240
}

struct TKShadow {
  static let light = (radius: CGFloat(2), x: CGFloat(0), y: CGFloat(1), opacity: 0.1)
  static let medium = (radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2), opacity: 0.15)
  static let heavy = (radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4), opacity: 0.2)
}

extension View {
  func tkShadowLight() -> some View {
    return self
      .shadow(color: .black.opacity(TKShadow.light.opacity), 
              radius: TKShadow.light.radius, 
              x: TKShadow.light.x, 
              y: TKShadow.light.y)
  }
  
  func tkShadowMedium() -> some View {
    return self
      .shadow(color: .black.opacity(TKShadow.medium.opacity), 
              radius: TKShadow.medium.radius, 
              x: TKShadow.medium.x, 
              y: TKShadow.medium.y)
  }
  
  func tkShadowHeavy() -> some View {
    return self
      .shadow(color: .black.opacity(TKShadow.heavy.opacity), 
              radius: TKShadow.heavy.radius, 
              x: TKShadow.heavy.x, 
              y: TKShadow.heavy.y)
  }
}
