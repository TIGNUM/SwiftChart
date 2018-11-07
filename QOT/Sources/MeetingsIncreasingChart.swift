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

    private var height: CGFloat {
        return bounds.height
    }

    private var width: CGFloat {
        return bounds.width
    }

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
        thisWeekNumberLabel.font = .H2SecondaryTitle
        addSubview(thisWeekLabel)
        thisWeekLabel.textColor = .gray
        thisWeekLabel.textAlignment = .center
        thisWeekLabel.font = .H7SectorTitle
        thisWeekLabel.addCharactersSpacing(spacing: 2, text: "THIS WEEK")
        addSubview(firstSeparatorView)
        firstSeparatorView.backgroundColor = .gray
        firstSeparatorView.layer.opacity = 0.6
        addSubview(lastWeekNumberLabel)
        lastWeekNumberLabel.textColor = .white
        lastWeekNumberLabel.textAlignment = .center
        lastWeekNumberLabel.font = .H2SecondaryTitle
        addSubview(lastWeekLabel)
        lastWeekLabel.textColor = .gray
        lastWeekLabel.textAlignment = .center
        lastWeekLabel.font = .H7SectorTitle
        lastWeekLabel.addCharactersSpacing(spacing: 2, text: "LAST WEEK")
        addSubview(secondSeparatorView)
        secondSeparatorView.backgroundColor = .gray
        secondSeparatorView.layer.opacity = 0.6
        addSubview(percentageLabel)
        percentageLabel.textColor = .green
        percentageLabel.textAlignment = .center
        percentageLabel.font = .H2SecondaryTitle
        addSubview(changeLabel)
        changeLabel.textColor = .gray
        changeLabel.textAlignment = .center
        changeLabel.font = .H7SectorTitle
        changeLabel.addCharactersSpacing(spacing: 2, text: "CHANGE")
    }

    func layout() {
        thisWeekNumberLabel.frame = CGRect(x: 0, y: height * -Layout.multiplier_030, width: width, height: height * Layout.multiplier_015)
        thisWeekLabel.frame = CGRect(x: 0, y: thisWeekNumberLabel.frame.maxY + height * Layout.multiplier_01, width: width, height: height * Layout.multiplier_010)
        lastWeekNumberLabel.frame = CGRect(x: 0, y: thisWeekLabel.frame.maxY + height * Layout.multiplier_020, width: width, height: height * Layout.multiplier_015)
        lastWeekLabel.frame = CGRect(x: 0, y: lastWeekNumberLabel.frame.maxY + height * Layout.multiplier_01, width: width, height: height * Layout.multiplier_010)
        percentageLabel.frame = CGRect(x: 0, y: lastWeekLabel.frame.maxY + height * Layout.multiplier_020, width: width, height: height * Layout.multiplier_015)
        changeLabel.frame = CGRect(x: 0, y: percentageLabel.frame.maxY + height * Layout.multiplier_01, width: bounds.width, height: height * Layout.multiplier_010)
        firstSeparatorView.frame = CGRect(x: 10, y: thisWeekLabel.frame.maxY + height * Layout.multiplier_08, width: width - 20, height: 0.4)
        secondSeparatorView.frame = CGRect(x: 10, y: lastWeekLabel.frame.maxY + height * Layout.multiplier_08, width: width - 20, height: 0.4)
    }

    func setData() {
        var thisWeekValue: Int = 0
        var lastWeekValue: Int = 0
        if statistics.dataPoints.count > WeekDatapoint.thisWeek.rawValue {
            thisWeekValue = statistics.dataPoints[WeekDatapoint.thisWeek.rawValue].value.toInt
            lastWeekValue = statistics.dataPoints[WeekDatapoint.lastWeek.rawValue].value.toInt
        } else if statistics.dataPoints.count > WeekDatapoint.lastWeek.rawValue {
            thisWeekValue = statistics.dataPoints[0].value.toInt
        }

        let differenceValue = lastWeekValue > 0 ? "\(statistics.userAverage.toInt)%" : "+\(thisWeekValue)"
        let percentageColor: UIColor = (thisWeekValue < lastWeekValue || thisWeekValue == lastWeekValue) ? .green : .red
        thisWeekNumberLabel.text = thisWeekValue.description
        lastWeekNumberLabel.text = lastWeekValue.description
        percentageLabel.text = differenceValue
        percentageLabel.textColor = percentageColor
    }
}
