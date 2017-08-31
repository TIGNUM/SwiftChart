//
//  UpcomingTravelsView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 15/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class UpcomingTravelsView: UIView {

    // MARK: - Properties

    fileprivate let myStatistics: MyStatistics
    fileprivate let labelContainer = UIView()
    fileprivate let chartContainer = UIView()
    fileprivate let columns: Int = 4
    fileprivate let rows: Int = 7
    fileprivate let padding: CGFloat = 8
    fileprivate let strokeWidth: CGFloat = 1

    fileprivate lazy var cellWidth: CGFloat = {
        return self.chartContainer.frame.width / CGFloat(self.columns)
    }()

    fileprivate lazy var cellHeight: CGFloat = {
        return self.chartContainer.frame.height / CGFloat(self.rows)
    }()

    fileprivate lazy var columnHeight: CGFloat = {
        return self.chartContainer.frame.height
    }()

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics) {
        self.myStatistics = myStatistics

        super.init(frame: frame)

        setupView()
        drawTrips()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension UpcomingTravelsView {

    func setupView() {
        setupLabels()
        setupChartContainerView()
        darwLabelTopLine()
        drawDottedBackground()
    }

    private func setupLabels() {
        let labels = ["+1", "+2", "+3", "+4"]
        addSubview(labelContainer)
        labelContainer.leadingAnchor == leadingAnchor + padding
        labelContainer.trailingAnchor == trailingAnchor - padding
        labelContainer.bottomAnchor == bottomAnchor
        labelContainer.heightAnchor == 20
        labelContainer.drawLabelsForColumns(labels: labels, columnCount: labels.count, textColour: .white20, font: UIFont.bentonBookFont(ofSize: 11))
        layoutIfNeeded()
    }

    private func setupChartContainerView() {        
        addSubview(chartContainer)
        chartContainer.topAnchor == topAnchor + padding * 2 + 1
        chartContainer.leadingAnchor == leadingAnchor + padding
        chartContainer.trailingAnchor == trailingAnchor - padding
        chartContainer.bottomAnchor == labelContainer.topAnchor - padding
        layoutIfNeeded()
    }

    private func darwLabelTopLine() {
        let startPoint = CGPoint(x: frame.origin.x + padding, y: frame.origin.y + frame.height - labelContainer.frame.height)
        let endPoint = CGPoint(x: frame.origin.x + frame.width - padding, y: frame.origin.y + frame.height - labelContainer.frame.height)
        drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth, strokeColour: .white20)
    }

    private func drawDottedBackground() {
        for x in 0 ..< columns {
            let columnX = CGFloat(chartContainer.frame.origin.x) + CGFloat(x) * cellWidth + strokeWidth * 0.5

            for y in 0 ..< rows {
                let columnY = CGFloat(chartContainer.frame.origin.y) + columnHeight - (CGFloat(y) * cellHeight) - cellHeight * 0.5
                let startPoint = CGPoint(x: columnX, y: columnY - strokeWidth * 0.5)
                let endPoint = CGPoint(x: columnX, y: columnY + strokeWidth * 0.5)
                drawSolidLine(from: startPoint, to: endPoint, lineWidth: strokeWidth * 0.5, strokeColour: .white20)
            }
        }
    }

    func drawTrips() {
        let padding: CGFloat = 2
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 360
        var yPos: CGFloat = 0
        var radius = cellHeight / 4

        for trips in myStatistics.userUpcomingTrips {
            if trips.value.count > 0 {
                if (padding + ((2 * radius + padding) * CGFloat(trips.value.count))) > cellWidth {
                    radius = (cellWidth - CGFloat(trips.value.count) * padding - padding) / CGFloat(trips.value.count) * 0.5
                }

                let week = CGFloat(trips.key / 7)
                let columnX = CGFloat(chartContainer.frame.origin.x) + week * cellWidth + strokeWidth * 0.5
                let columnY = CGFloat(chartContainer.frame.origin.y) + yPos * cellHeight + cellHeight * 0.5
                let strokeColor = trips.value.status.color

                for tripIndex in 0..<trips.value.count {                    
                    let arcCenter = CGPoint(x: columnX + radius + CGFloat(tripIndex) * (2 * radius) + CGFloat(tripIndex + 1) * padding, y: columnY)
                    drawSolidCircle(arcCenter: arcCenter, radius: radius, lineWidth: radius, startAngle: startAngle, endAngle: endAngle, strokeColour: strokeColor)
                }
            }
            yPos += 1
        }
    }
}
