//
//  EventLinesView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/4/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class HorizontalLinesChartView: UIView {

    fileprivate var lines = [CALayer]()
    fileprivate var rowCount: Int = 0
    fileprivate var seperatorHeight: CGFloat = 0
    fileprivate var seperatorColor: UIColor = .clear

    func setUp(rowCount: Int, seperatorHeight: CGFloat, seperatorColor: UIColor) {
        self.rowCount = rowCount
        self.seperatorHeight = seperatorHeight
        self.seperatorColor = seperatorColor

        createMissingSublayers()
        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        displayLines()
    }
}

// MARK: - Private

private extension HorizontalLinesChartView {

    func createMissingSublayers() {
        guard rowCount > lines.count else {
            return
        }

        let requiredLines = rowCount - 1
        for _ in 0..<requiredLines - lines.count {
            let layer = CALayer()
            lines.append(layer)
            self.layer.addSublayer(layer)
        }
    }

    func displayLines() {
        guard rowCount > 0 else {
            return
        }
        let space = bounds.height / CGFloat(rowCount)
        var y = (space - (seperatorHeight / 2))

        for layer in lines {
            layer.backgroundColor = seperatorColor.cgColor
            layer.frame = CGRect(x: 0, y: y, width: bounds.width, height: seperatorHeight)
            y = (y + space)
        }
    }
}
