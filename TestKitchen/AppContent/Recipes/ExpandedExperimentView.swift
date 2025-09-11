//
//  ExpandedExperimentView.swift
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

