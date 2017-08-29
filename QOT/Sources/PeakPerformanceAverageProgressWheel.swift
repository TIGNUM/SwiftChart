//
//  PeakPerformanceAverageProgressWheel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 15/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class PeakPerformanceAverageProgressWheel: UIView {

    // MARK: - Properties

    fileprivate var myStatistics: MyStatistics

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        draw(frame: frame, value: myStatistics.userAverageValue)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.removeAllSublayer()
        
        draw(frame: frame, value: myStatistics.userAverageValue)
    }
}

// MARK: - Private

private extension PeakPerformanceAverageProgressWheel {

    func draw(frame: CGRect, value: CGFloat) {
        let lineWidth = CGFloat(10)
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height)
        let radius = CGFloat(frame.height * 0.8)
        let strokeColour = UIColor.white20
        let startAngle = CGFloat(-180)
        let endAngle = CGFloat(180)
        let strokeWidth: CGFloat = 1
        let innerRadius = radius * 0.5
        let outerRadius = radius - (lineWidth - strokeWidth) * 0.5
        let discRadius = radius * 0.1
        let startPoint = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height)
        let endPoint = CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y + self.frame.height)
        drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: discRadius, lineWidth: discRadius, startAngle: startAngle, endAngle: endAngle, strokeColour: .brownishGrey)
        drawDashedCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, value: value, startAngle: startAngle, endAngle: endAngle, strokeColour: myStatistics.pathColor)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, value: 1 - myStatistics.upperThreshold.toFloat, startAngle: 0, endAngle: startAngle, strokeColour: .cherryRed, clockwise: false)
    }
}
