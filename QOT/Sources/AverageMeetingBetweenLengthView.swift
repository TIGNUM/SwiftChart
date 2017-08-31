//
//  AverageMeetingBetweenLengthView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class AverageMeetingBetweenLengthView: UIView {

    // MARK: - Properties

    fileprivate var myStatistics: MyStatistics

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        drawProgressWheel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.removeAllSublayer()
        
        drawProgressWheel()
    }
}

// MARK: - Private

private extension AverageMeetingBetweenLengthView {

    func drawProgressWheel() {
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5 + 40)
        let radius = CGFloat(frame.height * 0.5)
        let strokeColor = UIColor.white20
        let lineWidth = CGFloat(12)
        let dashPattern: [CGFloat] = [1, 1]
        let innerRadius = radius * 0.6
        let underRadius = radius - lineWidth / 3

        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, strokeColour: strokeColor)
        drawSolidCircle(arcCenter: arcCenter, radius: underRadius, lineWidth: lineWidth * 0.5, strokeColour: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, value: myStatistics.userAverageValue, strokeColour: myStatistics.pathColor)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: myStatistics.teamAngle, strokeColour: .azure)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: myStatistics.dataAngle, strokeColour: .cherryRed)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: CGFloat(-90).degreesToRadians, strokeColour: strokeColor)
        drawAverageLine(center: arcCenter, outerRadius: radius, angle: myStatistics.userAngle, strokeColour: strokeColor)
    }
}
