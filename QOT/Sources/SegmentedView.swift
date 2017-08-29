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

    var title: String {
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

    var id: Int {
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

final class SegmentedView: UIView {

    // MARK: - Properties

    fileprivate var data: MyStatisticsData
    fileprivate let statisticsType: MyStatisticsType
    fileprivate let myStatistics: MyStatistics
    fileprivate var selectedDisplayType: DataDisplayType
    fileprivate weak var delegate: MyStatisticsCardCellDelegate?

    // MARK: - Init

    init(frame: CGRect,
         myStatistics: MyStatistics,
         statisticsType: MyStatisticsType,
         selectedDisplayType: DataDisplayType,
         data: MyStatisticsData,
         delegate: MyStatisticsCardCellDelegate?) {
            self.myStatistics = myStatistics
            self.data = data
            self.statisticsType = statisticsType
            self.selectedDisplayType = selectedDisplayType
            self.delegate = delegate

            super.init(frame: frame)

            setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension SegmentedView {

    func setupView() {
        let leftButton = createButton(type: statisticsType.displayTypes[0])
        let rightButton = createButton(type: statisticsType.displayTypes[1])
        let separator = UIView()
        let container = UIView()
        let padding: CGFloat = 8
        let separatorHeight: CGFloat = 1
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(separator)
        addSubview(container)
        separator.backgroundColor = .white40
        leftButton.leadingAnchor == self.leadingAnchor
        leftButton.topAnchor == self.topAnchor + (padding * 2 + separatorHeight)
        leftButton.heightAnchor == 20
        leftButton.widthAnchor == self.widthAnchor * 0.5
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
        container.topAnchor == separator.bottomAnchor + (statisticsType == .peakPerformanceUpcoming ? 0 : padding)
        layoutIfNeeded()
        drawSpecificChart(container: container)
    }

    private func createButton(type: DataDisplayType) -> UIButton {
        let button = UIButton()
        let color: UIColor = type.id == selectedDisplayType.id ? .white : .white30
        let label = UILabel()
        label.prepareAndSetTextAttributes(text: type.title.uppercased(), font: Font.H7Tag, alignment: .center, lineSpacing: 2, characterSpacing: 2, color: color)
        button.setAttributedTitle(label.attributedText, for: .normal)

        button.tag = type.id
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)

        return button
    }

    private func drawSpecificChart(container: UIView) {
        let chartView: UIView

        switch statisticsType {
        case .meetingAverage:
            guard let object = (data as? MyStatisticsDataPeriodAverage) else {
                return
            }

            chartView = AverageMeetingProgressWheel(frame: container.bounds,
                                                    userValue: object.userAverage() / object.maxValue(),
                                                    teamValue: object.teamAverage() / object.maxValue(),
                                                    dataValue: object.dataAverage() / object.maxValue(),
                                                    pathColor: object.pathColor().color)
        case .peakPerformanceAverage:
            chartView = PeakPerformanceAverageProgressWheel(frame: container.bounds, myStatistics: myStatistics)
        case .travelTripsAverage:
            guard let object = (data as? MyStatisticsDataPeriods) else {
                return
            }

            chartView = TravelTripsPeriodView(frame: container.bounds, data: object)
        case .travelTripsTimeZoneChanged:
            guard let object = (data as? MyStatisticsDataPeriods) else {
                return
            }

            chartView = TravelTripsPeriodView(frame: container.bounds, data: object)
        case .peakPerformanceUpcoming:
            guard let object = (data as? MyStatisticsDataPeriods) else {
                return
            }

            chartView = PeakPerformanceUpcomingView(frame: container.bounds, data: object)
        case .intensityLoad,
             .intensityRecovery:
            guard let object = data as? MyStatisticsDataPeriods else {
                return
            }

            chartView = IntensityView(frame: container.bounds, myStatistics: myStatistics, displayType: object.displayType, myStatisticsType: statisticsType)
        default: return
        }

        container.addSubview(chartView)
        chartView.edgeAnchors == container.edgeAnchors
    }

    @objc func didTapButton(sender: UIButton) {
        guard selectedDisplayType.id != sender.tag else {
            return
        }

        selectedDisplayType = DataDisplayType.create(id: sender.tag)
        selectedDisplayTypes[statisticsType] = selectedDisplayType
        delegate?.doReload()
    }
}
