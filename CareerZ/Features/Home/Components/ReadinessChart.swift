//
//  ReadinessChart.swift
//  CareerZ
//
//  Created by Ahmad Zaki on 21/06/26.
//

import SwiftUI
import Charts

/// Line + area chart showing readiness percentage trend across months.
struct ReadinessChart: View {

    let points: [ReadinessHistoryPoint]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Chart(points) { point in
            AreaMark(
                x: .value("Month", point.monthLabel),
                y: .value("Readiness", point.percent)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [Color.appSuccess.opacity(0.25), Color.appSuccess.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interpolationMethod(.catmullRom)

            LineMark(
                x: .value("Month", point.monthLabel),
                y: .value("Readiness", point.percent)
            )
            .foregroundStyle(Color.appSuccess)
            .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round))
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Month", point.monthLabel),
                y: .value("Readiness", point.percent)
            )
            .foregroundStyle(Color.appSuccess)
            .symbolSize(point.monthLabel == points.last?.monthLabel ? 70 : 30)
        }
        .chartYScale(domain: 0...100)
        .chartYAxis(.hidden)
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel()
                    .font(AppTypography.caption)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        .frame(height: 160)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Readiness over time chart")
        .accessibilityValue(accessibilitySummary)
        .accessibilityChartDescriptor(self)
    }

    /// Plain-language summary for VoiceOver users who can't see the
    /// chart shape — describes the trend, not just raw numbers.
    private var accessibilitySummary: String {
        guard let first = points.first, let last = points.last else { return "No data" }
        let trend = last.percent >= first.percent ? "increased" : "decreased"
        let monthsList = points.map { "\($0.monthLabel) \($0.percent) percent" }.joined(separator: ", ")
        return "Readiness \(trend) from \(first.percent) percent in \(first.monthLabel) "
            + "to \(last.percent) percent in \(last.monthLabel). Full data: \(monthsList)."
    }
}

// MARK: - AXChartDescriptorRepresentable

extension ReadinessChart: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXNumericDataAxisDescriptor(
            title: "Month",
            range: 0...Double(max(points.count - 1, 1)),
            gridlinePositions: []
        ) { value in
            let index = Int(value.rounded())
            guard points.indices.contains(index) else { return "" }
            return points[index].monthLabel
        }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Readiness",
            range: 0...100,
            gridlinePositions: []
        ) { value in "\(Int(value))%" }

        let series = AXDataSeriesDescriptor(
            name: "Readiness over time",
            isContinuous: true,
            dataPoints: points.enumerated().map { index, point in
                AXDataPoint(x: Double(index), y: Double(point.percent), label: point.monthLabel)
            }
        )

        return AXChartDescriptor(
            title: "Readiness over time",
            summary: accessibilitySummary,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}

#if DEBUG
private extension Array where Element == ReadinessHistoryPoint {
    static var previewSample: [ReadinessHistoryPoint] {
        [
            ReadinessHistoryPoint(monthLabel: "Jan", percent: 42),
            ReadinessHistoryPoint(monthLabel: "Feb", percent: 55),
            ReadinessHistoryPoint(monthLabel: "Mar", percent: 61),
            ReadinessHistoryPoint(monthLabel: "Apr", percent: 58),
            ReadinessHistoryPoint(monthLabel: "May", percent: 73),
            ReadinessHistoryPoint(monthLabel: "Jun", percent: 80)
        ]
    }
}
#endif // DEBUG

#Preview {
    ReadinessChart(points: .previewSample)
        .padding()
        .background(Color.appGroupedBackground)
}
