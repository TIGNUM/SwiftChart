//
//  UpcomingTravelsChartView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 16/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class UpcomingTravelsChartView: UIView {

    private var data: UserUpcomingTrips

    init(frame: CGRect, data: UserUpcomingTrips) {
        self.data = data

        super.init(frame: frame)
        draw(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        draw(frame: frame)
    }

    private func draw(frame: CGRect) {
        let strokeColour = UIColor.white20
        let strokeWidth = CGFloat(1.0)
        let columns = 4
        let rows = 7
        let cellWidth = self.frame.width / CGFloat(columns)
        let cellHeight = self.frame.height / CGFloat(rows)
        let columnHeight = self.frame.height

        let startPoint = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + columnHeight)
        let endPoint = CGPoint(x: self.frame.origin.x + self.frame.width, y: self.frame.origin.y + columnHeight)

        drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth, strokeColour: strokeColour)
        drawColumns(columnWidth: cellWidth, columnHeight: columnHeight, rowHeight: cellHeight, columnCount: columns, rowCount: rows, strokeWidth: strokeWidth, strokeColour: strokeColour)

        var column = 0
        for week in data {
            drawTripsFor(column: column, tripCount: week, cellWidth: cellWidth, cellHeight: cellHeight, strokeWidth: strokeWidth)
            column += 1
        }
    }

    func drawTripsFor(column: Int, tripCount: [Int], cellWidth: CGFloat, cellHeight: CGFloat, strokeWidth: CGFloat) {
        let padding: CGFloat = 2
        let strokeColour = UIColor.white
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(360)

        let columnX = CGFloat(self.frame.origin.x) + CGFloat(column) * cellWidth + strokeWidth / 2
        var y = 0

        for count in tripCount {
            var radius = cellHeight / 4
            if count > 0 {
                if (padding + ((2 * radius + padding) * CGFloat(count))) > cellWidth {
                    radius = (cellWidth - CGFloat(count) * padding - padding) / CGFloat(count) / 2
                }

                let columnY = CGFloat(self.frame.origin.y) + (CGFloat(y) * cellHeight) + cellHeight / 2
                for i in 0..<count {
                    let arcCenter = CGPoint(x: columnX + radius + CGFloat(i) * (2 * radius) + CGFloat(i + 1) * padding, y: columnY)
                    drawSolidCircle(arcCenter: arcCenter, radius: radius, lineWidth: radius, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColour)
                }
            }
            y += 1
        }
    }
}
