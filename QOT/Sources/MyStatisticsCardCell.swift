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

    func setup(headerTitle: String, data: MyStatisticsData, cardType: MyStatisticsCardType, delegate: MyStatisticsCardCellDelegate?) {
        centerContentView.removeSubViews()
        self.delegate = delegate
        setupLabels(headerTitle: headerTitle)
        setupCardView(cardType: cardType, data: data)
    }

    // MARK: - Public

    func animateHeader(withCellRect cellRect: CGRect, inParentRect parentRect: CGRect) {
        let rightCorner = CGPoint(x: cellRect.origin.x + cellRect.size.width, y: cellRect.origin.y)
        let containsLeftCorner = parentRect.contains(cellRect.origin)
        let containsRightCorner = parentRect.contains(rightCorner)

        var opacity: CGFloat = 1
        var hidden: CGFloat = 0
        var hiddenAmount: CGFloat = 0

        if containsLeftCorner && !containsRightCorner {
            hiddenAmount = cellRect.width - (parentRect.width - cellRect.origin.x)
        } else if containsRightCorner && !containsLeftCorner {
            hiddenAmount = cellRect.width - (cellRect.width - cellRect.origin.x)
        }

        hidden = hiddenAmount / cellRect.width
        opacity = 1 - hidden

        headerLabel.alpha = opacity

        var leadingConstant: CGFloat = 0
        var trailingConstant: CGFloat = 0

        leadingConstant = cellRect.width * hidden
        trailingConstant = -leadingConstant

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

    func setupCardView(cardType: MyStatisticsCardType, data: MyStatisticsData) {
        let dataArray: [CGFloat] = [0.1, 0.4, 0.5, 0.6, 0.3]

        switch cardType {
        case .activityLevel: addSittingMovementView(data: data)
        case .activitySittingMovementRatio: addActivityView(data: data)
        case .intensity: addAverageGraphGridView(data: dataArray)
        case .meetingAverage: addAverageMeetingCountView(data: data)
        case .meetingHeartRateChange: return
        case .meetingLength: addAverageMeetingLengthView(data: data)
        case .meetingTimeBetween: addAverageMeetingBetweenLengthView(data: data)
        case .peakPerformanceUpcoming: addUpcomingPeakPerformancesView(data: data)
        case .peakPerformanceAverage: addAveragePeakPerformanceView(data: data)
        case .sleepQuality:
            addSleepChart(data: data)
        case .sleepQuantity:
            addSleepChart(data: data)

        case .travelTripsMeeting: addAverageNumberOfMeetingDuringTravel(data: data)
        case .travelTripsNextFourWeeks: addUpcomingTravels(data: data)
        case .travelTripsTimeZoneChanged: addTravelTripsTimeZoneChanges(data: data)
        case .travelTripsMaxTimeZone: addTravelMaxTimeZoneChanges(data: data)
        }
    }

//    func addSleepChart(data: [CGFloat], average: CGFloat, type: MyStatisticsDataSleepView.ChartType) {
    func addSleepChart(data: MyStatisticsData) {
        guard let sleepData = data as? MyStatisticsDataSleepView else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", sleepData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", sleepData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", sleepData.userAverage), .cherryRed).attributedString()

        let view = SleepChartView(frame: centerContentView.bounds, data: sleepData)
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

    func addAverageGraphGridView(data: [CGFloat]) {
         func mockData() -> [IntensityAverageView.Column] {
            let items: [IntensityAverageView.Item] = [
                IntensityAverageView.Item.init(start: 0.9, end: 0.5, color: IntensityAverageView.Color.normalColor),
                IntensityAverageView.Item.init(start: 0.1, end: 0.4, color: IntensityAverageView.Color.criticalColor)
            ]

            let column = IntensityAverageView.Column(items: items, eventWidth: 10)

            return [column, column, column, column, column, column, column]
        }
        let names = ["M", "T", "w", "T", "F", "s"]
        let view = IntensityContainerView.init(frame: centerContentView.bounds, items: mockData(), dayNames: names)

        centerContentView.addSubview(view)
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

    func addUpcomingPeakPerformancesView(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataPeriods else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage()), .cherryRedTwo).attributedString()

        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .peakPerformanceUpcoming, data: tripsData, delegate: self.delegate, leftButtonType: .lastWeek, rightButtonType: .nextWeek)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    private func addAveragePeakPerformanceView(data: MyStatisticsData) {
        guard let performanceData = data as? MyStatisticsDataPeriodAverage else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", performanceData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", performanceData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", performanceData.dataAverage()), .cherryRedTwo).attributedString()

        let peakPerformanceView = SegmentedView(frame: centerContentView.bounds, type: .peakPerformanceAverage, data: performanceData, delegate: self.delegate, leftButtonType: .week, rightButtonType: .month)
        centerContentView.addSubview(peakPerformanceView)
    }

    // MARK: - Meetings

    private func addAverageMeetingCountView(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataPeriodAverage else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", meetingData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", meetingData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", meetingData.dataAverage()), .cherryRedTwo).attributedString()

        let averageMeetingView = SegmentedView(frame: centerContentView.bounds, type: .meetingAverage, data: meetingData, delegate: self.delegate, leftButtonType: .day, rightButtonType: .week)
        centerContentView.addSubview(averageMeetingView)
    }

    private func addAverageMeetingLengthView(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataAverage<Int> else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%d", meetingData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.dataAverage), .cherryRedTwo).attributedString()

        let averageMeetingLengthView = AverageMeetingLengthView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(averageMeetingLengthView)

    }

    private func addAverageMeetingBetweenLengthView(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataAverage<Int> else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%d", meetingData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.dataAverage), .cherryRedTwo).attributedString()

        let averageMeetingInBetweenLengthView = AverageMeetingBetweenLengthView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(averageMeetingInBetweenLengthView)
    }

    // MARK: - Travel

    func addAverageNumberOfMeetingDuringTravel(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataPeriods else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage()), .cherryRedTwo).attributedString()

        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .travelTripsMeeting, data: tripsData, delegate: self.delegate, leftButtonType: .weeks, rightButtonType: .year)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addUpcomingTravels(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataUpcomingTrips else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage), .cherryRedTwo).attributedString()

        let upcomingTravelsView = UpcomingTravelsView(frame: centerContentView.bounds, data: tripsData)
        centerContentView.addSubview(upcomingTravelsView)
    }

    func addTravelTripsTimeZoneChanges(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataPeriods else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage()), .cherryRedTwo).attributedString()

        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .travelTripsTimeZoneChanged, data: tripsData, delegate: self.delegate, leftButtonType: .weeks, rightButtonType: .year)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addTravelMaxTimeZoneChanges(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataAverage<Int> else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%d", meetingData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.dataAverage), .cherryRedTwo).attributedString()

        let travelMaxTimeZoneChangesView = TravelMaxTimeZoneChangesView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(travelMaxTimeZoneChangesView)
    }

    // MARK: - Activity

    private func addActivityView(data: MyStatisticsData) {
        guard let activityData = data as? MyStatisticsDataActivity else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", activityData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.dataAverage), .cherryRedTwo).attributedString()

        let dayLabels = DateFormatter().veryShortStandaloneWeekdaySymbols.mondayFirst(withWeekend: false)

        let view = ActivityChartView(frame: centerContentView.bounds, columns: activityData.data, dayNames: dayLabels)
        view.setupAverageLine(level: activityData.dataActivityLevel, lineType: .average)
        view.setupAverageLine(level: activityData.teamActivityLevel, lineType: .team)
        view.setupAverageLine(level: activityData.userActivityLevel, lineType: .personal)
        centerContentView.addSubview(view)
    }

    private func addSittingMovementView(data: MyStatisticsData) {
        guard let activityData = data as? MyStatisticsDataActivity else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", activityData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.dataAverage), .cherryRedTwo).attributedString()

        let dayLabels = DateFormatter().veryShortStandaloneWeekdaySymbols.mondayFirst(withWeekend: false)

        let view = ActivityChartView(frame: centerContentView.bounds, columns: activityData.data, dayNames: dayLabels)
        view.setupAverageLine(level: activityData.dataActivityLevel, lineType: .average)
        view.setupAverageLine(level: activityData.teamActivityLevel, lineType: .team)
        view.setupAverageLine(level: activityData.userActivityLevel, lineType: .personal)
        centerContentView.addSubview(view)
    }
}
