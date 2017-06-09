//
//  MeetingLengthChartView.swift
//  DashedProgressWheel
//
//  Created by Type-IT on 09.05.2017.
//  Copyright © 2017 Type-IT. All rights reserved.
//

import UIKit

class MeetingLengthChartView: UIView {

    private var ownInnerValue: CGFloat?
    private var ownOuterValue: CGFloat?
    private var ownInnerColor: UIColor?
    private var ownOuterColor: UIColor?
    private let chartBacgroundColor = UIColor(white: 1, alpha: 0.2)

    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { $0.removeFromSuperview() }

        configure(innerValue: ownInnerValue ?? 0, innerColor: ownInnerColor ?? UIColor.gray, outerValue: ownOuterValue ?? 0, outerColor: ownOuterColor ?? UIColor.gray)
    }

    func configure(innerValue: CGFloat, innerColor: UIColor, outerValue: CGFloat, outerColor: UIColor) {

        ownInnerValue = innerValue
        ownInnerColor = innerColor
        ownOuterValue = outerValue
        ownOuterColor = outerColor

        let backgroundFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let outerBackgroundView = DashedProgressWheel(frame: backgroundFrame, value: 1.0, pathColor: chartBacgroundColor, dashPattern: [2, 4], lineWidth: 15)

        let outerViewFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        let outerView = DashedProgressWheel(frame: outerViewFrame, value: CGFloat(outerValue), pathColor: outerColor, dashPattern: [2, 4], lineWidth: 15)

        let innerBackgroundFrame = CGRect(x: frame.width / 4, y: frame.height / 4, width: frame.width / 2, height: frame.height / 2)
        let innerBackgroundView = DashedProgressWheel(frame: innerBackgroundFrame, value: 1.0, pathColor: chartBacgroundColor, dashPattern: [2, 4], lineWidth: 10)

        let innerViewFrame = CGRect(x: frame.width / 4, y: frame.height / 4, width: frame.width / 2, height: frame.height / 2)
        let innerView = DashedProgressWheel(frame: innerViewFrame, value: CGFloat(innerValue), pathColor: innerColor, dashPattern: [2, 4], lineWidth: 10)

        self.addSubview(outerBackgroundView)
        self.addSubview(outerView)
        self.addSubview(innerBackgroundView)
        self.addSubview(innerView)
    }
}
