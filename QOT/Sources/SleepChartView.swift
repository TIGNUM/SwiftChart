//
//  PolygonChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SleepChartView: UIView {

    enum ChartType {
        case quantity
        case quality

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
    }

    fileprivate var outerPolygonShape = CAShapeLayer()
    fileprivate var innerPolygonShape = CAShapeLayer()
    fileprivate var centerPolygonShape = CAShapeLayer()
    fileprivate var arrayOfLabels = [UILabel]()

    init(frame: CGRect, data: [CGFloat], average: CGFloat, chartType: ChartType, day: [String]) {
        super.init(frame: frame)

        makeSleepChart(frame: frame, data: data, average: average, chartType: chartType, day: day)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SleepChartView {

     func configureInnerPolygon(average: CGFloat) {
        let radius = (min(bounds.width, bounds.height) / 2.0) * average
        innerPolygonShape.path = roundedPolygonPath(rect: bounds, lineWidth: 0, sides: 5, radius: radius).cgPath
    }

    func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, radius: CGFloat = -1) -> UIBezierPath {
        let path = UIBezierPath()
        let tempWidth = rect.width - rect.width / 3
        let y = tempWidth / 5
        let x = tempWidth / 4
        let rect = CGRect(x: x, y: y, width: tempWidth, height: rect.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(sides)
        let width = tempWidth
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        let radius = radius != -1 ? radius :(width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        var angle = CGFloat(rotationOffset)

        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

        for _ in 0..<sides {
            angle += theta
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }

        path.close()
        return path
    }

    func lineBounds(rect: CGRect, data: [CGFloat], sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, chartType: ChartType, average: CGFloat, thinLines: Bool) {
        precondition(data.isEmpty == false, "No Data available")
        let tempWidth = rect.width - rect.width / 3
        let y =  rect.height / 5
        let rect = CGRect(x: tempWidth / 4, y: y, width: tempWidth, height: rect.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(sides)
        let width = min(bounds.width, bounds.height) 
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        var angle = CGFloat(rotationOffset)

        for index in 0..<sides {
            angle += theta
            let length: CGFloat
            if thinLines != true {
                length = (width / 2.0 ) * data[index]
            } else {
                length = (width / 2.0 )
                let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                let frame = CGRect(x: end.x, y: end.y, width: 15, height: 10)
                frameForLabels(frame: frame, center: center, index: index)
            }

            let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            drawLines(chartType: chartType, center: center, end: end, color: chartType.lineColor(value: data[index], average: average), thinLines: thinLines)
        }
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

    func drawLines(chartType: ChartType, center: CGPoint, end: CGPoint, color: UIColor, thinLines: Bool) {
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
            line.strokeColor = chartType.borderColor.cgColor
        }

        if chartType == .quality {
            line.lineCap = kCALineCapRound
        }

        line.addGlowEffect(color: .white)
        layer.addSublayer(line)
    }

    func drawShape(chartType: ChartType, average: CGFloat) {
        outerPolygonShape = shape(borderColor: chartType.borderColor)
        outerPolygonShape.path =  roundedPolygonPath(rect: bounds, lineWidth: chartType.borderWidth, sides: chartType.sides).cgPath

        innerPolygonShape = shape(borderColor: chartType.borderColor)
        centerPolygonShape = shape(borderColor: chartType.borderColor, fillColor: .gray)
        centerPolygonShape.path = roundedPolygonPath(rect: bounds, lineWidth: chartType.borderWidth, sides: chartType.sides, radius: 5).cgPath

        layer.addSublayer(innerPolygonShape)
        layer.addSublayer(outerPolygonShape)
        layer.addSublayer(centerPolygonShape)

    }

    func createDayLabel( chartType: ChartType, day: [String]) {

        for index in 0..<chartType.sides {
            arrayOfLabels.append(dayLabel(chartType: chartType))
            arrayOfLabels[index].text = day[index]
            addSubview(arrayOfLabels[index])
        }
    }

    func dayLabel(chartType: ChartType) -> UILabel {
        let label = UILabel()
        label.font = UIFont.bentonBookFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = chartType.borderColor
        return label
    }

    func shape(borderColor: UIColor, fillColor: UIColor = .clear) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = borderColor.cgColor
        shape.fillColor = fillColor.cgColor
        return shape
    }

    func makeSleepChart(frame: CGRect, data: [CGFloat], average: CGFloat, chartType: ChartType, day: [String]) {
        createDayLabel(chartType: chartType, day: day)
        lineBounds(rect: frame, data: data, sides: chartType.sides, chartType: chartType, average: average, thinLines: true)
        lineBounds(rect: frame, data: data, sides: chartType.sides, chartType: chartType, average: average, thinLines: false)
        drawShape(chartType: chartType, average: average)
        configureInnerPolygon(average: average)
    }
}
