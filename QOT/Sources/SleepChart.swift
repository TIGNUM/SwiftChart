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

    fileprivate var arrayOfLabels = [UILabel]()
    fileprivate var statistics: Statistics
    fileprivate let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics) {
        self.statistics = statistics        

        super.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
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

    var sleepChartYPos: CGFloat {
        return frame.height / 5
    }

    /// FIXME: REFACTORME This func is actually used to parts from the backgrounds and the userDataPoints.
    /// - isDataPoint will tell us what to draw.
    ///
    /// FIX: That function have to breake down and put a part. The logic should be divided.
    /// There also extensions for drawing lines in the extension file, we should use them.
    func lineBounds(rotationOffset: CGFloat = 0, isDataPoint: Bool) {
        precondition(statistics.dataPoints.isEmpty == false, "No Data available")

        let tempWidth = frame.width - frame.width / 3
        let yPos = sleepChartYPos
        let rect = CGRect(x: tempWidth / 4, y: yPos, width: tempWidth, height: frame.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / 5
        let width = min(frame.width, frame.height)
        let startPoint = CGPoint(x: rect.origin.x + width * 0.5, y: rect.origin.y + width * 0.5)
        var angle = CGFloat(rotationOffset)

        for (index, dataPoint) in statistics.dataPointObjects.enumerated() {
            angle += theta
            let length: CGFloat

            if isDataPoint == true {
                length = (width * 0.5 ) * dataPoint.value
            } else {
                length = (width * 0.5 )
                let corner = CGPoint(x: startPoint.x + length * cos(angle), y: startPoint.y + length * sin(angle))
                let end = CGPoint(x: corner.x, y: corner.y)
                let frame = CGRect(x: end.x, y: end.y, width: 21, height: 21)
                frameForLabels(frame: frame, center: startPoint, index: index)
            }

            let corner = CGPoint(x: startPoint.x + length * cos(angle), y: startPoint.y + length * sin(angle))
            let endPoint = CGPoint(x: corner.x, y: corner.y)
            drawLines(startPoint: startPoint, endPoint: endPoint, color: dataPoint.color, isDataPoint: isDataPoint)
            layoutIfNeeded()
        }
    }

    func frameForLabels(frame: CGRect, center: CGPoint, index: Int) {
        let space: CGFloat = 4
        let label = arrayOfLabels[index]

        if frame.minX >= center.x {
            if frame.minY >= center.y {
                label.center = CGPoint(x: frame.minX, y: frame.minY + space)
            } else {
                label.center = CGPoint(x: frame.minX + space, y: frame.minY - frame.height)
            }
        } else {
            if frame.minY >= center.y {
                label.center = CGPoint(x: frame.minX - frame.width - space, y: frame.minY)
            } else {
                label.center = CGPoint(x: frame.minX - frame.width - space, y: frame.minY - frame.height / 2)
            }
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
        } else {
            line.lineWidth = 1
            line.lineDashPattern = [0.5, 2]
            line.lineJoin = kCALineJoinRound
            line.strokeColor = UIColor.white20.cgColor
        }

        line.addGlowEffect(color: .white)
        layer.addSublayer(line)
    }

    func drawShape() {
        let outerPolygonShape = shape(borderColor: .white20)
        outerPolygonShape.path = UIBezierPath.pentagonPath(forRect: frame).cgPath
        outerPolygonShape.transform = CATransform3DMakeTranslation(0, sleepChartYPos, 0)
        let innerPolygonShape = shape(borderColor: .white20)
        let scaleFactor = CGFloat(statistics.teamAverage)
        let innerFrame = frame.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        innerPolygonShape.path = UIBezierPath.pentagonPath(forRect: innerFrame).cgPath
        innerPolygonShape.transform = CATransform3DMakeTranslation(frame.midX - innerFrame.midX,
                                                                   frame.midY - innerFrame.midY + sleepChartYPos,
                                                                   0)
        layer.addSublayer(innerPolygonShape)
        layer.addSublayer(outerPolygonShape)
        layoutIfNeeded()
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
        return UIBezierPath(polygonIn: rect, sides: 5, lineWidth: 0, cornerRadius: 0, rotateByDegs: 90 / 5)
    }
}
