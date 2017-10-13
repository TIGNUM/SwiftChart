//
//  MeetingsLengthChart.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MeetingsLengthChart: UIView {

    // MARK: - Properties

    fileprivate var statistics: Statistics
    fileprivate var labelContentView: UIView
    fileprivate let padding: CGFloat = 8

    // MARK: - Init

    init(frame: CGRect, statistics: Statistics, labelContentView: UIView) {
        self.statistics = statistics
        self.labelContentView = labelContentView

        super.init(frame: frame)

        drawCharts()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension MeetingsLengthChart {

    func drawCharts() {
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let radius = CGFloat(frame.height * 0.4)// * 0.75
        let strokeColor = UIColor.white20
        let innerRadius = radius * 0.6
        let outerRadius = CGFloat(frame.height * 0.4)
        let lineWidth = CGFloat(5)
        let dashPattern: [CGFloat] = [1, 1]
        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)
        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, strokeColor: strokeColor)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, strokeColor: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColor: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, value: statistics.userAverageValue, strokeColor: statistics.pathColor, hasShadow: true)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: outerRadius, angle: statistics.teamAngle, strokeColor: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: outerRadius, angle: statistics.dataAngle, strokeColor: .cherryRed)
        drawSolidLine(from: horizontalFrom, to: horizontalTo, strokeColor: strokeColor)
        drawSolidLine(from: verticalFrom, to: verticalTo, strokeColor: strokeColor)
    }
}
