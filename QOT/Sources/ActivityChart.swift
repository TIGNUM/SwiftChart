//
//  ActivityChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/8/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ActivityChart: UIView {

    // MARK: - Properties

    private var statistics: Statistics
    private var labelContentView: UIView
    private let padding: CGFloat = 8
    private let xAxisOffset: CGFloat = 20
    private let yAxisOffset: CGFloat = 40

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

private extension ActivityChart {

    func hasShadow(_ dataPoint: DataPoint) -> Bool {
        switch dataPoint.color {
        case UIColor.white90: return true
        default: return false
        }
    }

    var bottomPosition: CGFloat {
        return frame.height - padding * Layout.multiplier_075
    }

    func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else { return 0 }
        let labelFrame = labelContentView.subviews[index].frame
        return (labelFrame.origin.x + labelFrame.width * Layout.multiplier_05)
    }

    func yPosition(_ value: CGFloat) -> CGFloat {
        return (bottomPosition - (value * bottomPosition)) + padding * Layout.multiplier_05
    }

    private func drawCapRoundLine(xPos: CGFloat,
                                  startYPos: CGFloat,
                                  endYPos: CGFloat,
                                  strokeColor: UIColor,
                                  hasShadow: Bool = false) {
        let startPoint = CGPoint(x: xPos, y: startYPos)
        let endPoint = CGPoint(x: xPos, y: endYPos)
        drawCapRoundLine(from: startPoint, to: endPoint, lineWidth: 8, strokeColor: strokeColor, hasShadow: hasShadow)
        layoutIfNeeded()
    }

    func addAverageLines() {
        let yPos = yPosition(statistics.userAverageValue)
        let averageFrame = CGRect(x: xAxisOffset, y: yPos, width: frame.width - xAxisOffset, height: 0)
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
        let captionLabel = UILabel(frame: CGRect(x: 0,
                                                 y: yPos - yAxisOffset * Layout.multiplier_025,
                                                 width: yAxisOffset,
                                                 height: yAxisOffset * Layout.multiplier_05))
        captionLabel.setAttrText(text: text, font: Font.H7Title, lineSpacing: 1, characterSpacing: 1, color: .white20)
        addSubview(captionLabel)
    }

    func updateLabelFrames() {
        labelContentView.subviews.forEach { (subView: UIView) in
            if subView is UILabel {
                let frame = subView.frame
                subView.sizeToFit()
                let fittedFrame = subView.frame
                subView.frame = CGRect(x: frame.origin.x + xAxisOffset,
                                       y: frame.origin.y,
                                       width: fittedFrame.width,
                                       height: frame.height)
            }
        }
    }

    func setupView() {
        updateLabelFrames()
        addAverageLines()
        let maxValue = statistics.multiplier
        let delta = maxValue/4
        addCaptionLabel(yPos: yPosition(0.25), text: "\(delta*1)")
        addCaptionLabel(yPos: yPosition(0.50), text: "\(delta*2)")
        addCaptionLabel(yPos: yPosition(0.75), text: "\(delta*3)")
    }

    func drawCharts() {
        for (index, dataPoint) in statistics.dataPointObjects.enumerated() where dataPoint.percentageValue > 0 {
            let xPos = xPosition(index)
            let yPos = yPosition(dataPoint.percentageValue)
            drawCapRoundLine(xPos: xPos,
                             startYPos: bottomPosition,
                             endYPos: yPos,
                             strokeColor: dataPoint.color,
                             hasShadow: hasShadow(dataPoint))
            if statistics.chartType == .activitySittingMovementRatio && dataPoint.percentageValue < 1 {
                drawCapRoundLine(xPos: xPos, startYPos: yPos - padding, endYPos: padding * 0.5, strokeColor: .white20)
            }
        }
    }

    func drawTodayValueLabel() {
        guard let dataPoint = statistics.dataPointObjects.last, dataPoint.percentageValue > 0 else { return }
        let xIndex = statistics.dataPointObjects.endIndex > 0 ? statistics.dataPointObjects.endIndex - 1 : 0
        let xPos = xPosition(xIndex)
        let yPos = yPosition(dataPoint.percentageValue)
        let text = statistics.displayableValue(average: Double(dataPoint.percentageValue))
        let todayLabel = dayLabel(text: text, textColor: .white)
        todayLabel.sizeToFit()
        todayLabel.center = CGPoint(x: xPos, y: yPos - 12)
        addSubview(todayLabel)
    }

    func dayLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = Font.H7Title
        label.textAlignment = .center
        label.textColor = textColor
        label.text = text
        return label
    }
}
