//
//  PolygonChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SleepChart: UIView {

    // MARK: - Properties

    private var arrayOfLabels = [UILabel]()
    private var statistics: Statistics
    private let padding: CGFloat = 8
    private let yPosition: CGFloat = 40

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics) {
        self.statistics = statistics

        super.init(frame: frame)

        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension SleepChart {

    func drawCharts() {
        createDayLabel()
        lineBounds(isDataPoint: false)
        lineBounds(isDataPoint: true)
        drawShape()
    }

    func lineBounds(isDataPoint: Bool) {
        guard statistics.dataPoints.isEmpty == false else { return }
        let width = min(frame.width, frame.height)
        let startPoint = CGPoint(x: center.x, y: center.y + yPosition)
        let theta = 72
        var angle = 198

        for (index, dataPoint) in statistics.dataPointObjects.enumerated() {
            let length: CGFloat

            if isDataPoint == true {
                length = (width * 0.5 ) * dataPoint.value
            } else {
                length = (width * 0.5 )
                let offset = lineLength(length: length, degress: angle)
                let corner = CGPoint(x: startPoint.x + offset.x, y: startPoint.y + offset.y)
                let end = CGPoint(x: corner.x, y: corner.y)
                let frame = CGRect(x: end.x, y: end.y, width: 21, height: 21)
                frameForLabels(frame: frame, center: startPoint, index: index)
            }

            let offset = lineLength(length: length, degress: angle)
            let corner = CGPoint(x: startPoint.x + offset.x, y: startPoint.y + offset.y)
            let endPoint = CGPoint(x: corner.x, y: corner.y)
            drawLines(startPoint: startPoint, endPoint: endPoint, color: dataPoint.color, isDataPoint: isDataPoint)
            layoutIfNeeded()
            angle += theta
        }
    }

    func lineLength(length: CGFloat, degress: Int) -> (x: CGFloat, y: CGFloat) {
        return (x: length * cos(CGFloat(degress).degreesToRadians), y: length * sin(CGFloat(degress).degreesToRadians))
    }

    func frameForLabels(frame: CGRect, center: CGPoint, index: Int) {
        let space: CGFloat = 4
        let label = arrayOfLabels[index]

        switch index {
        case 0: label.center = CGPoint(x: frame.minX - frame.width - space, y: frame.minY - (frame.height * 0.5))
        case 1: label.center = CGPoint(x: center.x - padding, y: frame.minY - (frame.height * 0.5) - padding)
        case 2: label.center = CGPoint(x: frame.maxX - padding, y: frame.minY - (frame.height * 0.5))
        case 3: label.center = CGPoint(x: frame.maxX - frame.width + space, y: frame.maxY - padding)
        case 4: label.center = CGPoint(x: frame.minX - frame.width - padding, y: frame.maxY - padding)
        default: break
        }

        label.sizeToFit()
    }

    func drawLines(startPoint: CGPoint, endPoint: CGPoint, color: UIColor, isDataPoint: Bool) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        line.path = linePath.cgPath

        if isDataPoint == true {
            line.lineWidth = 4
            line.lineDashPattern = statistics.chartType == .sleepQuantity ? [1.5, 1] : nil
            line.lineCap = statistics.chartType == .sleepQuantity ? kCALineCapButt : kCALineCapRound
            line.strokeColor = color.cgColor
            line.addGlowEffect(color: .white)
        } else {
            line.strokeColor = UIColor.white8.cgColor
            line.fillColor = UIColor.clear.cgColor
            line.lineWidth = 1.5
            line.lineDashPattern = [1.5, 3]
        }

        layer.addSublayer(line)
        layoutIfNeeded()
    }

    func drawShape() {
        layer.addSublayer(innerPolygonShape())
        layer.addSublayer(outerPolygonShape())
        layoutIfNeeded()
    }

    func innerPolygonShape() -> CAShapeLayer {
        let innerPolygonShape = shape(borderColor: .white8)
        let scaleFactor = CGFloat(statistics.teamAverage)
        let innerFrame = frame.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        innerPolygonShape.lineDashPattern = [1.5, 3]
        innerPolygonShape.path = UIBezierPath.pentagonPath(forRect: innerFrame).cgPath
        innerPolygonShape.transform = CATransform3DMakeTranslation(frame.midX - innerFrame.midX,
                                                                   frame.midY - innerFrame.midY + yPosition,
                                                                   0)
        return innerPolygonShape
    }

    func outerPolygonShape() -> CAShapeLayer {
        let outerPolygonShape = shape(borderColor: .white20)
        outerPolygonShape.path = UIBezierPath.pentagonPath(forRect: frame).cgPath
        outerPolygonShape.transform = CATransform3DMakeTranslation(0, yPosition, 0)

        return outerPolygonShape
    }

    func createDayLabel() {
        statistics.chartType.labels.forEach { (weekdaySymbol: String) in
            let todaySymbol = Calendar.sharedUTC.shortWeekdaySymbols[Date().dayOfWeek - 1]
            let textColor: UIColor = todaySymbol == weekdaySymbol ? .white : .white20
            let label = dayLabel(text: weekdaySymbol, textColor: textColor)
            arrayOfLabels.append(label)
            addSubview(label)
        }
    }

    func dayLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = Font.H7Title
        label.textAlignment = .center
        label.textColor = textColor
        label.text = text

        return label
    }

    func shape(borderColor: UIColor, fillColor: UIColor = .clear) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = borderColor.cgColor
        shape.fillColor = fillColor.cgColor

        return shape
    }
}

// MARK: - UIBezierPath helper

private extension UIBezierPath {

    class func pentagonPath(forRect rect: CGRect) -> UIBezierPath {
        return UIBezierPath(polygonIn: rect, sides: 5, lineWidth: 0, cornerRadius: 0)
    }
}
