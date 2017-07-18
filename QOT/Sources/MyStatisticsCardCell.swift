//
//  MyStatisticsCardCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol MyStatisticsCardCellDelegate: class {
    func doReload()
}

final class MyStatisticsCardCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subTitleLabel: UILabel!
    @IBOutlet fileprivate weak var teamAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var userAverageValueLabel: UILabel!
    @IBOutlet fileprivate weak var teamAverageLabel: UILabel!
    @IBOutlet fileprivate weak var userAverageLabel: UILabel!
    @IBOutlet fileprivate weak var teamLabel: UILabel!
    @IBOutlet fileprivate weak var userLabel: UILabel!
    @IBOutlet fileprivate weak var containerView: UIView!
    @IBOutlet fileprivate weak var topContentView: UIView!
    @IBOutlet fileprivate weak var centerContentView: UIView!
    @IBOutlet fileprivate weak var bottomContentView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabelTrailingConstraint: NSLayoutConstraint!
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

    func setup(headerTitle: String, cardType: MyStatisticsCardType, delegate: MyStatisticsCardCellDelegate?, myStatistics: MyStatistics?, allCards: [MyStatistics]) {
        centerContentView.removeSubViews()
        self.delegate = delegate
        setupLabels(headerTitle: headerTitle)

        guard let myStatistics = myStatistics else {
            return
        }

        setupCardView(cardType: cardType, myStatistics: myStatistics, allCards: allCards)
    }

    // MARK: - Public

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
        let opacity = 1 - hidden
        headerLabel.alpha = opacity
        let leadingConstant = cellRect.width * hidden
        let trailingConstant = -leadingConstant
        headerLabelLeadingConstraint.constant = leadingConstant
        headerLabelTrailingConstraint.constant = trailingConstant
        headerLabel.setNeedsUpdateConstraints()
    }
}

// MARK: - Private

private extension MyStatisticsCardCell {

    func setupLabels(headerTitle: String) {
        teamAverageLabel.attributedText = Style.tag("AVG", .azure).attributedString()
        userAverageLabel.attributedText = Style.tag("AVG", .cherryRedTwo).attributedString()
        teamLabel.attributedText = Style.tag("TEAM", .azure).attributedString()
        userLabel.attributedText = Style.tag("DATA", .cherryRedTwo).attributedString()
        subTitleLabel.attributedText = Style.tag("PERSONAL AVG", .white40).attributedString()
        headerLabel.attributedText = Style.headlineSmall(headerTitle.uppercased(), .white).attributedString()
        headerLabel.numberOfLines = 2
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.sizeToFit()
    }

    func setupCardView(cardType: MyStatisticsCardType, myStatistics: MyStatistics, allCards: [MyStatistics]) {
        setLabels(myStatistics: myStatistics)

        switch cardType {
        case .activityLevel: addActivityView(myStatistics: myStatistics)
        case .activitySittingMovementRatio: addActivityView(myStatistics: myStatistics)
        case .intensity: addAverageGraphGridView(myStatistics: myStatistics)
        case .meetingAverage: addAverageMeetingCountView(cardType: cardType, allCards: allCards)
        case .meetingLength: addAverageMeetingLengthView(myStatistics: myStatistics)
        case .meetingTimeBetween: addAverageMeetingBetweenLengthView(myStatistics: myStatistics)
        case .peakPerformanceUpcoming: addUpcomingPeakPerformancesView(cardType: cardType, allCards: allCards)
        case .peakPerformanceAverage: addAveragePeakPerformanceView(cardType: cardType, allCards: allCards)
        case .sleepQuality: addSleepChart(myStatistics: myStatistics, cardType: cardType)
        case .sleepQuantity:addSleepChart(myStatistics: myStatistics, cardType: cardType)
        case .travelTripsMeeting: addAverageNumberOfMeetingDuringTravel(cardType: cardType, allCards: allCards)
        case .travelTripsNextFourWeeks: addUpcomingTravels(myStatistics: myStatistics)
        case .travelTripsTimeZoneChanged: addTravelTripsTimeZoneChanges(cardType: cardType, allCards: allCards)
        case .travelTripsMaxTimeZone: addTravelMaxTimeZoneChanges(myStatistics: myStatistics)
        }
    }

    func addSleepChart(myStatistics: MyStatistics, cardType: MyStatisticsCardType) {
        guard myStatistics.dataPoints.isEmpty == false else {
            return
        }
    
        let view = SleepChartView(frame: centerContentView.bounds, myStatistics: myStatistics, cardType: cardType)
        centerContentView.addSubview(view)
    }

    func addLevelsChartView(data: [CGFloat]) {
        var items: [LevelsChartView.Item] = []
        for column in 0...7 {
            for row in 0...7 {
                let item = LevelsChartView.Item(color: column % 2 == 0 ? .cherryRed : .white, column: column, row: row)
                items.append(item)
            }
        }

        let levelsChartView = LevelsChartView(frame: centerContentView.bounds)
        levelsChartView.configure(items: items, columnCount: 7, rowCount: 7)
        centerContentView.addSubview(levelsChartView)
    }

