//
//  MeetingsLengthChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MeetingsLengthChart: UIView {

    // MARK: - Properties

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8
    private let yAxisOffset: CGFloat = 20

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView
        super.init(frame: frame)
        setupView()
        drawCharts()
        drawTodayValueLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension MeetingsLengthChart {

    func hasShadow(_ dataPoint: DataPoint) -> Bool {
        switch dataPoint.color {
        case UIColor.white90: return true
        default: return false
        }
    }

    var bottomPosition: CGFloat {
        return frame.height - padding * 5
    }

    func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else { return 0 }
        let labelFrame = labelContentView.subviews[index].frame
        return labelFrame.origin.x + labelFrame.width * 0.5
    }

    func yPosition(_ value: CGFloat) -> CGFloat {
        return (bottomPosition - (value * bottomPosition)) + padding * 5
    }

    func drawCapRoundLine(xPos: CGFloat, startYPos: CGFloat, endYPos: CGFloat, strokeColor: UIColor, hasShadow: Bool = false) {
        let startPoint = CGPoint(x: xPos, y: startYPos)
        let endPoint = CGPoint(x: xPos, y: endYPos)
        drawDashedLine(from: startPoint, to: endPoint, lineWidth: 12, strokeColor: strokeColor, dashPattern: [1, 2])
        layoutIfNeeded()
    }

    func addAverageLines() {
        let yPos = yPosition(statistics.userAverageValue) - 35
        let averageFrame = CGRect(x: yAxisOffset, y: yPos, width: frame.width - yAxisOffset, height: 0)
        let averageLine = CAShapeLayer()
        averageLine.strokeColor = UIColor.white8.cgColor
        averageLine.fillColor = UIColor.clear.cgColor
        averageLine.lineWidth = 1.5
        averageLine.lineDashPattern = [1.5, 3]
        averageLine.path = UIBezierPath(rect: averageFrame).cgPath
        layer.addSublayer(averageLine)
        layoutIfNeeded()
    }

    func addCaptionLabel(yPos: CGFloat, text: String) {
        let captionLabel = UILabel()
        captionLabel.center = CGPoint(x: 0, y: yPos)
        captionLabel.setAttrText(text: text, font: Font.H7Title, lineSpacing: 1, characterSpacing: 1, color: .white20)
        captionLabel.sizeToFit()
        addSubview(captionLabel)
    }

    func setupView() {
        addAverageLines()
        let maxValue = (statistics.maximum / 60).rounded(.up).toFloat
        let delta = maxValue / 5
        addCaptionLabel(yPos: yPosition(1/5), text: "\(Int(delta*1))")
        addCaptionLabel(yPos: yPosition(2/5), text: "\(Int(delta*2))")
        addCaptionLabel(yPos: yPosition(3/5), text: "\(Int(delta*3))")
        addCaptionLabel(yPos: yPosition(4/5), text: "\(Int(delta*4))")
		addCaptionLabel(yPos: yPosition(5/5), text: "\(Int(delta*5))")
    }

    func drawCharts() {
        for (index, dataPoint) in statistics.dataPointObjects.enumerated() where dataPoint.percentageValue > 0 {
            let xPos = xPosition(index)
            let yPos = yPosition(dataPoint.percentageValue)
            drawCapRoundLine(xPos: xPos,
                             startYPos: bottomPosition,
                             endYPos: yPos > 0 ? yPos : 0,
                             strokeColor: dataPoint.color,
                             hasShadow: hasShadow(dataPoint))
        }
    }

    func drawTodayValueLabel() {
        let todayIndex: Int
        let currentDay = Date().dayOfWeek
        switch currentDay {
        case 1: // Sunday
            todayIndex = statistics.dataPointObjects.count - 1
        case 2: // Monday
            todayIndex = 0
        default:
            todayIndex = currentDay - 2
        }
        guard todayIndex < statistics.dataPointObjects.count else { return }
        let dataPoint = statistics.dataPointObjects[todayIndex]
        let xPos = xPosition(todayIndex)
        let yPos = yPosition(dataPoint.percentageValue)
        let text = Int(dataPoint.originalValue * 60).seconds2Timestamp
        let todayLabel = dayLabel(text: text)
        todayLabel.sizeToFit()
        todayLabel.center = CGPoint(x: xPos, y: yPos - 35)
        addSubview(todayLabel)
    }

    func dayLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = Font.H7Title
        label.textAlignment = .center
        label.textColor = .white
        label.text = text
        return label
    }
}

// MARK: - Int extension for today label

private extension Int {

    var seconds2Timestamp: String {
        let mins: Int = (self % 3600) / 60
        let hours: Int = self / 3600
        let timeIndicator = hours < 1 ? "min" : "h"
        let time = (hours == 0) ? "\(mins)" : "\(hours):\(mins)"
        return time + timeIndicator
    }
}
