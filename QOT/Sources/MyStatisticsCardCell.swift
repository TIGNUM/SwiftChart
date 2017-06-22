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
    @IBOutlet fileprivate weak var topContentView: UIView!
    @IBOutlet fileprivate weak var centerContentView: UIView!
    @IBOutlet fileprivate weak var bottomContentView: UIView!

    fileprivate weak var delegate: MyStatisticsCardCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .lightGray
        contentView.backgroundColor = .clear
        topContentView.backgroundColor = .clear
        centerContentView.backgroundColor = .clear
        bottomContentView.backgroundColor = .clear
        layer.cornerRadius = 10
    }

    func setup(subTitle: String, data: MyStatisticsData, cardType: MyStatisticsCardType, delegate: MyStatisticsCardCellDelegate?) {
        centerContentView.removeSubViews()
        self.delegate = delegate
        setupLabels(subTitle: subTitle)
        setupCardView(cardType: cardType, data: data)
    }
}

// MARK: - Private

private extension MyStatisticsCardCell {

    func setupLabels(subTitle: String) {
        subTitleLabel.attributedText = Style.tag(subTitle, .white40).attributedString()
        teamAverageLabel.attributedText = Style.tag("AVG", .azure).attributedString()
        userAverageLabel.attributedText = Style.tag("AVG", .cherryRed).attributedString()
        teamLabel.attributedText = Style.tag("TEAM", .azure).attributedString()
        userLabel.attributedText = Style.tag("DATA", .cherryRed).attributedString()
        subTitleLabel.sizeToFit()
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
        var items: [EventGraphView.Item] = []
        data.forEach { (item) in
            let eventItem = EventGraphView.Item(start: item - 0.2, end: item + 0.2, color: EventGraphView.Color.lowColor)
            items.append(eventItem)
        }
        let columns = EventGraphView.Column(items: items, width: centerContentView.bounds.width - 20)
        let averageGraphGridView = AverageGraphGridView(frame: centerContentView.bounds)
        averageGraphGridView.configure(columns: [columns, columns, columns, columns, columns, columns], value: data[0], knobColor: .green, lineColor: .brown)
        centerContentView.addSubview(averageGraphGridView)
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
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage()), .cherryRed).attributedString()

        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .peakPerformanceUpcoming, data: tripsData, delegate: self.delegate, leftButtonType: .lastWeek, rightButtonType: .nextWeek)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    private func addAveragePeakPerformanceView(data: MyStatisticsData) {
        guard let performanceData = data as? MyStatisticsDataPeriodAverage else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", performanceData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", performanceData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", performanceData.dataAverage()), .cherryRed).attributedString()

        let peakPerformanceView = SegmentedView(frame: centerContentView.bounds, type: .peakPerformanceAverage, data: performanceData, delegate: self.delegate, leftButtonType: .week, rightButtonType: .month)
        centerContentView.addSubview(peakPerformanceView)
    }

    // MARK: - Meetings

    private func addAverageMeetingCountView(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataPeriodAverage else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", meetingData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", meetingData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", meetingData.dataAverage()), .cherryRed).attributedString()

        let averageMeetingView = SegmentedView(frame: centerContentView.bounds, type: .meetingAverage, data: meetingData, delegate: self.delegate, leftButtonType: .day, rightButtonType: .week)
        centerContentView.addSubview(averageMeetingView)
    }

    private func addAverageMeetingLengthView(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataAverage<Int> else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%d", meetingData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.dataAverage), .cherryRed).attributedString()

        let averageMeetingLengthView = AverageMeetingLengthView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(averageMeetingLengthView)

    }

    private func addAverageMeetingBetweenLengthView(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataAverage<Int> else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%d", meetingData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.dataAverage), .cherryRed).attributedString()

        let averageMeetingInBetweenLengthView = AverageMeetingBetweenLengthView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(averageMeetingInBetweenLengthView)
    }

    // MARK: - Travel

    func addAverageNumberOfMeetingDuringTravel(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataPeriods else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage()), .cherryRed).attributedString()

        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .travelTripsMeeting, data: tripsData, delegate: self.delegate, leftButtonType: .weeks, rightButtonType: .year)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addUpcomingTravels(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataUpcomingTrips else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage), .cherryRed).attributedString()

        let upcomingTravelsView = UpcomingTravelsView(frame: centerContentView.bounds, data: tripsData)
        centerContentView.addSubview(upcomingTravelsView)
    }

    func addTravelTripsTimeZoneChanges(data: MyStatisticsData) {
        guard let tripsData = data as? MyStatisticsDataPeriods else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", tripsData.userAverage()), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.teamAverage()), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", tripsData.dataAverage()), .cherryRed).attributedString()

        let meetingsDuringTravelView = SegmentedView(frame: centerContentView.bounds, type: .travelTripsTimeZoneChanged, data: tripsData, delegate: self.delegate, leftButtonType: .weeks, rightButtonType: .year)
        centerContentView.addSubview(meetingsDuringTravelView)
    }

    func addTravelMaxTimeZoneChanges(data: MyStatisticsData) {
        guard let meetingData = data as? MyStatisticsDataAverage<Int> else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%d", meetingData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%d", meetingData.dataAverage), .cherryRed).attributedString()

        let travelMaxTimeZoneChangesView = TravelMaxTimeZoneChangesView(frame: centerContentView.bounds, data: meetingData)
        centerContentView.addSubview(travelMaxTimeZoneChangesView)
    }

    // MARK: - Activity

    private func addActivityView(data: MyStatisticsData) {
        guard let activityData = data as? MyStatisticsDataActivity else { return }

        titleLabel.attributedText = Style.postTitle(String(format: "%.1f", activityData.userAverage), .white).attributedString()

        teamAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.teamAverage), .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.dataAverage), .cherryRed).attributedString()

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
        userAverageValueLabel.attributedText = Style.tag(String(format: "%.1f", activityData.dataAverage), .cherryRed).attributedString()

        let dayLabels = DateFormatter().veryShortStandaloneWeekdaySymbols.mondayFirst(withWeekend: false)

        let view = ActivityChartView(frame: centerContentView.bounds, columns: activityData.data, dayNames: dayLabels)
        view.setupAverageLine(level: activityData.dataActivityLevel, lineType: .average)
        view.setupAverageLine(level: activityData.teamActivityLevel, lineType: .team)
        view.setupAverageLine(level: activityData.userActivityLevel, lineType: .personal)
        centerContentView.addSubview(view)
    }
}
