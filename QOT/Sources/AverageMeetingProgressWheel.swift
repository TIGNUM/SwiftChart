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

    fileprivate let statistics: MyStatistics
    fileprivate let lineWidth: CGFloat = 5

    // MARK: - Init

    init(frame: CGRect, statistics: MyStatistics) {
        self.statistics = statistics

        super.init(frame: frame)

        drawMeetingProgressWheel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.removeAllSublayer()
        drawMeetingProgressWheel()
    }
}

// MARK: - Private

private extension AverageMeetingProgressWheel {

    func drawMeetingProgressWheel() {
        let arcCenter = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        let radius = CGFloat(frame.height * 0.5)        
        let innerRadius = radius * 0.6
        drawSolidCircle(arcCenter: arcCenter, radius: innerRadius, lineWidth: 1, strokeColour: .white20)
        drawDashedCircle(arcCenter: arcCenter, radius: radius, lineWidth: lineWidth, dashPattern: [1, 1], strokeColour: .white20)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, angle: statistics.teamAngle, lineWidth: 1, strokeColour: .azure)
        drawAverageLine(center: arcCenter, innerRadius: innerRadius, outerRadius: radius, angle: statistics.dataAngle, lineWidth: 1, strokeColour: .cherryRed)
        drawCapRoundCircle(center: arcCenter, radius: radius, value: statistics.userAverageValue, lineWidth: lineWidth, strokeColour: statistics.pathColor)
    }
}
