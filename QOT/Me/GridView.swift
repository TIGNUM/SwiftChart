//
//  GridView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 5/9/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class GridView: UIView {

    private var verticleLines = [CALayer]()
    private var horizontalLines = [CALayer]()
    private var columnCount: Int = 1
    private var seperatorHeight: CGFloat = 0
    private var rowCount: Int = 1

    func configure(columnCount: Int, rowCount: Int, seperatorHeight: CGFloat, seperatorColor: UIColor) {
        precondition(columnCount > 0, "The minumum column count must be greater than 0")
        precondition(rowCount > 0, "The minumum row count must be greater than 0")

        self.columnCount = columnCount
        self.seperatorHeight = seperatorHeight
        self.rowCount = rowCount

        verticleLines = createLines(count: columnCount - 1, color: seperatorColor)
        horizontalLines = createLines(count: rowCount - 1, color: seperatorColor)
        layer.sublayers = [verticleLines, horizontalLines].flatMap { $0 }

        setNeedsDisplay()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutVerticalLines()
        layoutHorizontalLines()
    }

    private func createLines(count: Int, color: UIColor) -> [CALayer] {
        var lines: [CALayer] = []
        for _ in 0..<count {
            let line = CALayer()
            line.backgroundColor = color.cgColor
            lines.append(line)
        }
        return lines
    }

    private func layoutVerticalLines() {
        let space = bounds.width / CGFloat(columnCount)
        var x: CGFloat = (space - (seperatorHeight / 2))

        for layer in verticleLines {
            layer.frame = CGRect(x: x, y: 0, width: seperatorHeight, height: bounds.height)
            x = (x + space)
        }
    }

    private func layoutHorizontalLines() {
        let space = bounds.height / CGFloat(rowCount)
        var y: CGFloat = (space - (seperatorHeight / 2))

        for layer in horizontalLines {
            layer.frame = CGRect(x: 0, y: y, width: bounds.width, height: seperatorHeight)
            y = (y + space)
        }
    }
}
