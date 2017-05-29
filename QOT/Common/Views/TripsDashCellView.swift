//
//  TripsDashCellView.swift
//  QOT
//
//  Created by Type-IT on 11.05.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class TripsDashCellView: UIView {

    private var ownDay: Day?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        configure(day: ownDay!)
    }

    func configure(day: Day) {
        ownDay = day

        for event in day.events {
            draw(startValue: event.start, endValue: event.end, color: event.color)
        }
    }

    func draw(startValue: CGFloat, endValue: CGFloat, color: UIColor) {
        let x = startValue * bounds.width
        let width = endValue * bounds.width - x


        let layer = CALayer()
        layer.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = bounds.height / 2

        self.layer.addSublayer(layer)
    }
}

struct Day {
    let events: [Event]
}
