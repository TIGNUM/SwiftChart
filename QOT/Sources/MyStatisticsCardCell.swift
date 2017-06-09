//
//  MyStatisticsCardCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

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

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        topContentView.backgroundColor = .clear
        centerContentView.backgroundColor = .clear
        bottomContentView.backgroundColor = .clear
        layer.cornerRadius = 10
    }

    func setup(title: String, subTitle: String, data: [CGFloat], cardType: MyStatisticsCardType) {
        setupLabels(title: title, subTitle: subTitle)
        setupCardView(cardType: cardType, data: data)
    }
}

// MARK: - Private

private extension MyStatisticsCardCell {

    func setupLabels(title: String, subTitle: String) {
        titleLabel.attributedText = Style.postTitle(title, .white).attributedString()
        subTitleLabel.attributedText = Style.tag(subTitle, .white40).attributedString()
        teamAverageValueLabel.attributedText = Style.tag(title, .azure).attributedString()
        userAverageValueLabel.attributedText = Style.tag(title, .cherryRed).attributedString()
        teamAverageLabel.attributedText = Style.tag("AVG", .azure).attributedString()
        userAverageLabel.attributedText = Style.tag("AVG", .cherryRed).attributedString()
        teamLabel.attributedText = Style.tag("TEAM", .azure).attributedString()
        userLabel.attributedText = Style.tag("DATA", .cherryRed).attributedString()
        subTitleLabel.sizeToFit()
    }

    func setupCardView(cardType: MyStatisticsCardType, data: [CGFloat]) {
        switch cardType {
        case .activityLevel: addAverageGraphView(data: data)
        case .activitySittingMovementRatio: addDashedProgressWheel(data: data)
        case .intensity: addAverageGraphGridView(data: data)
        case .meetingDaily: addAverageGraphGridView(data: data)
        case .meetingHeartRateChange: return
        case .meetingLength: addMeetingLengthView(data: data)
        case .meetingTimeBetween: return
        case .meetingWeekly: return
        case .peakPerformanceAveragePerWeek: addDailyMeetingChartView(data: data)
        case .peakPerformanceNextMonth: return
        case .peakPerformanceNextWeek: return
        case .sleepQuality: addSleepChart(data: data, average: 0.5, type: .quality)
        case .sleepQuantity: addSleepChart(data: data, average: 0.3, type: .quantity)
        case .travelTripsLastFourWeeks: addHorizontalLinesChartView(data: data)
        case .travelTripsMaxTimeZone: addLevelsChartView(data: data)
        case .travelTripsTotalInYear: addLevelsChartView(data: data)
        case .travelTripsTimeZoneChanged: addLevelsChartView(data: data)
        case .travelTripsNextFourWeeks: addLevelsChartView(data: data)
        }
    }

    private func addSleepChart(data: [CGFloat], average: CGFloat, type: SleepChartView.ChartType) {
        let sleepChart = SleepChartView(frame: centerContentView.bounds, data: data, average: average, chartType: type)
        centerContentView.addSubview(sleepChart)
    }

    private func addLevelsChartView(data: [CGFloat]) {
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

    private func addDailyMeetingChartView(data: [CGFloat]) {
        var events: [Event] = []
        data.forEach { (dataItem) in
            let event = Event(start: dataItem, end: dataItem, color: .cherryRed)
            events.append(event)
        }
        let dailyMeetingChartView = DailyMeetingChartView(frame: centerContentView.bounds)
        dailyMeetingChartView.configure(events: events, lineWidth: 15)
        centerContentView.addSubview(dailyMeetingChartView)
    }

    private func addAverageGraphGridView(data: [CGFloat]) {
        var items: [EventGraphView.Item] = []
        data.forEach { (item) in
            let eventItem = EventGraphView.Item(start: item - 0.2, end: item + 0.2, color: .cherryRed)
            items.append(eventItem)
        }
        let columns = EventGraphView.Column(items: items, width: centerContentView.bounds.width - 20)
        let averageGraphGridView = AverageGraphGridView(frame: centerContentView.bounds)
        averageGraphGridView.configure(columns: [columns, columns, columns, columns, columns, columns], value: data[0], knobColor: .green, lineColor: .brown)
        centerContentView.addSubview(averageGraphGridView)
    }

    private func addAverageGraphView(data: [CGFloat]) {
        let averageGraphView = AverageGraphView(frame: centerContentView.bounds)
        averageGraphView.configure(position: data[0], knobColor: .cherryRed, lineColor: .white)
        centerContentView.addSubview(averageGraphView)
    }

    private func addDashedProgressWheel(data: [CGFloat]) {
        let dashedProgressWheel = DashedProgressWheel(frame: centerContentView.bounds, value: data[0], dashPattern: data)
        centerContentView.addSubview(dashedProgressWheel)
    }

    private func addMeetingLengthView(data: [CGFloat]) {
        let meetingsLengthView = MeetingLengthChartView(frame: centerContentView.bounds)
        meetingsLengthView.configure(innerValue: data[0], innerColor: .white, outerValue: data[1], outerColor: .cherryRed)
        centerContentView.addSubview(meetingsLengthView)
    }

    private func addHorizontalLinesChartView(data: [CGFloat]) {
        let horizontalLinesChartView = HorizontalLinesChartView(frame: centerContentView.bounds)
        horizontalLinesChartView.setUp(rowCount: data.count, seperatorHeight: 20, seperatorColor: .white20)
        centerContentView.addSubview(horizontalLinesChartView)
    }
}