    func addDailyMeetingChartView(data: [CGFloat]) {
        var events: [Event] = []
        data.forEach { (dataItem) in
            let event = Event(start: dataItem, end: dataItem, color: .cherryRed)
            events.append(event)
        }
        let dailyMeetingChartView = DailyMeetingChartView(frame: centerContentView.bounds)
        dailyMeetingChartView.configure(events: events, lineWidth: 15)
        centerContentView.addSubview(dailyMeetingChartView)
    }

    func addAverageGraphGridView(myStatistics: MyStatistics) {
        let names = ["M", "T", "w", "T", "F", "s"]
        let view = IntensityContainerView(frame: centerContentView.bounds, items: mockData(myStatistics: myStatistics), dayNames: names)

        centerContentView.addSubview(view)
    }

    func mockData(myStatistics: MyStatistics) -> [IntensityAverageView.Column] {
        let items: [IntensityAverageView.Item] = [
            IntensityAverageView.Item(start: 0.9, end: 0.5, color: IntensityAverageView.Color.normalColor),
            IntensityAverageView.Item(start: 0.1, end: 0.4, color: IntensityAverageView.Color.criticalColor)
        ]

        let column = IntensityAverageView.Column(items: items, eventWidth: 10)

        return [column, column, column, column, column, column, column]
    }

    func addAverageGraphView(data: [CGFloat]) {
        let averageGraphView = AverageGraphView(frame: centerContentView.bounds)
        averageGraphView.configure(position: data[0], knobColor: .cherryRed, lineColor: .white)
        centerContentView.addSubview(averageGraphView)
    }

    func addDashedProgressWheel(data: [CGFloat]) {
        let dashedProgressWheel = DashedProgressWheel(frame: centerContentView.bounds, value: data[0], dashPattern: data)
        centerContentView.addSubview(dashedProgressWheel)
    }

    func addHorizontalLinesChartView(data: [CGFloat]) {
        let horizontalLinesChartView = HorizontalLinesChartView(frame: centerContentView.bounds)
        horizontalLinesChartView.setUp(rowCount: data.count, seperatorHeight: 20, seperatorColor: .white20)
        centerContentView.addSubview(horizontalLinesChartView)
    }

    // MARK: - Peak Performances

    func addUpcomingPeakPerformancesView(cardType: MyStatisticsCardType, allCards: [MyStatistics]) {
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .peakPerformanceUpcoming, data: data, delegate: delegate, leftButtonType: .lastWeek, rightButtonType: .nextWeek)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    private func addAveragePeakPerformanceView(cardType: MyStatisticsCardType, allCards: [MyStatistics]) {
        let data = segmentedData(cardType: cardType, allCards: allCards)
        let peakPerformanceView = SegmentedView(frame: centerContentView.bounds, type: .peakPerformanceAverage, data: data, delegate: delegate, leftButtonType: .week, rightButtonType: .month)
        centerContentView.addSubview(peakPerformanceView)
    }

    // MARK: - Meetings

    private func addAverageMeetingCountView(cardType: MyStatisticsCardType, allCards: [MyStatistics]) {
        let data = segmentedData(cardType: cardType, allCards: allCards)
        let averageMeetingView = SegmentedView(frame: centerContentView.bounds, type: .meetingAverage, data: data, delegate: delegate, leftButtonType: .day, rightButtonType: .week)
        centerContentView.addSubview(averageMeetingView)
    }

    private func segmentedData(cardType: MyStatisticsCardType, allCards: [MyStatistics]) -> MyStatisticsDataPeriodAverage {
        let cards = cardType.cards(cards: allCards)
        let firstCard = cards[0]
        let secondCard = cards[1]
        let firstDisplayType = cardType.displayTypes[0]
        let secondDisplayType = cardType.displayTypes[1]
        return MyStatisticsDataPeriodAverage(teamData: [firstDisplayType.id: firstCard.teamAverage.toFloat, secondDisplayType.id: secondCard.teamAverage.toFloat],
                                             dataData: [firstDisplayType.id: firstCard.dataAverage.toFloat, secondDisplayType.id: secondCard.dataAverage.toFloat],
                                             userData: [firstDisplayType.id: firstCard.userAverage.toFloat, secondDisplayType.id: secondCard.userAverage.toFloat],
                                             maxData: [firstDisplayType.id: firstCard.maximum.toFloat, secondDisplayType.id: secondCard.maximum.toFloat],
                                             thresholds: [
                                                firstDisplayType.id: (upperThreshold: firstCard.upperThreshold.toFloat, lowerThreshold: firstCard.lowerThreshold.toFloat),
                                                secondDisplayType.id: (upperThreshold: secondCard.upperThreshold.toFloat, lowerThreshold: secondCard.lowerThreshold.toFloat)],
                                             displayType: firstDisplayType)
    }

