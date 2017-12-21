//
//  MeetingsAverageNumberChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/8/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

// Copied from ActivityChart
final class MeetingsAverageNumberChart: UIView {

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

private extension MeetingsAverageNumberChart {

    func hasShadow(_ dataPoint: DataPoint) -> Bool {
        switch dataPoint.color {
        case UIColor.white90: return true
        default: return false
        }
    }

    var bottomPosition: CGFloat {
        return frame.height - padding * 0.75
    }

    func xPosition(_ index: Int) -> CGFloat {
        guard labelContentView.subviews.count >= index else {
            return 0
        }

        let labelFrame = labelContentView.subviews[index].frame

        return (labelFrame.origin.x + labelFrame.width * 0.5)
    }

    func yPosition(_ value: CGFloat) -> CGFloat {
        return (bottomPosition - (value * bottomPosition)) + padding * 0.5
    }

    func drawCapRoundLine(xPos: CGFloat, startYPos: CGFloat, endYPos: CGFloat, strokeColor: UIColor, hasShadow: Bool = false) {
        let startPoint = CGPoint(x: xPos, y: startYPos)
        let endPoint = CGPoint(x: xPos, y: endYPos)
        drawDashedLine(from: startPoint, to: endPoint, lineWidth: 12, strokeColor: strokeColor, dashPattern: [1, 2])
        layoutIfNeeded()
    }

    func addAverageLines() {
        let yPos = yPosition(statistics.userAverageValue)
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

    func updateLabelFrames() {
        labelContentView.subviews.forEach { (subView: UIView) in
            if subView is UILabel {
                let frame = subView.frame
                subView.sizeToFit()
                let fittedFrame = subView.frame
                subView.frame = CGRect(x: frame.origin.x + yAxisOffset,
                                       y: frame.origin.y,
                                       width: fittedFrame.width,
                                       height: frame.height)
            }
        }
    }

    func setupView() {
        updateLabelFrames()
        addAverageLines()

        let maxValue = statistics.maximum.toFloat
        let delta = maxValue/5
        addCaptionLabel(yPos: yPosition(1/5), text: "\(Int(delta*1))")
        addCaptionLabel(yPos: yPosition(2/5), text: "\(Int(delta*2))")
        addCaptionLabel(yPos: yPosition(3/5), text: "\(Int(delta*3))")
        addCaptionLabel(yPos: yPosition(4/5), text: "\(Int(delta*4))")
    }

    func drawCharts() {
        for (index, dataPoint) in statistics.dataPointObjects.enumerated() {
            let xPos = xPosition(index)
            let yPos = yPosition(dataPoint.value / statistics.maximum.toFloat)
            drawCapRoundLine(xPos: xPos, startYPos: bottomPosition, endYPos: yPos, strokeColor: dataPoint.color, hasShadow: hasShadow(dataPoint))
        }
    }

    func drawTodayValueLabel() {
        guard let dataPoint = statistics.dataPointObjects.last, dataPoint.value > 0 else { return }
        let xPos = xPosition(statistics.dataPointObjects.endIndex - 1)
        let yPos = yPosition(dataPoint.value / statistics.maximum.toFloat)
        let text = statistics.displayableValue(average: Double(dataPoint.value))
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
