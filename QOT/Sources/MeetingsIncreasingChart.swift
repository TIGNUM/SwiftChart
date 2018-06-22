//
//  MeetingsIncreasingChart.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 24/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

enum WeekDatapoint: Int {
    case lastWeek = 0
    case thisWeek = 1
}

final class MeetingsIncreasingChart: UIView {

    private let statistics: Statistics
    private let thisWeekNumberLabel = UILabel()
    private let thisWeekLabel = UILabel()
    private let lastWeekNumberLabel = UILabel()
    private let lastWeekLabel = UILabel()
    private let percentageLabel = UILabel()
    private let changeLabel = UILabel()
    private let firstSeparatorView = UIView()
    private let secondSeparatorView = UIView()

    init(frame: CGRect, statistics: Statistics) {
        self.statistics = statistics
        super.init(frame: frame)
        setupView()
        setData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
}

// MARK: - Private

private extension MeetingsIncreasingChart {

    func setupView() {
        addSubview(thisWeekNumberLabel)
        thisWeekNumberLabel.textColor = .white
        thisWeekNumberLabel.textAlignment = .center
        thisWeekNumberLabel.font = Font.H2SecondaryTitle

        addSubview(thisWeekLabel)
        thisWeekLabel.textColor = .gray
        thisWeekLabel.textAlignment = .center
        thisWeekLabel.font = Font.H7SectorTitle
        thisWeekLabel.addCharactersSpacing(spacing: 2, text: "THIS WEEK")

        addSubview(firstSeparatorView)
        firstSeparatorView.backgroundColor = .gray
        firstSeparatorView.layer.opacity = 0.6

        addSubview(lastWeekNumberLabel)
        lastWeekNumberLabel.textColor = .white
        lastWeekNumberLabel.textAlignment = .center
        lastWeekNumberLabel.font = Font.H2SecondaryTitle

        addSubview(lastWeekLabel)
        lastWeekLabel.textColor = .gray
        lastWeekLabel.textAlignment = .center
        lastWeekLabel.font = Font.H7SectorTitle
        lastWeekLabel.addCharactersSpacing(spacing: 2, text: "LAST WEEK")

        addSubview(secondSeparatorView)
        secondSeparatorView.backgroundColor = .gray
        secondSeparatorView.layer.opacity = 0.6

        addSubview(percentageLabel)
        percentageLabel.textColor = .green
        percentageLabel.textAlignment = .center
        percentageLabel.font = Font.H2SecondaryTitle

        addSubview(changeLabel)
        changeLabel.textColor = .gray
        changeLabel.textAlignment = .center
        changeLabel.font = Font.H7SectorTitle
        changeLabel.addCharactersSpacing(spacing: 2, text: "CHANGE")
    }

    func layout() {
        thisWeekNumberLabel.frame = CGRect(x: 0, y: -35, width: bounds.width, height: 30)
        thisWeekLabel.frame = CGRect(x: 0, y: thisWeekNumberLabel.frame.maxY + 5, width: bounds.width, height: 20)

        lastWeekNumberLabel.frame = CGRect(x: 0, y: thisWeekLabel.frame.maxY + 55, width: bounds.width, height: 30)
        lastWeekLabel.frame = CGRect(x: 0, y: lastWeekNumberLabel.frame.maxY + 5, width: bounds.width, height: 20)

        percentageLabel.frame = CGRect(x: 0, y: lastWeekLabel.frame.maxY + 55, width: bounds.width, height: 30)
        changeLabel.frame = CGRect(x: 0, y: percentageLabel.frame.maxY + 5, width: bounds.width, height: 20)

        firstSeparatorView.frame = CGRect(x: 10, y: thisWeekLabel.frame.maxY + 25, width: bounds.width - 20, height: 0.2)
        secondSeparatorView.frame = CGRect(x: 10, y: lastWeekLabel.frame.maxY + 25, width: bounds.width - 20, height: 0.2)
    }

    func setData() {
        let thisWeekValue = statistics.dataPoints[WeekDatapoint.thisWeek.rawValue].value.toInt
        let lastWeekValue = statistics.dataPoints[WeekDatapoint.lastWeek.rawValue].value.toInt
        let differenceValue = statistics.userAverage.toInt
        let percentageColor: UIColor = (thisWeekValue < lastWeekValue || thisWeekValue == lastWeekValue) ? .green : .red
        thisWeekNumberLabel.text = String(thisWeekValue)
        lastWeekNumberLabel.text = String(lastWeekValue)
        percentageLabel.text = String(differenceValue) + "%"
        percentageLabel.textColor = percentageColor
    }
}
