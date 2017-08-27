//
//  TravelMaxTimeZoneChangesView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class TravelMaxTimeZoneChangesView: UIView {

    // MARK: - Properties

    fileprivate let myStatistics: MyStatistics

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics
        
        super.init(frame: frame)

        drawProgressWheel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TravelMaxTimeZoneChangesView {

    func drawProgressWheel() {
        let lineWidth: CGFloat = 5
        let radius = CGFloat(frame.height * 0.5) * 0.9
        let circlePointRadius: CGFloat = lineWidth * 0.5
        let circlePointPositionRadius: CGFloat = radius - lineWidth - circlePointRadius

        guard circlePointRadius > 0 else {
            return
        }

        let dashPattern: [CGFloat] = [1, 1]
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5 + 40)
        let strokeColour = UIColor.white20
        let outerRadius = CGFloat(frame.height * 0.5)
        let dataCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: myStatistics.dataAngle)
        let teamCenter = Math.pointOnCircle(center: arcCenter, withRadius: circlePointPositionRadius, andAngle: myStatistics.teamAngle)
        let lineSemiLength = frame.height / 10
        let horizontalFrom = CGPoint(x: arcCenter.x - lineSemiLength, y: arcCenter.y)
        let horizontalTo = CGPoint(x: arcCenter.x + lineSemiLength, y: arcCenter.y)
        let verticalFrom = CGPoint(x: arcCenter.x, y: arcCenter.y - lineSemiLength)
        let verticalTo = CGPoint(x: arcCenter.x, y: arcCenter.y + lineSemiLength)

        drawSolidCircle(arcCenter: arcCenter, radius: outerRadius, lineWidth: 1, strokeColour: strokeColour)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColour: strokeColour)
        drawCapRoundCircle(center: arcCenter, radius: radius, value: myStatistics.userAverageValue, startAngle: -90, lineWidth: lineWidth, strokeColour: myStatistics.pathColor)
        drawSolidCircle(arcCenter: dataCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColour: .cherryRed)
        drawSolidCircle(arcCenter: teamCenter, radius: circlePointRadius, lineWidth: circlePointRadius, value: 1, startAngle: -90, strokeColour: .azure)
        drawSolidLine(from: horizontalFrom, to: horizontalTo, lineWidth: 1, strokeColour: strokeColour)
        drawSolidLine(from: verticalFrom, to: verticalTo, lineWidth: 1, strokeColour: strokeColour)
    }
}
