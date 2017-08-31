//
//  MyStatisticsCardCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

var selectedDisplayTypes: [MyStatisticsType: DataDisplayType] = [.peakPerformanceUpcoming: .lastWeek,
                                                                 .peakPerformanceAverage: .week,
                                                                 .intensityLoad: .week,
                                                                 .intensityRecovery: .week,
                                                                 .meetingAverage: .day,
                                                                 .travelTripsAverage: .weeks,
                                                                 .travelTripsTimeZoneChanged: .weeks]

protocol MyStatisticsCardCellDelegate: class {
    
    func doReload()
}

final class MyStatisticsCardCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var userAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var userAverageLabel: UILabel!
    @IBOutlet fileprivate weak var teamAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var dataAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var teamAverageLabel: UILabel!
    @IBOutlet fileprivate weak var dataAverageLabel: UILabel!
    @IBOutlet fileprivate weak var teamLabel: UILabel!
    @IBOutlet fileprivate weak var dataLabel: UILabel!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var topContentView: UIView!
    @IBOutlet fileprivate weak var centerContentView: UIView!
    @IBOutlet fileprivate weak var bottomContentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabelTrailingConstraint: NSLayoutConstraint!
    fileprivate var currentDisplayType = DataDisplayType.all
    fileprivate weak var delegate: MyStatisticsCardCellDelegate?

    // MARK: - Initialisation

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        containerView.backgroundColor = .white8
        contentView.backgroundColor = .clear
        topContentView.backgroundColor = .clear
        centerContentView.backgroundColor = .clear
        bottomContentView.backgroundColor = .clear
        containerView.layer.cornerRadius = 10
    }

    // MARK: - Public

    func setup(headerTitle: String,
               cardType: MyStatisticsType,
               delegate: MyStatisticsCardCellDelegate?,
               myStatistics: MyStatistics?,
               allCards: [MyStatistics]) {
                    self.delegate = delegate
                    centerContentView.removeSubViews()
                    setupLabels(headerTitle: headerTitle, myStatistics: myStatistics)

                    guard let myStatistics = myStatistics else {
                        return
                    }

                    setupCardView(cardType: cardType, myStatistics: myStatistics, allCards: allCards)
    }

    func animateHeader(withCellRect cellRect: CGRect, inParentRect parentRect: CGRect) {
        let rightCorner = CGPoint(x: cellRect.origin.x + cellRect.size.width, y: cellRect.origin.y)
        let containsLeftCorner = parentRect.contains(cellRect.origin)
        let containsRightCorner = parentRect.contains(rightCorner)
        var hiddenAmount: CGFloat = 0

        if containsLeftCorner && !containsRightCorner {
            hiddenAmount = cellRect.width - (parentRect.width - cellRect.origin.x)
        } else if containsRightCorner && !containsLeftCorner {
            hiddenAmount = cellRect.width - (cellRect.width - cellRect.origin.x)
        }

        let hidden = hiddenAmount / cellRect.width
        let leadingConstant = cellRect.width * hidden
        let trailingConstant = -leadingConstant
        headerLabel.alpha = 1 - hidden
        headerLabelLeadingConstraint.constant = leadingConstant
        headerLabelTrailingConstraint.constant = trailingConstant
        headerLabel.setNeedsUpdateConstraints()
    }
}

// MARK: - Sleep

private extension MyStatisticsCardCell {

    func addSleepChart(myStatistics: MyStatistics, cardType: MyStatisticsType) {
        let view = SleepChartView(frame: centerContentView.bounds, myStatistics: myStatistics, cardType: cardType)
        centerContentView.addSubview(view)
    }
}

// MARK: - Activity

private extension MyStatisticsCardCell {

    func addActivityView(myStatistics: MyStatistics) {
        let view = ActivityChartView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(view)
    }
}

// MARK: - Meetings

private extension MyStatisticsCardCell {

    func addMeetingsCountView(myStatistics: MyStatistics, cardType: MyStatisticsType, allCards: [MyStatistics]) {
        let data = segmentedData(cardType: cardType, allCards: allCards)
        let meetingsCountView = SegmentedView(frame: centerContentView.bounds,
                                              myStatistics: myStatistics,
                                              statisticsType: cardType,
                                              selectedDisplayType: selectedDisplayTypes[cardType] ?? .all,
                                              data: data,
                                              delegate: delegate)
        centerContentView.addSubview(meetingsCountView)
    }

    func addMeetingLengthView(myStatistics: MyStatistics) {
        let averageMeetingLengthView = AverageMeetingLengthView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(averageMeetingLengthView)
    }

    func addMeetingTimeBetweenChart(myStatistics: MyStatistics) {
        let meetingTimeBetweenChart = AverageMeetingBetweenLengthView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(meetingTimeBetweenChart)
    }
}

// MARK: - Travel

private extension MyStatisticsCardCell {

