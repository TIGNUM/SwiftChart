//
//  MeetingLengthChartView.swift
//  DashedProgressWheel
//
//  Created by Type-IT on 09.05.2017.
//  Copyright © 2017 Type-IT. All rights reserved.
//

import UIKit

class MeetingLengthChartView: UIView {

    private var ownInnerValue: Float?
    private var ownOuterValue: Float?
    private var ownInnerColor: UIColor?
    private var ownOuterColor: UIColor?
    private let chartBacgroundColor = UIColor(white: 1, alpha: 0.2)

    override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach { $0.removeFromSuperview() }

        configure(innerValue: ownInnerValue ?? 0, innerColor: ownInnerColor ?? UIColor.gray, outerValue: ownOuterValue ?? 0, outerColor: ownOuterColor ?? UIColor.gray)
    }

    func configure(innerValue: Float, innerColor: UIColor, outerValue: Float, outerColor: UIColor) {

        ownInnerValue = innerValue
        ownInnerColor = innerColor
        ownOuterValue = outerValue
        ownOuterColor = outerColor

        let outerBackgroundView = DashedProgressWheel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        outerBackgroundView.setup(value: 1.0, newPathColor: chartBacgroundColor, newDashPattern: [2, 4], newLineWidth: 15)

        let outerView = DashedProgressWheel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        outerView.setup(value: CGFloat(outerValue), newPathColor: outerColor, newDashPattern: [2, 4], newLineWidth: 15)

        let innerBackgroundView = DashedProgressWheel(frame: CGRect(x: frame.width / 4, y: frame.height / 4, width: frame.width / 2, height: frame.height / 2))
        innerBackgroundView.setup(value: 1.0, newPathColor: chartBacgroundColor, newDashPattern: [2, 4], newLineWidth: 10)

        let innerView = DashedProgressWheel(frame: CGRect(x: frame.width / 4, y: frame.height / 4, width: frame.width / 2, height: frame.height / 2))
        innerView.setup(value: CGFloat(innerValue), newPathColor: innerColor, newDashPattern: [2, 4], newLineWidth: 10)

        self.addSubview(outerBackgroundView)
        self.addSubview(outerView)
        self.addSubview(innerBackgroundView)
        self.addSubview(innerView)
    }
}
