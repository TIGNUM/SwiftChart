//
//  AverageMeetingLengthView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class AverageMeetingLengthView: UIView {

    // MARK: - Properties

    fileprivate let myStatistics: MyStatistics

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        drawProgressWheel(myStatistics: myStatistics)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        drawProgressWheel(myStatistics: myStatistics)
    }
}

// MARK: - Private

private extension AverageMeetingLengthView {

    func drawProgressWheel(myStatistics: MyStatistics) {
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5 + 40)
        let radius = CGFloat(frame.height * 0.5) * 0.75
        let strokeColor = UIColor.white20
        let innerRadius = radius * 0.6
        let outerRadius = CGFloat(frame.height * 0.5)
        let lineWidth = CGFloat(5)
        let dashPattern: [CGFloat] = [1, 1]
        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)
        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, strokeColour: strokeColor)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, strokeColour: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColour: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, value: myStatistics.userAverageValue, strokeColour: myStatistics.pathColor, hasShadow: true)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: outerRadius, angle: myStatistics.teamAngle, strokeColour: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: outerRadius, angle: myStatistics.dataAngle, strokeColour: .cherryRed)
        drawSolidLine(from: horizontalFrom, to: horizontalTo, strokeColour: strokeColor)
        drawSolidLine(from: verticalFrom, to: verticalTo, strokeColour: strokeColor)
    }
}
