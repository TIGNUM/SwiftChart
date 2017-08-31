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

private extension PeakPerformanceAverageProgressWheel {

    func drawProgressWheel() {
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
        let startPoint = CGPoint(x: frame.origin.x, y: frame.origin.y + frame.height)
        let endPoint = CGPoint(x: frame.origin.x + frame.width, y: frame.origin.y + frame.height)
        let userAverage = myStatistics.userAverage < myStatistics.maximum ? myStatistics.userAverageValue : CGFloat(1)
        
        drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth, strokeColour: strokeColour)
        drawDashedCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: discRadius, lineWidth: discRadius, startAngle: startAngle, endAngle: endAngle, strokeColour: .brownishGrey)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)
        drawSolidCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, value: userAverage, startAngle: startAngle, endAngle: endAngle, strokeColour: myStatistics.pathColor)
        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: strokeWidth, value: myStatistics.dataAverageValue, startAngle: 0, endAngle: startAngle, strokeColour: .cherryRed, clockwise: false)
    }
}
