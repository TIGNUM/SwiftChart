//
//  MeetingsTimeBetweenChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MeetingsTimeBetweenChart: UIView {

    private let statistics: Statistics
    private let labelContentView: UIView

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        let center = self.center
        let radius = frame.height * 0.33

        drawProgressWheel(at: center, with: radius)
        drawSectionLabels(center: center, radius: radius)
        if statistics.userAverageValue > 0 {
            drawValueLabel(center: center, radius: radius, value: statistics.userAverageValue, text: statistics.userAverageDisplayableValue)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension MeetingsTimeBetweenChart {

    func drawProgressWheel(at center: CGPoint, with radius: CGFloat) {
        let lineWidth = CGFloat(12)
        let innerRadius = radius * 0.55
        let underRadius = radius - lineWidth / 3

        drawSolidCircle(arcCenter: center, radius: innerRadius, strokeColor: .white20)
        drawSolidCircle(arcCenter: center, radius: underRadius, lineWidth: lineWidth * 0.5, strokeColor: .white20)
        drawDashedCircle(arcCenter: center, radius: radius, lineWidth: lineWidth, dashPattern: [1, 2], value: statistics.userAverageValue, strokeColor: statistics.pathColor)
    }

    func drawSectionLabels(center: CGPoint, radius: CGFloat) {
        let maxValue = statistics.maximum.toFloat
        let divisions = 3
        let theta = maxValue / CGFloat(divisions)
        drawLabel(from: center, with: radius, at: 270, padding: 8, value: statistics.displayableValue(average: 0), color: .white20)
        for i in 1..<divisions {
            let value = theta * CGFloat(i)
            let percentage = value / maxValue
            let angle = (360 * percentage).normalizedAngle
            let stringValue = String(format: "%.0f", value)
            drawLabel(from: center, with: radius, at: angle, padding: 8, value: stringValue, color: .white20)
        }
    }

    func drawValueLabel(center: CGPoint, radius: CGFloat, value: CGFloat, text: String) {
        let angle = (360 * value).normalizedAngle
//        let stringValue = String(format: "%.0f", value)
        drawLabel(from: center, with: radius, at: angle, padding: 23, value: text, color: .white)
    }

    func drawLabel(from center: CGPoint, with radius: CGFloat, at angle: CGFloat, padding: CGFloat, value: String, color: UIColor) {
        let label = dayLabel(text: value, textColor: color)
        label.text = value
        label.sizeToFit()
        let padding = self.padding(for: label, with: angle, appendExtra: padding)
        label.center = CGPoint(
            x: center.x + cos(angle.degreesToRadians) * (radius + padding.x),
            y: center.y + sin(angle.degreesToRadians) * (radius + padding.y)
        )
        addSubview(label)
    }

    func padding(for label: UILabel, with angle: CGFloat, appendExtra space: CGFloat) -> CGPoint {
        if angle == 0 || angle == 360 || angle == 180 {
            return CGPoint(x: label.bounds.width/2 + space, y: 0)
        }
        if angle == 90 || angle == 270 {
            return CGPoint(x: 0, y: label.bounds.height/2 + space)
        }
        return CGPoint(x: label.bounds.width/2 + space, y: label.bounds.height/2 + space)
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

// MARK: - CGFloat

private extension CGFloat {
    var normalizedAngle: CGFloat {
        return self-90.0 // -90 as 0 starts at 3 o'clock
    }
}
