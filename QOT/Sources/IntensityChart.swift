//
//  IntensityChart.swift
//  QOT
//
//  Created by karmic on 24.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class IntensityChart: UIView {

    // MARK: - Properties

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        setupView()
        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension IntensityChart {

    func setupView() {
        setupBackground()
        setupThreshholdLine()
    }

    func drawCharts() {
        for (index, dataPoint) in statistics.dataPointObjects.enumerated() {
            let xPos = firstSection == true ? xPosition(index) : (columnWidth * CGFloat(index) * 2)
            let yPos = yPosition(dataPoint.value)
            let height = dataPoint.value > 0 ? yPos - bottomPosition : 0
            let columnFrame = CGRect(x: xPos, y: frame.height, width: columnWidth, height: height).integral
            let column = UIView(frame: columnFrame)
            column.backgroundColor = .white8
            column.layer.cornerRadius = firstSection == true ? 5 : 0
            column.layer.borderWidth = firstSection == true ? 0.5 : 0.2
            column.layer.borderColor = dataPoint.color.cgColor
            column.layer.masksToBounds = true
            addSubview(column)
        }
    }
}

// MARK: - View Setup

private extension IntensityChart {

    var columnWidth: CGFloat {
        return firstSection ? 10 : frame.width / CGFloat(statistics.dataPointObjects.count * 2)
    }

    var firstSection: Bool {
        return statistics.chartType == .intensityLoadWeek || statistics.chartType == .intensityRecoveryWeek
    }

    var bottomPosition: CGFloat {
        return frame.height - padding
    }

    func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else {
            return 0
        }

        let labelFrame = labelContentView.subviews[index].frame

        return labelFrame.origin.x + labelFrame.width * 0.5
    }

    func yPosition(_ value: CGFloat) -> CGFloat {
        let multiplier = (value <= 1 ? value : 1)
        return (bottomPosition - (multiplier * bottomPosition)) - padding
    }

    func setupBackground() {
        let numberOfLines = 10
        let distance = frame.height / CGFloat(numberOfLines)

        for index in 0 ..< numberOfLines {
            let yPos = distance * CGFloat(index)
            let start = CGPoint(x: 0, y: yPos)
            let end = CGPoint(x: frame.width, y: yPos)
            drawSolidLine(from: start, to: end, lineWidth: 0.5, strokeColor: .white20)
        }
    }

    func setupThreshholdLine() {
        let yPos = bottomPosition - statistics.upperThreshold.toFloat * bottomPosition
        let start = CGPoint(x: 0, y: yPos)
        let end = CGPoint(x: frame.width, y: yPos)
        drawDashedLine(from: start, to: end, lineWidth: 1, strokeColor: .cherryRedTwo30, dashPattern: [1.5, 3.0])
    }
}
