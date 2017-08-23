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

    fileprivate var outerPolygonShape = CAShapeLayer()
    fileprivate var innerPolygonShape = CAShapeLayer()
    fileprivate var arrayOfLabels = [UILabel]()
    fileprivate var myStatistics: MyStatistics
    fileprivate var cardType: MyStatisticsCardType

    init(frame: CGRect, myStatistics: MyStatistics, cardType: MyStatisticsCardType) {
        self.myStatistics = myStatistics
        self.cardType = cardType

        super.init(frame: frame)

        makeSleepChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SleepChartView {

    var sleepChartYPos: CGFloat {
        return frame.height / 5.0
    }

    func lineBounds(cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, thinLines: Bool) {
        precondition(myStatistics.dataPoints.isEmpty == false, "No Data available")

        let tempWidth = frame.width - frame.width / 3
        let y =  sleepChartYPos
        let rect = CGRect(x: tempWidth / 4, y: y, width: tempWidth, height: frame.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(5)
        let width = min(frame.width, frame.height)
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        var angle = CGFloat(rotationOffset)

        for index in 0..<5 {
            angle += theta
            let length: CGFloat
            if thinLines != true {
                length = (width / 2.0 ) * CGFloat(myStatistics.dataPoints[index].value)
            } else {
                length = (width / 2.0 )
                let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                let frame = CGRect(x: end.x, y: end.y, width: 15, height: 10)
                frameForLabels(frame: frame, center: center, index: index)
            }

            let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            drawLines( center: center, end: end, color: lineColor(value: CGFloat(myStatistics.dataPoints[index].value), average: CGFloat(myStatistics.teamAverage)), thinLines: thinLines)
        }
    }

    func lineColor(value: CGFloat, average: CGFloat) -> UIColor {
        return value <= average ? .cherryRed : .white
    }

    func frameForLabels(frame: CGRect, center: CGPoint, index: Int) {
        let space: CGFloat  = 4
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

    func drawLines(center: CGPoint, end: CGPoint, color: UIColor, thinLines: Bool) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: center)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        if thinLines != true {
            line.lineWidth = 4
            line.lineDashPattern = [1.5, 1]
            line.strokeColor = color.cgColor
        } else {
            line.lineWidth = 1.0
            line.lineDashPattern = [0.5, 2.0]
            line.lineJoin = kCALineJoinRound
            line.strokeColor = UIColor.white20.cgColor
        }

        if myStatistics.key == "Sleep.Quality" {
            line.lineCap = kCALineCapRound
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

    func makeSleepChart() {
        createDayLabel()
        lineBounds(thinLines: true)
        lineBounds(thinLines: false)
        drawShape()
    }

}

// MARK: - UIBezierPath helper

private extension UIBezierPath {
    
    class func pentagonPath(forRect rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(polygonIn: rect, sides: 5, lineWidth: 0, cornerRadius: 0, rotateByDegs: 90 / 5)
        return path
    }
}
