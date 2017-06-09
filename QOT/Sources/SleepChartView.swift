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

        var sites: Int {
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
        lineBounds(chartType: chartType, data: data, average: average)
        drawShape(chartType: chartType)
        configureInnerPolygon(average: average)
    }

    private func drawShape(chartType: ChartType) {
        outerPolygonShape = shape(borderColor: chartType.borderColor)
        outerPolygonShape.path = UIBezierPath.roundedPolygonPath(rect: bounds, lineWidth: chartType.borderWidth, sides: chartType.sites).cgPath

        innerPolygonShape = shape(borderColor: chartType.borderColor)
        centerPolygonShape = shape(borderColor: chartType.borderColor, fillColor: .greyish20)
        centerPolygonShape.path = UIBezierPath.roundedPolygonPath(rect: bounds, lineWidth: chartType.borderWidth, sides: chartType.sites, radius: 10).cgPath

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
        innerPolygonShape.path = UIBezierPath.roundedPolygonPath(rect: bounds, lineWidth: 1, sides: 5, radius: radius).cgPath
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
        layer.addSublayer(line)
    }

    private func lineBounds(chartType: ChartType, data: [CGFloat], average: CGFloat) {
        precondition(data.isEmpty == false, "No Data available")

        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(chartType.sites)
        let width = min(frame.size.width, frame.size.height)
        let center = CGPoint(x: frame.origin.x + width / 2.0, y: frame.origin.y + width / 2.0)
        var angle: CGFloat = 0

        for index in 0..<chartType.sites {
            angle += theta
            let length = (bounds.width / 2.2 ) * data[index]
            let corner = CGPoint(x: center.x + ( length ) * cos(angle), y: center.y + (length ) * sin(angle))
            let end = CGPoint(x: corner.x * cos(angle + theta), y: corner.y * sin(angle + theta))
            drawLines(chartType: chartType, center: center, end: end, color: chartType.lineColor(value: data[index], average: average))
        }
    }
}
