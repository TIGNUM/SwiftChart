//
//  IntensityChartView.swift
//  QOT
//
//  Created by karmic on 24.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class IntensityChartView: UIView {

    // MARK: - Properties

    fileprivate var myStatistics: MyStatistics

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        draw(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension IntensityChartView {

    func draw(frame: CGRect) {
        let distance = self.frame.height / myStatistics.maximum.toFloat

        for index in 0...myStatistics.maximum.toInt - 1 {
            let yOffset = distance * CGFloat(index)
            let startPoint = CGPoint(x: 0, y: yOffset)
            let endPoint = CGPoint(x: self.frame.width, y: yOffset)
            let upperThreshold = myStatistics.upperThreshold * myStatistics.maximum

            if upperThreshold.toInt == index {
                drawDashedLine(from: startPoint, to: endPoint, lineWidth: CGFloat(0.5), strokeColour: .white20, dashPattern: [1.5, 3.0])
            } else {
                drawSolidLine(from: startPoint, to: endPoint, lineWidth: CGFloat(0.5), strokeColour: .white20)
            }
        }
    }
}
