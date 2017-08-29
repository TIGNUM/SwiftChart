//
//  IntensityView.swift
//  QOT
//
//  Created by karmic on 24.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class IntensityView: UIView {

    // MARK: - Properties

    fileprivate let labelContainer = UIView()
    fileprivate let myStatistics: MyStatistics
    fileprivate let displayType: DataDisplayType
    fileprivate let myStatisticsType: MyStatisticsType

    fileprivate lazy var columnWidth: CGFloat = {
        return self.displayType == .week ? CGFloat(10) : self.frame.width / CGFloat(self.myStatistics.dataPointObjects.count * 2)
    }()

    // MARK: - Init

    init(frame: CGRect, myStatistics: MyStatistics, displayType: DataDisplayType, myStatisticsType: MyStatisticsType) {
        self.myStatistics = myStatistics
        self.displayType = displayType
        self.myStatisticsType = myStatisticsType

        super.init(frame: frame)

        setupView()
        drawCharts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - View Setup

private extension IntensityView {

    func setupView() {
        setupLabels()
        setupBackground()
    }

    private func setupBackground() {
        let numberOfLines = 10
        let lineWidth = CGFloat(0.5)
        let distance = (frame.height - labelContainer.frame.height) / CGFloat(numberOfLines)

        for index in 0 ..< numberOfLines {
            let yOffset = distance * CGFloat(index)
            let startPoint = CGPoint(x: 0, y: yOffset)
            let endPoint = CGPoint(x: frame.width, y: yOffset)

            if Int(myStatistics.upperThreshold.toFloat * CGFloat(numberOfLines)) == index {
                drawDashedLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColour: .white20, dashPattern: [1.5, 3.0])
            } else {
                drawSolidLine(from: startPoint, to: endPoint, lineWidth: lineWidth, strokeColour: .white20)
            }
        }
    }

    private func setupLabels() {
        addSubview(labelContainer)
        labelContainer.leadingAnchor == leadingAnchor
        labelContainer.trailingAnchor == trailingAnchor
        labelContainer.bottomAnchor == bottomAnchor
        labelContainer.heightAnchor == 20
        let startPoint = CGPoint(x: frame.origin.x, y: 0)
        let endPoint = CGPoint(x: frame.width, y: 0)
        let labels = generateLabels(type: displayType)
        labelContainer.drawSolidLine(from: startPoint, to: endPoint, strokeColour: .white20)
        labelContainer.drawLabelsForColumns(labels: labels,
                                            columnCount: labels.count,
                                            textColour: .white20,
                                            font: Font.H7Title,
                                            center: true)
        layoutIfNeeded()
    }

    private func generateLabels(type: DataDisplayType) -> [String] {
        switch type {
        case .week: return weekdays()
        case .month: return weekNumbers()
        default: return []
        }
    }

    private func weekNumbers() -> [String] {
        var weekNumbers = [String]()
        var currentWeekNumber = Calendar.current.component(.weekOfYear, from: Date())

        for _ in 0 ..< 4 {
            currentWeekNumber = currentWeekNumber - 1

            if currentWeekNumber <= 0 {
                currentWeekNumber = 52
            }

            weekNumbers.append(String(format: "%d", currentWeekNumber))
        }
        
        return weekNumbers.reversed()
    }

    private func weekdays() -> [String] {
        let formatter = DateFormatter()
        let currentWeekday = Calendar.current.component(.weekday, from: Date())

        guard var weekdaySymbols = formatter.veryShortWeekdaySymbols else {
            return []
        }

        weekdaySymbols = Array(weekdaySymbols[currentWeekday - 1 ..< weekdaySymbols.count]) + weekdaySymbols[0 ..< currentWeekday - 1]

        return weekdaySymbols.reversed()
    }
}

// MARK: - Draw Charts

private extension IntensityView {

    func drawCharts() {
        for (index, dataPointObject) in myStatistics.dataPointObjects.enumerated() {
            let bottomPos = frame.height - labelContainer.frame.height
            let xPos = xPosition(index: index, columnWidth: columnWidth)
            let yPos = dataPointObject.value > 0 ? (bottomPos * dataPointObject.value) : bottomPos
            let columnFrame = CGRect(x: xPos, y: bottomPos, width: columnWidth, height: yPos - bottomPos)
            let column = UIView(frame: columnFrame)
            column.backgroundColor = .white8
            column.layer.cornerRadius = myStatisticsType == .intensityLoad ? 5 : 0
            column.layer.borderWidth = displayType == .week ? 0.5 : 0.2
            column.layer.borderColor = dataPointObject.color.cgColor
            column.layer.masksToBounds = true
            addSubview(column)
        }
    }

    private func xPosition(index: Int, columnWidth: CGFloat) -> CGFloat {
        if displayType == .week {
            let labelFrame = labelContainer.subviews[index].frame

            return (labelFrame.origin.x + labelFrame.width * 0.5) - (columnWidth * 0.5)
        }

        return columnWidth * CGFloat(index) * 2
    }
}
