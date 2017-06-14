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

    init(frame: CGRect, data: [CGFloat], average: CGFloat, chartType: ChartType) {
        super.init(frame: frame)

        makeSleepChart(frame: frame, data: data, average: average, chartType: chartType)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeSleepChart(frame: CGRect, data: [CGFloat], average: CGFloat, chartType: ChartType) {
        lineBounds(rect: frame, data: data, sides: chartType.sides, chartType: chartType, average: average)
        drawShape(chartType: chartType)
        configureInnerPolygon(average: average)
    }

    private func drawShape(chartType: ChartType) {
        outerPolygonShape = shape(borderColor: chartType.borderColor)
        outerPolygonShape.path =  roundedPolygonPath(rect: bounds, lineWidth: chartType.borderWidth, sides: chartType.sides).cgPath

        innerPolygonShape = shape(borderColor: chartType.borderColor)
        centerPolygonShape = shape(borderColor: chartType.borderColor, fillColor: .greyish20)
        centerPolygonShape.path = roundedPolygonPath(rect: bounds, lineWidth: chartType.borderWidth, sides: chartType.sides, radius: 10).cgPath

        layer.addSublayer(innerPolygonShape)
        layer.addSublayer(outerPolygonShape)
        layer.addSublayer(centerPolygonShape)
    }

    private func shape(borderColor: UIColor, fillColor: UIColor = .clear) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = borderColor.cgColor
        shape.fillColor = fillColor.cgColor
        return shape
    }

    func configureInnerPolygon(average: CGFloat) {
        let radius = (bounds.width / 2) * average
        innerPolygonShape.path = roundedPolygonPath(rect: bounds, lineWidth: 1, sides: 5, radius: radius).cgPath
    }

    private func drawLines(chartType: ChartType, center: CGPoint, end: CGPoint, color: UIColor) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: center)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.lineWidth = 4
        line.lineDashPattern = [1.5, 1]

        if chartType == .quality {
            line.lineCap = kCALineCapRound
        }

        line.strokeColor = color.cgColor
        line.addGlowEffect(color: .white)
        layer.addSublayer(line)
    }

    private func lineBounds(rect: CGRect, data: [CGFloat], sides: NSInteger, cornerRadius: CGFloat = 0, chartType: ChartType, average: CGFloat) {
        precondition(data.isEmpty == false, "No Data available")
        let tempWidth = rect.width - rect.width / 3
        let y =  tempWidth / 5
        let x = tempWidth / 4
        let rect = CGRect(x: x, y: y, width: tempWidth, height: rect.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(sides)
        let width = tempWidth
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        var angle = CGFloat(0)

        for index in 0..<sides {
            angle += theta
            let length = (width / 2.0 ) * data[index]
            let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            drawLines(chartType: chartType, center: center, end: end, color: chartType.lineColor(value: data[index], average: average))
        }
    }

    private func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, radius: CGFloat = -1) -> UIBezierPath {
        let path = UIBezierPath()
        let tempWidth = rect.width - rect.width / 3
        let y = rect.height / 5
        let rect = CGRect(x: tempWidth / 4, y: y, width: tempWidth, height: rect.height)
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
    
}