    private func segmentedDataPeriod(cardType: MyStatisticsCardType, allCards: [MyStatistics]) -> MyStatisticsDataPeriods {
        let cards = cardType.cards(cards: allCards)
        let firstCard = cards[0]
        let secondCard = cards[1]
        let firstDisplayType = cardType.displayTypes[0]
        let secondDisplayType = cardType.displayTypes[1]

        return MyStatisticsDataPeriods(
            teamData: [firstDisplayType.id: firstCard.teamAverage.toFloat, secondDisplayType.id: secondCard.teamAverage.toFloat],
            dataData: [firstDisplayType.id: firstCard.dataAverage.toFloat, secondDisplayType.id: secondCard.dataAverage.toFloat],
            userData: [firstDisplayType.id: firstCard.userAverage.toFloat, secondDisplayType.id: secondCard.userAverage.toFloat],
            periods: periods(myStatistics: firstCard),
            statsPeriods: cardType.statsPeriods,
            thresholds: [
                firstDisplayType.id: (upperThreshold: TimeInterval(firstCard.upperThreshold.toInt), lowerThreshold: TimeInterval(firstCard.lowerThreshold.toInt)),
                secondDisplayType.id: (upperThreshold: TimeInterval(secondCard.userAverage.toInt), lowerThreshold: TimeInterval(secondCard.lowerThreshold.toInt))
            ],
            displayType: firstDisplayType
        )
    }

    private func periods(myStatistics: MyStatistics) -> [Period] {
        var periods: [Period] = []
        myStatistics.periods.forEach { (myStatisticsPeriod: MyStatisticsPeriod) in
            print("myStatisticsPeriod: ", myStatisticsPeriod.startDate, myStatisticsPeriod.endDate)
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

    private func addAverageMeetingLengthView(myStatistics: MyStatistics) {
        let averageMeetingLengthView = AverageMeetingLengthView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(averageMeetingLengthView)
    }

    private func addAverageMeetingBetweenLengthView(myStatistics: MyStatistics) {
        let averageMeetingInBetweenLengthView = AverageMeetingBetweenLengthView(frame: centerContentView.bounds, myStatistics: myStatistics)
        centerContentView.addSubview(averageMeetingInBetweenLengthView)
    }

    // MARK: - Travel

    func addAverageNumberOfMeetingDuringTravel(cardType: MyStatisticsCardType, allCards: [MyStatistics]) {
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .travelTripsMeeting, data: data, delegate: delegate, leftButtonType: .weeks, rightButtonType: .year)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addUpcomingTravels(myStatistics: MyStatistics) {
        let labels: [String] = ["+1", "+2", "+3", "+4"]
        userUpcomingTrips(myStatistics: myStatistics)
        let data = MyStatisticsDataUpcomingTrips(
            teamAverage: myStatistics.teamAverage.toFloat,
            dataAverage: myStatistics.dataAverage.toFloat,
            userAverage: myStatistics.userAverage.toFloat,
            userUpcomingTrips: [],
            labels: labels)

        let upcomingTravelsView = UpcomingTravelsView(frame: centerContentView.bounds, data: data)
        centerContentView.addSubview(upcomingTravelsView)
    }

    private func userUpcomingTrips(myStatistics: MyStatistics) {
        var counts: [Int: Int] = [:]
        for period in myStatistics.periods {
            for i in 0..<28 {                
                if Range<Date>.makeOneDay(daysFromNow: i).overlaps(period.range) {
                    counts[i] = (counts[i] ?? 0) + 1
                }
            }
        }
    }

    func addTravelTripsTimeZoneChanges(cardType: MyStatisticsCardType, allCards: [MyStatistics]) {
        let data = segmentedDataPeriod(cardType: cardType, allCards: allCards)
        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .travelTripsTimeZoneChanged, data: data, delegate: delegate, leftButtonType: .weeks, rightButtonType: .year)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addTravelMaxTimeZoneChanges(myStatistics: MyStatistics) {
        let meetingData = MyStatisticsDataAverage(
            teamAverage: myStatistics.teamAverage.toInt,
            dataAverage: myStatistics.dataAverage.toInt,
            userAverage: myStatistics.userAverage.toInt,
            maximum: myStatistics.maximum.toInt,
            threshold: (
                upperThreshold: myStatistics.upperThreshold.toInt,
                lowerThreshold: myStatistics.lowerThreshold.toInt
            )
        )

        let travelMaxTimeZoneChangesView = TravelMaxTimeZoneChangesView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(travelMaxTimeZoneChangesView)
    }

    // MARK: - Activity

    private func addActivityView(myStatistics: MyStatistics) {
        let dayLabels = DateFormatter().veryShortStandaloneWeekdaySymbols.mondayFirst(withWeekend: false)
        let view = ActivityChartView(frame: centerContentView.bounds, dayNames: dayLabels, myStatistics: myStatistics)
        view.setupAverageLine(level: CGFloat(myStatistics.dataAverage), lineType: .average)
        view.setupAverageLine(level: CGFloat(myStatistics.teamAverage), lineType: .team)
        view.setupAverageLine(level: CGFloat(myStatistics.userAverage), lineType: .personal)
        centerContentView.addSubview(view)
    }

    private func setLabels(myStatistics: MyStatistics) {
        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", CGFloat(myStatistics.userAverage)), .white).attributedString()
        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", CGFloat(myStatistics.teamAverage)), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", CGFloat(myStatistics.dataAverage)), .cherryRedTwo).attributedString()
    }
}
