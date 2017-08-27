//
//  AverageMeetingProgressWheel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 12/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class AverageMeetingProgressWheel: UIView {

    // MARK: - Properties

    fileprivate let pathColor: UIColor
    fileprivate let lineWidth: CGFloat
    fileprivate let userValue: CGFloat
    fileprivate let teamValue: CGFloat
    fileprivate let dataValue: CGFloat
    fileprivate let dashPattern: [CGFloat]

    // MARK: - Init

    init(frame: CGRect,
         userValue: CGFloat,
         teamValue: CGFloat,
         dataValue: CGFloat,
         pathColor: UIColor,
         dashPattern: [CGFloat] = [1, 1],
         lineWidth: CGFloat = 5) {
            self.pathColor = pathColor
            self.lineWidth = lineWidth
            self.userValue = userValue
            self.teamValue = teamValue
            self.dataValue = dataValue
            self.dashPattern = dashPattern

            super.init(frame: frame)

            draw(frame: frame, userValue: userValue)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.removeAllSublayer()
        draw(frame: frame, userValue: userValue)
    }
}

// MARK: - Private

private extension AverageMeetingProgressWheel {

    func draw(frame: CGRect, userValue: CGFloat) {
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let radius = CGFloat(frame.height * 0.5)
        let strokeColor = UIColor.white20
        let innerRadius = radius * 0.6
        let dataAngle = Math.radians(360 * dataValue - 90)
        let teamAngle = Math.radians(360 * teamValue - 90)
        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: 1, strokeColour: strokeColor)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: dashPattern, strokeColour: strokeColor)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, angle: teamAngle, lineWidth: 1, strokeColour: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, angle: dataAngle, lineWidth: 1, strokeColour: .cherryRed)
        drawCapRoundCircle(center: arcCenter, radius: radius, value: userValue, lineWidth: lineWidth, strokeColour: pathColor)
    }
}
