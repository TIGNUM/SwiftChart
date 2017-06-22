//
//  PolygonChart.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 6/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SleepChartView: UIView {

    fileprivate var outerPolygonShape = CAShapeLayer()
    fileprivate var innerPolygonShape = CAShapeLayer()
    fileprivate var centerPolygonShape = CAShapeLayer()
    fileprivate var arrayOfLabels = [UILabel]()
    fileprivate var dataModel: MyStatisticsDataSleepView

    init(frame: CGRect, data: MyStatisticsDataSleepView) {
        self.dataModel = data
        super.init(frame: frame)
        makeSleepChart()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SleepChartView {

     func configureInnerPolygon() {
        let radius = (min(bounds.width, bounds.height) / 2.0) * dataModel.threshold
        innerPolygonShape.path = roundedPolygonPath(lineWidth: 0, radius: radius).cgPath
    }

    func roundedPolygonPath( lineWidth: CGFloat, cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, radius: CGFloat = -1) -> UIBezierPath {
        let path = UIBezierPath()
        let tempWidth = frame.width - frame.width / 3
        let y = tempWidth / 5
        let x = tempWidth / 4
        let rect = CGRect(x: x, y: y, width: tempWidth, height: frame.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(dataModel.chartType.sides)
        let width = tempWidth
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        let radius = radius != -1 ? radius :(width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        var angle = CGFloat(rotationOffset)

        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))

        for _ in 0..<dataModel.chartType.sides {
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

    func lineBounds(cornerRadius: CGFloat = 0, rotationOffset: CGFloat = 0, thinLines: Bool) {
        precondition(dataModel.data.isEmpty == false, "No Data available")

        let tempWidth = frame.width - frame.width / 3
        let y =  frame.height / 5
        let rect = CGRect(x: tempWidth / 4, y: y, width: tempWidth, height: frame.height)
        let theta: CGFloat = CGFloat(2.0 * CGFloat.pi) / CGFloat(dataModel.chartType.sides)
        let width = min(frame.width, frame.height)
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        var angle = CGFloat(rotationOffset)

        for index in 0..<dataModel.chartType.sides {
            angle += theta
            let length: CGFloat
            if thinLines != true {
                length = (width / 2.0 ) * dataModel.data[index]
            } else {
                length = (width / 2.0 )
                let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                let frame = CGRect(x: end.x, y: end.y, width: 15, height: 10)
                frameForLabels(frame: frame, center: center, index: index)
            }

            let corner = CGPoint(x: center.x + (length) * cos(angle), y: center.y + (length) * sin(angle))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            drawLines( center: center, end: end, color: dataModel.chartType.lineColor(value: dataModel.data[index], average: dataModel.threshold), thinLines: thinLines)
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
            line.strokeColor = dataModel.chartType.borderColor.cgColor
        }

        if dataModel.chartType == .qualitySleep {
            line.lineCap = kCALineCapRound
        }

        line.addGlowEffect(color: .white)
        layer.addSublayer(line)
    }

    func drawShape() {
        outerPolygonShape = shape(borderColor: dataModel.chartType.borderColor)
        outerPolygonShape.path =  roundedPolygonPath(lineWidth: dataModel.chartType.borderWidth).cgPath

        innerPolygonShape = shape(borderColor: dataModel.chartType.borderColor)
        centerPolygonShape = shape(borderColor: dataModel.chartType.borderColor, fillColor: .gray)
        centerPolygonShape.path = roundedPolygonPath( lineWidth: dataModel.chartType.borderWidth, radius: 5).cgPath

        layer.addSublayer(innerPolygonShape)
        layer.addSublayer(outerPolygonShape)
        layer.addSublayer(centerPolygonShape)

    }

    func createDayLabel() {

        for index in 0..<dataModel.chartType.sides {
            arrayOfLabels.append(dayLabel())
            arrayOfLabels[index].text = dataModel.chartType.days[index]
            addSubview(arrayOfLabels[index])
        }
    }

    func dayLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.bentonBookFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = dataModel.chartType.borderColor
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
        configureInnerPolygon()
    }

}