    func travelNumberOfTrips(myStatistics: MyStatistics, cardType: MyStatisticsType, allCards: [MyStatistics]) {
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds,
                                                     myStatistics: myStatistics,
                                                     statisticsType: cardType,
                                                     selectedDisplayType: selectedDisplayTypes[cardType] ?? .all,
                                                     data: data,
                                                     delegate: delegate)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addUpcomingTravels(myStatistics: MyStatistics) {        
        let upcomingTravelsView = UpcomingTravelsView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(upcomingTravelsView)
    }

    func addTravelTripsTimeZoneChanges(myStatistics: MyStatistics, cardType: MyStatisticsType, allCards: [MyStatistics]) {
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds,
                                                     myStatistics: myStatistics,
                                                     statisticsType: cardType,
                                                     selectedDisplayType: selectedDisplayTypes[cardType] ?? .all,
                                                     data: data,
                                                     delegate: delegate)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addTravelMaxTimeZoneChanges(myStatistics: MyStatistics) {
        let travelMaxTimeZoneChangesView = TravelMaxTimeZoneChangesView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(travelMaxTimeZoneChangesView)
    }
}

// MARK: - Intensity

private extension MyStatisticsCardCell {

    func addIntensityView(myStatistics: MyStatistics, cardType: MyStatisticsType, allCards: [MyStatistics]) {
        let currentDisplayType = selectedDisplayTypes[cardType] ?? .all
        let index = cardType.displayTypes.index(of: currentDisplayType) ?? 0
        let cards = cardType.cards(cards: allCards)
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let intensityLoadView = SegmentedView(frame: centerContentView.bounds,
                                              myStatistics: cards[index],
                                              statisticsType: cardType,
                                              selectedDisplayType: currentDisplayType,
                                              data: data,
                                              delegate: delegate)
        centerContentView.addSubview(intensityLoadView)
    }
}

// MARK: - Peak Performances

private extension MyStatisticsCardCell {

    func addUpcomingPeakPerformancesView(myStatistics: MyStatistics, cardType: MyStatisticsType, allCards: [MyStatistics]) {
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds,
                                                     myStatistics: myStatistics,
                                                     statisticsType: cardType,
                                                     selectedDisplayType: selectedDisplayTypes[cardType] ?? .all,
                                                     data: data,
                                                     delegate: delegate)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addAveragePeakPerformanceView(myStatistics: MyStatistics, cardType: MyStatisticsType, allCards: [MyStatistics]) {
        let currentDisplayType = selectedDisplayTypes[cardType] ?? .all
        let index = cardType.displayTypes.index(of: currentDisplayType) ?? 0
        let cards = cardType.cards(cards: allCards)
        let data = segmentedData(cardType: cardType, allCards: allCards)
        let peakPerformanceView = SegmentedView(frame: centerContentView.bounds,
                                                myStatistics: cards[index],
                                                statisticsType: cardType,
                                                selectedDisplayType: currentDisplayType,
                                                data: data,
                                                delegate: delegate)
        centerContentView.addSubview(peakPerformanceView)
    }
}

// MARK: - Private

private extension MyStatisticsCardCell {

    func setupLabels(headerTitle: String, myStatistics: MyStatistics?) {
        userAverageValueLabel.prepareAndSetTextAttributes(text: myStatistics?.userAverageDisplayableValue ?? "0.0",
                                                          font: Font.H1MainTitle,
                                                          lineSpacing: 1,
                                                          characterSpacing: -2.7,
                                                          color: .white)

        userAverageValueLabel.attributedText = Style.postTitle(myStatistics?.userAverageDisplayableValue ?? "0.0", .white).attributedString()
        teamAverageValueLabel.attributedText = Style.tag(myStatistics?.teamAverageDisplayableValue ?? "0.0", .azure).attributedString()
        dataAverageValueLabel.attributedText = Style.tag(myStatistics?.dataAverageDisplayableValue ?? "0.0", .cherryRedTwo).attributedString()
        userAverageLabel.attributedText = Style.tag("PERSONAL AVG", .white40).attributedString()
        teamAverageLabel.attributedText = Style.tag("AVG", .azure).attributedString()
        dataAverageLabel.attributedText = Style.tag("AVG", .cherryRedTwo).attributedString()
        teamLabel.attributedText = Style.tag("TEAM", .azure).attributedString()
        dataLabel.attributedText = Style.tag("DATA", .cherryRedTwo).attributedString()
        headerLabel.attributedText = Style.headlineSmall(headerTitle.uppercased(), .white).attributedString()
        headerLabel.numberOfLines = 2
        headerLabel.lineBreakMode = .byWordWrapping
    }

