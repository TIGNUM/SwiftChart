//
//  ActivityChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/8/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ActivityChart: UIView {

    fileprivate enum AverageLineType: EnumCollection {
        case data
        case personal
        case team

        var strokeColor: CGColor {
            switch self {
            case .data: return UIColor.cherryRedTwo30.cgColor
            case .personal: return UIColor.white8.cgColor
            case .team: return UIColor.azure20.cgColor
            }
        }

        func average(_ statistics: Statistics) -> CGFloat {
            switch self {
            case .data: return statistics.dataAverageValue
            case .personal: return statistics.userAverageValue
            case .team: return statistics.teamAverageValue
            }
        }
    }

    // MARK: - Properties

    fileprivate var statistics: Statistics
    fileprivate var labelContentView: UIView
    fileprivate let padding: CGFloat = 8

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

// MARK: - ChartViewDelegate

extension ActivityChart {

    func hasShadow(_ dataPoint: DataPoint) -> Bool {
        switch dataPoint.color {
        case UIColor.white90: return true
        default: return false
        }
    }

    var bottomPosition: CGFloat {
        return frame.height - padding
    }

    func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else {
            return 0
        }

        let labelFrame = labelContentView.subviews[index].frame

        return (labelFrame.origin.x + labelFrame.width * 0.5)
    }

    func yPosition(_ value: CGFloat) -> CGFloat {
        return (bottomPosition - (value * bottomPosition)) + padding
    }

    func drawCapRoundLine(xPos: CGFloat, startYPos: CGFloat, endYPos: CGFloat, strokeColor: UIColor, hasShadow: Bool = false) {
        let startPoint = CGPoint(x: xPos, y: startYPos)
        let endPoint = CGPoint(x: xPos, y: endYPos)
        drawCapRoundLine(from: startPoint, to: endPoint, lineWidth: 8, strokeColor: strokeColor, hasShadow: hasShadow)
        layoutIfNeeded()
    }

    func setupView() {
        AverageLineType.allValues.forEach { (averageLineType: AverageLineType) in
            let yPos = yPosition(averageLineType.average(statistics))
            let averageFrame = CGRect(x: 0, y: yPos, width: frame.width, height: 0)
            let averageLine = CAShapeLayer()
            averageLine.strokeColor = averageLineType.strokeColor
            averageLine.fillColor = UIColor.clear.cgColor
            averageLine.lineWidth = 1.5
            averageLine.lineDashPattern = [1.5, 3]
            averageLine.path = UIBezierPath(rect: averageFrame).cgPath
            layer.addSublayer(averageLine)
            layoutIfNeeded()
        }
    }

    func drawCharts() {
        let daataPoints = statistics.dataPointObjects.filter { $0.value > 0 }

        for (index, dataPoint) in daataPoints.enumerated() {
            let xPos = xPosition(index)
            let yPos = yPosition(dataPoint.value)
            drawCapRoundLine(xPos: xPos, startYPos: bottomPosition, endYPos: yPos, strokeColor: dataPoint.color, hasShadow: hasShadow(dataPoint))

            if statistics.chartType == .activitySittingMovementRatio && dataPoint.value < 1 {
                drawCapRoundLine(xPos: xPos, startYPos: yPos - padding, endYPos: padding, strokeColor: .white20)
            }
        }
    }
}
