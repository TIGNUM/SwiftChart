//
//  PeakPerformanceUpcomingChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 20/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PeakPerformanceUpcomingChart: UIView {

    // MARK: - Properties

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8
    private let yAxisOffset: CGFloat = 40

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        drawBackground()
        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension PeakPerformanceUpcomingChart {

    private var rows: Int {
        return statistics.chartType.statsPeriods.rows
    }

    private var rowWidth: CGFloat {
        return (frame.width - yAxisOffset) / CGFloat(rows)
    }

    private func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else { return 0 }
        let labelFrame = labelContentView.subviews[index].frame

        return (labelFrame.origin.x + labelFrame.width * 0.5)
    }

    private var bottomPosition: CGFloat {
        return frame.height - padding * 0.75
    }

    private func yPosition(_ value: CGFloat) -> CGFloat {
        return (bottomPosition - (value * bottomPosition)) + padding * 0.5
    }

    private func addCaptionLabel(yPos: CGFloat, text: String) {
        let captionLabel = UILabel(frame: CGRect(x: 0, y: yPos - yAxisOffset * 0.25, width: yAxisOffset, height: yAxisOffset * 0.5))
        captionLabel.setAttrText(text: text, font: Font.H7Title, lineSpacing: 1, characterSpacing: 1, color: .white20)
        addSubview(captionLabel)
    }

    private func updateLabelFrames() {
        for (index, subView) in labelContentView.subviews.enumerated() where subView is UILabel {
            let frame = subView.frame
            subView.sizeToFit()
            subView.frame = CGRect(x: rowWidth * CGFloat(index + 1),
                                   y: frame.origin.y,
                                   width: rowWidth,
                                   height: frame.height)
        }
    }

    func drawCharts() {
        let singleStepUnit = frame.height / (24 * 60)
        let lineWidth = rowWidth / 3

        for (index, periodsInOneDay) in statistics.periodUpcominngWeek.enumerated() {
            let xPos = xPosition(index)

            periodsInOneDay.forEach { (period: StatisticsPeriod) in
                let startPoint = CGPoint(x: xPos, y: CGFloat(period.startMinute) * singleStepUnit)
                let endPoint = CGPoint(x: xPos, y: CGFloat(period.startMinute + period.minutes) * singleStepUnit)
                let strokeColor = period.status.color
                let hasShadow = period.status == .normal

                drawSolidLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColor: strokeColor, hasShadow: hasShadow)
            }
        }
    }

    func drawBackground() {
        updateLabelFrames()
        addCaptionLabel(yPos: yPosition(0.75), text: "06:00")
        addCaptionLabel(yPos: yPosition(0.50), text: "12:00")
        addCaptionLabel(yPos: yPosition(0.25), text: "18:00")
        drawSolidColumns(xPos: yAxisOffset,
                         columnWidth: rowWidth,
                         columnHeight: frame.height,
                         columnCount: rows,
                         strokeWidth: 1,
                         strokeColor: .white20)
    }
}