    func setupCardView(cardType: MyStatisticsType, myStatistics: MyStatistics, allCards: [MyStatistics]) {
        switch cardType {
        case .activityLevel: addActivityView(myStatistics: myStatistics)
        case .activitySittingMovementRatio: addActivityView(myStatistics: myStatistics)
        case .intensityLoad: addIntensityView(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .intensityRecovery: addIntensityView(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .meetingAverage: addMeetingsCountView(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .meetingLength: addMeetingLengthView(myStatistics: myStatistics)
        case .meetingTimeBetween: addMeetingTimeBetweenChart(myStatistics: myStatistics)
        case .peakPerformanceUpcoming: addUpcomingPeakPerformancesView(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .peakPerformanceAverage: addAveragePeakPerformanceView(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .sleepQuality: addSleepChart(myStatistics: myStatistics, cardType: cardType)
        case .sleepQuantity:addSleepChart(myStatistics: myStatistics, cardType: cardType)
        case .travelTripsAverage: travelNumberOfTrips(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .travelTripsNextFourWeeks: addUpcomingTravels(myStatistics: myStatistics)
        case .travelTripsTimeZoneChanged: addTravelTripsTimeZoneChanges(myStatistics: myStatistics, cardType: cardType, allCards: allCards)
        case .travelTripsMaxTimeZone: addTravelMaxTimeZoneChanges(myStatistics: myStatistics)
        }
    }

    func segmentedData(cardType: MyStatisticsType, allCards: [MyStatistics]) -> MyStatisticsDataPeriodAverage {
        let cards = cardType.cards(cards: allCards)
        let firstCard = cards[0]
        let secondCard = cards[1]
        let firstDisplayType = cardType.displayTypes[0]
        let secondDisplayType = cardType.displayTypes[1]

        return MyStatisticsDataPeriodAverage(teamData: [firstDisplayType.id: firstCard.teamAverage.toFloat, secondDisplayType.id: secondCard.teamAverageValue],
                                             dataData: [firstDisplayType.id: firstCard.dataAverageValue, secondDisplayType.id: secondCard.dataAverageValue],
                                             userData: [firstDisplayType.id: firstCard.userAverageValue, secondDisplayType.id: secondCard.userAverageValue],
                                             maxData: [firstDisplayType.id: firstCard.maximum.toFloat, secondDisplayType.id: secondCard.maximum.toFloat],
                                             periods: periods(myStatistics: firstCard),
                                             statsPeriods: cardType.statsPeriods,
                                             thresholds: [firstDisplayType.id: (upperThreshold: firstCard.upperThreshold.toFloat, lowerThreshold: firstCard.lowerThreshold.toFloat),
                                                          secondDisplayType.id: (upperThreshold: secondCard.upperThreshold.toFloat, lowerThreshold: secondCard.lowerThreshold.toFloat)],
                                             displayType: selectedDisplayTypes[cardType] ?? .all)
    }

    func segmentedDataPeriod(cardType: MyStatisticsType, allCards: [MyStatistics]) -> MyStatisticsDataPeriods {
        let cards = cardType.cards(cards: allCards)
        let firstCard = cards[0]
        let secondCard = cards[1]
        let firstDisplayType = cardType.displayTypes[0]
        let secondDisplayType = cardType.displayTypes[1]
        let firstUpperThreshold = TimeInterval(firstCard.upperThreshold.toFloat)
        let firstLowerThreshold = TimeInterval(firstCard.lowerThreshold.toFloat)
        let secondUpperThreshold = TimeInterval(secondCard.upperThreshold.toFloat)
        let secondLowerThreshold = TimeInterval(secondCard.lowerThreshold.toFloat)

        return MyStatisticsDataPeriods(teamData: [firstDisplayType.id: firstCard.teamAverageValue, secondDisplayType.id: secondCard.teamAverageValue],
                                       dataData: [firstDisplayType.id: firstCard.dataAverageValue, secondDisplayType.id: secondCard.dataAverageValue],
                                       userData: [firstDisplayType.id: firstCard.userAverageValue, secondDisplayType.id: secondCard.userAverageValue],
                                       periods: periods(myStatistics: firstCard),
                                       statsPeriods: cardType.statsPeriods,
                                       thresholds: [firstDisplayType.id: (upperThreshold: firstUpperThreshold, lowerThreshold: firstLowerThreshold),
                                                    secondDisplayType.id: (upperThreshold: secondUpperThreshold, lowerThreshold: secondLowerThreshold)],
                                       displayType: selectedDisplayTypes[cardType] ?? .all
        )
    }

    private func periods(myStatistics: MyStatistics) -> [Period] {
        var periods: [Period] = []
        myStatistics.periods.forEach { (myStatisticsPeriod: MyStatisticsPeriod) in
            let period = Period(start: myStatisticsPeriod.startDate, duration: duration(myStatisticsPeriod: myStatisticsPeriod))
            periods.append(period)
        }

        return periods
    }

    private func duration(myStatisticsPeriod: MyStatisticsPeriod) -> TimeInterval {
        let calendarComponents: Set<Calendar.Component> = [.minute, .hour, .day]
        let components: DateComponents = Calendar.current.dateComponents(calendarComponents, from: Date(), to: Date().addingTimeInterval(24 * 3 * 24 * 3600))
        var daysBetween = 0
        var hoursBetween = 0
        var minutesBetween = 0

        if let days = components.day {
            daysBetween = days * 3600 * 24
        }

        if let hours = components.hour {
            hoursBetween = hours * 3600
        }

        if let minutes = components.minute {
            minutesBetween = minutes * 60
        }

        return TimeInterval(minutesBetween + hoursBetween + daysBetween)
    }
}
