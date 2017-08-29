//
//  SittingMovementChartView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/8/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class ActivityChartView: UIView {

    enum AverageLineType {
        case data
        case personal
        case team

        static var allValues: [AverageLineType] {
            return [.data, .personal, .team]
        }

        var strokeColor: CGColor {
            switch self {
            case .data: return UIColor.cherryRedTwo30.cgColor
            case .personal: return UIColor.white8.cgColor
            case .team: return UIColor.azure20.cgColor
            }
        }

        func averageValue(myStatistics: MyStatistics) -> CGFloat {
            switch self {
            case .data: return myStatistics.dataAverageValue
            case .personal: return myStatistics.userAverageValue
            case .team: return myStatistics.teamAverageValue
            }
        }
    }

    // MARK: - Properties

    fileprivate let labelContainer = UIView()
    fileprivate let myStatistics: MyStatistics
    fileprivate let padding = CGFloat(8)

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        setupView()
        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension ActivityChartView {

    func setupView() {
        setupAverageLine()
        setupLabels()
    }

    private func setupLabels() {
        addSubview(labelContainer)
        labelContainer.leadingAnchor == leadingAnchor + padding
        labelContainer.trailingAnchor == trailingAnchor - padding
        labelContainer.bottomAnchor == bottomAnchor
        labelContainer.heightAnchor == 20
        let startPoint = CGPoint(x: frame.origin.x, y: 0)
        let endPoint = CGPoint(x: frame.width, y: 0)
        let labels = DateFormatter().veryShortStandaloneWeekdaySymbols.mondayFirst(withWeekend: false)
        labelContainer.drawSolidLine(from: startPoint, to: endPoint, strokeColour: .white20)
        labelContainer.drawLabelsForColumns(labels: labels,
                                            columnCount: labels.count,
                                            textColour: .white20,
                                            font: Font.H7Title,
                                            center: true)
        layoutIfNeeded()
    }

    private func setupAverageLine() {
        let separatorHeight: CGFloat = 1
        let height = bounds.height - padding - separatorHeight - labelContainer.frame.height

        AverageLineType.allValues.forEach { (averageLineType: AverageLineType) in
            let position = height * averageLineType.averageValue(myStatistics: myStatistics)
            let xPos = bounds.minX + padding
            let yPos = bounds.height - position
            let width = bounds.width - 2 * padding
            let frame = CGRect(x: xPos, y: yPos, width: width, height: 0)
            let averageLayer = createDottedLayer()
            averageLayer.path = UIBezierPath(roundedRect: frame, cornerRadius: 0).cgPath
            averageLayer.strokeColor = averageLineType.strokeColor
            layer.addSublayer(averageLayer)
        }
    }

    func createDottedLayer() -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath(roundedRect: .zero, cornerRadius: 0)
        line.strokeColor = UIColor.clear.cgColor
        line.fillColor = UIColor.clear.cgColor
        line.frame = linePath.bounds
        line.lineWidth = 1.5
        line.lineDashPattern = [1.5, 3]
        line.path = linePath.cgPath

        return line
    }

    func drawCharts() {
        let lineWidth = CGFloat(8)
        let bottomPos = frame.height - labelContainer.frame.height - (padding * 0.5)

        for (index, dataPoint) in myStatistics.dataPointObjects.enumerated() {
            let xPos = xPosition(index: index, columnWidth: lineWidth)
            let yPos = bottomPos - dataPoint.value * bottomPos + labelContainer.frame.height - (padding * 0.5)
            let startPoint = CGPoint(x: xPos, y: bottomPos)
            let endPoint = CGPoint(x: xPos, y: yPos)

            if myStatistics.key == StatisticCardType.activitySittingMovementRatio.rawValue && dataPoint.value < 1 {
                drawInactivityLine(xPos: xPos, yPos: yPos)
            }

            drawCapRoundLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColour: dataPoint.color)
        }
    }

    private func drawInactivityLine(xPos: CGFloat, yPos: CGFloat) {
        let startPoint = CGPoint(x: xPos, y: yPos)
        let endPoint = CGPoint(x: xPos, y: labelContainer.frame.height - (padding * 0.5))
        drawCapRoundLine(from: startPoint, to: endPoint, lineWidth: CGFloat(8), strokeColour: .white20)
    }

    private func xPosition(index: Int, columnWidth: CGFloat) -> CGFloat {
        let labelFrame = labelContainer.subviews[index].frame

        return (labelFrame.origin.x + labelFrame.width * 0.5) + padding
    }
}
