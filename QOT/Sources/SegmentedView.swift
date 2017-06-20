//
//  SegmentedView.swift
//  QOT
//
//  Created by Moucheg Mouradian on 14/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

enum DataDisplayType {
    case all
    case day
    case week
    case weeks
    case lastWeek
    case nextWeek
    case month
    case year

    func title() -> String {
        switch self {
        case .all: return ""
        case .day: return R.string.localized.meSectorMyStatisticsDay()
        case .week: return R.string.localized.meSectorMyStatisticsWeek()
        case .weeks: return R.string.localized.meSectorMyStatisticsWeeks("4")
        case .lastWeek: return R.string.localized.meSectorMyStatisticsLastWeek()
        case .nextWeek: return R.string.localized.meSectorMyStatisticsNextWeek()
        case .month: return R.string.localized.meSectorMyStatisticsMonth()
        case .year: return R.string.localized.meSectorMyStatisticsYear()
        }
    }

    func id() -> Int {
        switch self {
        case .all: return 1
        case .day: return 2
        case .week: return 3
        case .weeks: return 4
        case .lastWeek: return 5
        case .nextWeek: return 6
        case .month: return 7
        case .year: return 8
        }
    }

    static func create(id: Int) -> DataDisplayType {
        switch id {
        case 2: return .day
        case 3: return .week
        case 4: return .weeks
        case 5: return .lastWeek
        case 6: return .nextWeek
        case 7: return .month
        case 8: return .year
        default: return .all
        }
    }

}

class SegmentedView: UIView {

    private var data: MyStatisticsData
    weak var delegate: MyStatisticsCardCellDelegate?
    private var leftButtonType: DataDisplayType
    private var rightButtonType: DataDisplayType
    private let type: MyStatisticsCardType

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, type: MyStatisticsCardType, data: MyStatisticsData, delegate: MyStatisticsCardCellDelegate?, leftButtonType: DataDisplayType, rightButtonType: DataDisplayType) {
        self.data = data
        self.leftButtonType = leftButtonType
        self.rightButtonType = rightButtonType
        self.type = type

        super.init(frame: frame)

        self.delegate = delegate

        setup()
    }

    private func createButton(type: DataDisplayType) -> UIButton {
        let button = UIButton()

        let color: UIColor = type.id() == data.displayType.id() ? .white : .white40
        let attributedTitle = Style.navigationTitle(type.title().uppercased(), color).attributedString(lineSpacing: 2)

        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tag = type.id()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        return button
    }

    private func setup() {
        let leftButton = createButton(type: leftButtonType)
        let rightButton = createButton(type: rightButtonType)
        let separator = UIView()
        let container = UIView()

        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(separator)
        addSubview(container)

        let padding: CGFloat = 8
        let separatorHeight: CGFloat = 1

        separator.backgroundColor = .white40

        leftButton.leadingAnchor == self.leadingAnchor
        leftButton.topAnchor == self.topAnchor + (padding * 2 + separatorHeight)
        leftButton.heightAnchor == 20
        leftButton.widthAnchor == self.widthAnchor / 2

        rightButton.leadingAnchor == leftButton.trailingAnchor
        rightButton.trailingAnchor == self.trailingAnchor
        rightButton.topAnchor == self.topAnchor + (padding * 2 + separatorHeight)
        rightButton.heightAnchor == leftButton.heightAnchor

        separator.topAnchor == leftButton.bottomAnchor + padding
        separator.leadingAnchor == self.leadingAnchor + padding
        separator.trailingAnchor == self.trailingAnchor - padding
        separator.heightAnchor == 1

        container.leadingAnchor == self.leadingAnchor + padding
        container.trailingAnchor == self.trailingAnchor - padding
        container.bottomAnchor == self.bottomAnchor

        switch type {
        case .peakPerformanceUpcoming:
            container.topAnchor == separator.bottomAnchor
        default:
            container.topAnchor == separator.bottomAnchor + padding
        }

        layoutIfNeeded()

        drawSpecificChart(container: container)
    }

    private func drawSpecificChart(container: UIView) {

        var chartView: UIView

        switch type {
        case .meetingAverage:
            guard let object = (data as? MyStatisticsDataPeriodAverage) else { return }

            let userValue = object.userAverage() / object.maxValue()
            let teamValue = object.teamAverage() / object.maxValue()
            let dataValue = object.dataAverage() / object.maxValue()

            chartView = AverageMeetingProgressWheel(frame: container.bounds,
                                                    value: userValue,
                                                    teamValue: teamValue,
                                                    dataValue: dataValue,
                                                    pathColor: object.pathColor().color)
        case .peakPerformanceAverage:
            guard let object = (data as? MyStatisticsDataPeriodAverage) else { return }

            let userValue = object.userAverage() / object.maxValue()
            let teamValue = object.teamAverage() / object.maxValue()
            let dataValue = object.dataAverage() / object.maxValue()

            chartView = PeakPerformanceAverageProgressWheel(frame: container.bounds,
                                                            value: userValue,
                                                            teamValue: teamValue,
                                                            dataValue: dataValue,
                                                            threshold: object.threshold(),
                                                            pathColor: object.pathColor().color,
                                                            lineWidth: 10)
        case .travelTripsMeeting:
            fallthrough
        case .travelTripsTimeZoneChanged:
            guard let object = (data as? MyStatisticsDataPeriods) else { return }

            chartView = TravelTripsPeriodView(frame: container.bounds,
                                              data: object)
        case .peakPerformanceUpcoming:
            guard let object = (data as? MyStatisticsDataPeriods) else { return }

            chartView = PeakPerformanceUpcomingView(frame: container.bounds,
                                                    data: object)
        default:
            return
        }

        container.addSubview(chartView)
        chartView.edgeAnchors == container.edgeAnchors
    }

    func didTapButton(sender: UIButton) {
        guard data.displayType.id() != sender.tag else { return }
        let type = DataDisplayType.create(id: sender.tag)
        
        data.displayType = type
        delegate?.doReload()
    }
}
