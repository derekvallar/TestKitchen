//
//  SocialSectionView.swift
//  TestKitchen
//
//  Created by Derek Vallar on 9/9/25.
//

import SwiftUI
import Charts

struct ChartData: Hashable {
  enum DataType: String, Plottable {
    case low = "Needs Experimentation"
    case medium = "Solid Meal"
    case high = "Exceptional Taste"
  }

  let type: DataType
  let amount: Int
}

struct ExperimentStatusView: View {

  let testChartData = [
    ChartData(type: .low, amount: 20),
    ChartData(type: .medium, amount: 72),
    ChartData(type: .high, amount: 41),
  ]

  var body: some View {
    VStack {
      HStack(spacing: 12) {
        Image(systemName: SFSymbols.test_tube)
          .foregroundStyle(Color.gray)
        CircleIcon(
          systemName: SFSymbols.test_tube,
          color: .blue,
          isHighlighted: false
        )
        CircleIcon(
          systemName: SFSymbols.fork_knife,
          color: .TKGreen,
          isHighlighted: false
        )

        CircleIcon(
          systemName: SFSymbols.birthday_cake,
          color: .orange,
          isHighlighted: true
        )
      }

      Chart {
        ForEach(testChartData, id: \.self) { data in
          BarMark(
            x: .value("X", data.amount),
            y: .value("Y", data.type),
            height: 12
          )
          .barMarkStyling(for: data.type)
        }
      }
      .chartXAxis {
        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
      }
      .chartYAxis {
        AxisMarks(preset: .aligned, stroke: StrokeStyle(lineWidth: 0))
      }
      .frame(width: 200, height: 100)
    }
  }
}

extension BarMark {
  func barMarkStyling(for style: ChartData.DataType) -> some ChartContent {
    let color: Color
    switch style {
    case .low:
      color = Color.TKDarkBlue
    case .medium:
      color = Color.green
    case .high:
      color = Color.TKOrange
    }

    return self
      .clipShape(RoundedRectangle(cornerRadius: 6))
      .foregroundStyle(color)
  }
}




struct SocialSectionView: View {

  var recipe: Recipe

  var body: some View {
    VStack {
      HStack(spacing: 20) {
        ExperimentStatusView()
        LikeView
        BookmarkView
        Spacer()
      }

      HStack(spacing: 20) {
        ExperimentScoreView
        StitchView
        Spacer()
      }
      .padding(8)
    }
    .padding(10)
    .background(Color.TKBackgroundLightGray)
  }

  @ViewBuilder
  private var ExperimentScoreView: some View {
    HStack {
      Text("7.2")
        .font(.TKDisplay)
        .fontWeight(.semibold)
        .foregroundStyle(Color.TKGreen)
        .padding(6)
        .overlay {
          Circle()
            .stroke(Color.gray, lineWidth: 1)
        }
      VStack(alignment: .leading) {
        Text("Status:")
          .font(.system(size: 12))
          .fontWeight(.semibold)
        Text("Exceptional Recipe")
          .TKFontBody2Gray()
          .italic()
      }
    }
    .frame(width: 120, height: 60)
  }

  @ViewBuilder
  private var LikeView: some View {
    HStack(spacing: 6) {
      Image(systemName: SFSymbols.heart_fill)
        .foregroundStyle(Color.TKRed)
      Text("1.2k")
        .TKFontBody1()
    }
  }

  @ViewBuilder
  private var BookmarkView: some View {
    HStack(spacing: 6) {
      Image(systemName: SFSymbols.bookmark_fill)
        .foregroundStyle(Color.TKBlue)
      Text("1.2k")
        .TKFontBody1()
    }
  }


  @ViewBuilder
  private var StitchView: some View {
    HStack(alignment: .top, spacing: 20) {
      ZStack {
        Rectangle()
          .frame(width: 20, height: 30)
          .foregroundStyle(Color.TKYellow)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .shadow(radius: 2)
          .rotationEffect(.degrees(10), anchor: .bottom)
          .offset(CGSize(width: 4, height: -8))
        Rectangle()
          .frame(width: 20, height: 30)
          .foregroundStyle(Color.TKYellow)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .shadow(radius: 2)
          .rotationEffect(.degrees(-10), anchor: .bottom)
          .offset(CGSize(width: -4, height: -4))
        Rectangle()
          .frame(width: 20, height: 30)
          .foregroundStyle(Color.TKYellow)
          .clipShape(RoundedRectangle(cornerRadius: 2))
          .shadow(radius: 2)
          .offset(CGSize(width: 0, height: 2))

      }
      .offset(CGSize(width: 0, height: 3))

      HStack {
        Text("See")
          .TKFontBody2Gray()
        + Text(" 12 ")
          .font(.TKBody2)
          .fontWeight(.semibold)
        + Text("\nvariations")
          .TKFontBody2Gray()
        Image(systemName: SFSymbols.chevron_right_circle)
          .font(.system(size: 16))
          .foregroundStyle(Color.TKFontGray)
      }

    }
    .padding(.horizontal, 6)

  }

  @ViewBuilder
  private var TestCount: some View {
    HStack {
      Text("21.1k tests")
        .TKFontBody2()

      if let totalTime = recipe.totalTime {
        Text("|")
          .TKFontBody2Gray()
        HStack(spacing: 4) {
          Image(systemName: SFSymbols.timer)
            .foregroundStyle(Color.TKFontGray)
            .font(.system(size: 12))
          Text(totalTime)
            .TKFontBody2()
        }
      }
      Spacer()
    }
  }
}

#Preview {
  SocialSectionView(recipe: TestExamples.makeRecipes().first!)
}
