//
//  DailyMeetingChartView.swift
//  DashedProgressWheel
//
//  Created by Type-IT on 09.05.2017.
//  Copyright © 2017 Type-IT. All rights reserved.
//

import UIKit

class DailyMeetingChartView: UIView {

    private var ownEvents: [Event]?
    private var ownLineWidth: CGFloat?
    private let chartBacgroundColor = UIColor(white: 1, alpha: 0.2)

    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { $0.removeFromSuperview() }
        configure(events: ownEvents ?? [], lineWidth: ownLineWidth ?? 15 )
    }

    func configure(events: [Event], lineWidth: CGFloat) {

        ownEvents = events
        ownLineWidth = lineWidth

        let viewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let outerBackgroundView = DashedProgressWheel(frame: viewFrame, value: 1.0, pathColor: chartBacgroundColor, dashPattern: [2, 4], lineWidth: 15)

        let newCircile = DayEventChartView(frame: CGRect(x: 0, y: 0, width: viewFrame.width, height: viewFrame.height))
        newCircile.configure(events: events, lineWidth: lineWidth)

        self.addSubview(outerBackgroundView)
        self.addSubview(newCircile)
    }
}
