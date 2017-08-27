//
//  PolygonChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum ChartType {
    case qualitySleep
    case quantitySleep

    func lineColor(value: CGFloat, average: CGFloat) -> UIColor {
        return value <= average ? .cherryRed : .white
    }

    var borderColor: UIColor {
        return .white20
    }

    var sides: Int {
        return 5
    }

    var borderWidth: CGFloat {
        return 1
    }

    var days: [String] {
        let formatter = DateFormatter()
        let day = formatter.veryShortStandaloneWeekdaySymbols
        let temDay = day?.first

        guard var days = day, let temp = temDay else {
            preconditionFailure("day empty")
        }

        days.removeFirst()
        days.append(temp)

        return days
    }
}

final class SleepChartView: UIView {

    // MARK: - Properties

    fileprivate var outerPolygonShape = CAShapeLayer()
    fileprivate var innerPolygonShape = CAShapeLayer()
    fileprivate var arrayOfLabels = [UILabel]()
    fileprivate var myStatistics: MyStatistics
    fileprivate var cardType: MyStatisticsType

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics, cardType: MyStatisticsType) {
        self.myStatistics = myStatistics
        self.cardType = cardType

        super.init(frame: frame)

        makeSleepChart()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension SleepChartView {

    func makeSleepChart() {
        createDayLabel()
        lineBounds(isDataPoint: false)
        lineBounds(isDataPoint: true)
        drawShape()
    }

    var sleepChartYPos: CGFloat {
        return frame.height / 5.0
    }

    /// FIXME: REFACTORME This func is actually used to parts from the backgrounds and the userDataPoints.
    /// - isDataPoint will tell us what to draw.
    /// 
    /// FIX: That function have to breake down and put a part. The logic should be divided. 
    /// There also extensions for drawing lines in the extension file, we should use them.
    func lineBounds(cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, isDataPoint: Bool) {
        precondition(myStatistics.dataPoints.isEmpty == false, "No Data available")

        let tempWidth = frame.width - frame.width / 3
        let yPos = sleepChartYPos
        let rect = CGRect(x: tempWidth / 4, y: yPos, width: tempWidth, height: frame.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / 5
        let width = min(frame.width, frame.height)
        let startPoint = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        var angle = CGFloat(rotationOffset)

        for (index, dataPoint) in myStatistics.dataPoints.enumerated() {
            angle += theta
            let length: CGFloat

            if isDataPoint == true {
                length = (width / 2.0 ) * dataPoint.value.toFloat
            } else {
                length = (width / 2.0 )
                let corner = CGPoint(x: startPoint.x + length * cos(angle), y: startPoint.y + length * sin(angle))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                let frame = CGRect(x: end.x, y: end.y, width: 15, height: 10)
                frameForLabels(frame: frame, center: startPoint, index: index)
            }

            let corner = CGPoint(x: startPoint.x + length * cos(angle), y: startPoint.y + length * sin(angle))
            let endPoint = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            let average = myStatistics.teamAverage.toFloat
            let color = lineColor(value: dataPoint.value.toFloat, average: average)
            drawLines(startPoint: startPoint, endPoint: endPoint, color: color, isDataPoint: isDataPoint)
        }
    }

    func lineColor(value: CGFloat, average: CGFloat) -> UIColor {
        return value <= average ? .cherryRed : .white
    }

    func frameForLabels(frame: CGRect, center: CGPoint, index: Int) {
        let space: CGFloat = 4

        if frame.minX >= center.x {
            if frame.minY >= center.y {
                arrayOfLabels[index].frame = CGRect(x: frame.minX, y: frame.minY + space, width: frame.width, height: frame.height)
            } else {
                arrayOfLabels[index].frame = CGRect(x: frame.minX + space, y: frame.minY - frame.height, width: frame.width, height: frame.height)
            }
        } else {
            if frame.minY >= center.y {
                arrayOfLabels[index].frame = CGRect(x: frame.minX - frame.width - space, y: frame.minY, width: frame.width, height: frame.height)
            } else {
                arrayOfLabels[index].frame = CGRect(x: frame.minX - frame.width - space, y: frame.minY - frame.height / 2, width: frame.width, height: frame.height)
            }
        }
    }

    func drawLines(startPoint: CGPoint, endPoint: CGPoint, color: UIColor, isDataPoint: Bool) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
        line.path = linePath.cgPath

        if isDataPoint == true {
            line.lineWidth = 4
            line.lineDashPattern = cardType == .sleepQuantity ? [1.5, 1] : nil
            line.lineCap = cardType == .sleepQuantity ? kCALineCapButt : kCALineCapRound
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
        outerPolygonShape = shape(borderColor: .white20)
        outerPolygonShape.path = UIBezierPath.pentagonPath(forRect: frame).cgPath
        outerPolygonShape.transform = CATransform3DMakeTranslation(0, sleepChartYPos, 0)

        innerPolygonShape = shape(borderColor: .white20)
        let scaleFactor = CGFloat(myStatistics.teamAverage)
        let innerFrame = frame.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        innerPolygonShape.path = UIBezierPath.pentagonPath(forRect: innerFrame).cgPath
        innerPolygonShape.transform = CATransform3DMakeTranslation(
            frame.midX - innerFrame.midX,
            frame.midY - innerFrame.midY + sleepChartYPos,
            0)

        layer.addSublayer(innerPolygonShape)
        layer.addSublayer(outerPolygonShape)
    }

    func createDayLabel() {
        for index in 0..<5 {
            arrayOfLabels.append(dayLabel())
            arrayOfLabels[index].text = days[index]
            addSubview(arrayOfLabels[index])
        }
    }

    var days: [String] {
        let formatter = DateFormatter()
        let day = formatter.veryShortStandaloneWeekdaySymbols
        let temDay = day?.first

        guard var days = day, let temp = temDay else {
            preconditionFailure("day empty")
        }
        days.removeFirst()
        days.append(temp)
        
        return days
    }

    func dayLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.bentonBookFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = .white20
        
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
