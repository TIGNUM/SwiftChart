//
//  ChartCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

var selectedChartTypes: [ChartType: Bool] = [.peakPerformanceUpcomingWeek: true,
                                             .peakPerformanceUpcomingNextWeek: false,
                                             .peakPerformanceAverageWeek: true,
                                             .peakPerformanceAverageMonth: false,
                                             .intensityLoadWeek: true,
                                             .intensityLoadMonth: false,
                                             .intensityRecoveryWeek: true,
                                             .intensityRecoveryMonth: false,
                                             .meetingAverageDay: true,
                                             .meetingAverageWeek: false,
                                             .travelTripsAverageWeeks: true,
                                             .travelTripsAverageYear: false,
                                             .travelTripsTimeZoneChangedWeeks: true,
                                             .travelTripsTimeZoneChangedYear: false]

protocol ChartCellDelegate: class {

    func doReload()
}

final class ChartCell: UICollectionViewCell, Dequeueable {

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
    @IBOutlet fileprivate weak var chartSegmentedView: UIView!
    @IBOutlet fileprivate weak var chartSegmentedContentView: UIView!
    @IBOutlet fileprivate weak var chartContentView: UIView!
    @IBOutlet fileprivate weak var bottomContentView: UIView!
    @IBOutlet fileprivate weak var labelContentView: UIView!
    @IBOutlet fileprivate weak var segmentedView: UIView!
    @IBOutlet fileprivate weak var seperatorTopView: UIView!
    @IBOutlet fileprivate weak var seperatorMiddleView: UIView!
    @IBOutlet fileprivate weak var seperatorBottomView: UIView!
    @IBOutlet fileprivate weak var leftSegmentedButton: UIButton!
    @IBOutlet fileprivate weak var rightSegmentedButton: UIButton!
    @IBOutlet fileprivate weak var bottomLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerLabelTrailingConstraint: NSLayoutConstraint!
    weak var delegate: ChartCellDelegate?
    fileprivate var selectedButtonTag = 0
    fileprivate var chartTypes = [ChartType]()
    private var statistics: Statistics?
    private var charts: [Statistics] = []
    private var headerTitle: String = ""

    // MARK: - Init

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        topContentView.backgroundColor = .clear
        bottomContentView.backgroundColor = .clear
        labelContentView.backgroundColor = .clear
        chartContentView.backgroundColor = .clear
        chartSegmentedView.backgroundColor = .clear
        chartSegmentedContentView.backgroundColor = .clear
        segmentedView.backgroundColor = .clear
        containerView.backgroundColor = .white8
        seperatorTopView.backgroundColor = .white8
        seperatorBottomView.backgroundColor = .white8
        seperatorMiddleView.backgroundColor = .white8
        containerView.layer.cornerRadius = 5
    }

    // MARK: - Public

    func setup(headerTitle: String, chartTypes: [ChartType], statistics: Statistics, charts: [Statistics]) {
        self.chartTypes = chartTypes
        self.statistics = statistics
        self.charts = charts
        self.headerTitle = headerTitle
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
        headerLabel.alpha = 1 - hidden
        headerLabelLeadingConstraint.constant = leadingConstant
        headerLabelTrailingConstraint.constant = leadingConstant == 0 ? 16 : -leadingConstant
        headerLabel.setNeedsUpdateConstraints()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        labelContentView.removeSubViews()
        chartContentView.removeSubViews()
        chartSegmentedContentView.removeSubViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        labelContentView.removeSubViews()
        chartContentView.removeSubViews()
        chartSegmentedContentView.removeSubViews()
        guard let statistics = statistics else { return }
        setupView(headerTitle: headerTitle, statistics: statistics, charts: charts)
    }
}

// MARK: - Setup View

private extension ChartCell {

    func setupView(headerTitle: String, statistics: Statistics, charts: [Statistics]) {
        setupSegmentedView(statistics.chartType)
        setupLabels(headerTitle: headerTitle, statistics: statistics, charts: charts)
        addCharts(statistics: statistics, allCards: charts)
    }

    private func setupSegmentedView(_ cardType: ChartType) {
        chartSegmentedView?.isHidden = cardType.segmentedView == false
        chartContentView.isHidden = chartSegmentedView?.isHidden == false
        guard chartTypes.count == 2 else { return }
        updateButtons()
    }

    private func setupLabels(headerTitle: String, statistics: Statistics, charts: [Statistics]) {
        let statistics = statistics.chartType.selectedChart(charts: charts)
        setLabel(text: "QOT COACH", color: .white30, label: bottomLabel)
        setLabel(text: "TEAM", color: .azure, label: teamLabel)
        setLabel(text: "AVG.", color: .azure, label: teamAverageLabel)
        setLabel(text: "AVG.", color: .cherryRedTwo, label: dataAverageLabel)
        setLabel(text: "DATA", color: .cherryRedTwo, label: dataLabel)
        setLabel(text: "PERSONAL\nAVG.", color: .white40, label: userAverageLabel, lineSpacing: 2.5)
        setLabel(text: statistics.dataAverageDisplayableValue, color: .cherryRedTwo, label: dataAverageValueLabel)
        setLabel(text: statistics.teamAverageDisplayableValue, color: .azure, label: teamAverageValueLabel)
        setLabel(text: statistics.userAverageDisplayableValue, color: .white, label: userAverageValueLabel, characterSpacing: -2.7, font: Font.H1MainTitle)
        setLabel(text: headerTitle.uppercased(), color: .white, label: headerLabel, lineSpacing: 2.5, font: Font.PTextSubtitle)
    }

    private func setLabel(text: String, color: UIColor, label: UILabel, lineSpacing: CGFloat = 1, characterSpacing: CGFloat = 2, font: UIFont = Font.H7Tag) {
        label.setAttrText(text: text, font: font, lineSpacing: lineSpacing, characterSpacing: characterSpacing, color: color)
    }

    func addCharts(statistics: Statistics, allCards: [Statistics]) {
        let stats = statistics.chartType.selectedChart(charts: allCards)
        setupChartViewLabels(stats)
        let charts = setupChartView(statistics: stats)
        if stats.chartType.segmentedView == true {
            chartSegmentedContentView.addSubview(charts)
        } else {
            chartContentView.addSubview(charts)
        }
    }

    private func setupChartView(statistics: Statistics) -> UIView {
        let segmentedFrame = CGRect(x: 0, y: 0, width: chartSegmentedContentView.frame.width, height: chartSegmentedContentView.frame.height)
        let segmentedBiggerFrame = CGRect(x: 0, y: 0, width: segmentedFrame.width, height: segmentedFrame.height + labelContentView.frame.height)
        let frame = chartContentView.frame
        let biggerFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + labelContentView.frame.height)

        switch statistics.chartType {
        case .activityLevel,
             .activitySittingMovementRatio:
            return ActivityChart(frame: frame, statistics: statistics, labelContentView: labelContentView)
        case .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth:
            return IntensityChart(frame: segmentedFrame, statistics: statistics, labelContentView: labelContentView)
        case .meetingAverageDay,
             .meetingAverageWeek:
            return MeetingsAverageChart(frame: segmentedBiggerFrame, statistics: statistics, labelContentView: labelContentView)
        case .meetingLength:
            return MeetingsLengthChart(frame: biggerFrame, statistics: statistics, labelContentView: labelContentView)
        case .meetingTimeBetween:
            return MeetingsTimeBetweenChart(frame: biggerFrame, statistics: statistics, labelContentView: labelContentView)
        case .sleepQuality,
             .sleepQuantity:
            return SleepChart(frame: frame, statistics: statistics)
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek:
            return PeakPerformanceUpcomingChart(frame: segmentedFrame, statistics: statistics, labelContentView: labelContentView)
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth:
            return PeakPerformanceAverageChart(frame: segmentedFrame, statistics: statistics, labelContentView: labelContentView)
        case .travelTripsTimeZoneChangedWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks:
            let travelTripFrame = statistics.chartType == .travelTripsNextFourWeeks ? frame : segmentedFrame
            return TravelTripsChart(frame: travelTripFrame, statistics: statistics, labelContentView: labelContentView)
        case .travelTripsMaxTimeZone:
            return TravelMaxTimeZoneChart(frame: biggerFrame, statistics: statistics, labelContentView: labelContentView)
        }
    }
}

// MARK: - Actions

private extension ChartCell {

    @IBAction func coachButtonPressed(sender: UIButton) {
        print("coachButtonPressed")
    }

    @IBAction func segmentedPressed(sender: UIButton) {
        selectedChartTypes[chartTypes[0]] = sender.tag == 0
        selectedChartTypes[chartTypes[1]] = sender.tag == 1
        selectedButtonTag = sender.tag
        updateButtons()
        delegate?.doReload()
    }

    func updateButtons() {
        let leftChartType = chartTypes[0]
        let rightChartType = chartTypes[1]
        let leftSelected = selectedChartTypes[leftChartType]
        let rightSelected = selectedChartTypes[rightChartType]
        leftSegmentedButton.setAttributedTitle(leftChartType.segmentedTitle(selected: leftSelected), for: .normal)
        rightSegmentedButton.setAttributedTitle(rightChartType.segmentedTitle(selected: rightSelected), for: .normal)
    }
}

// MARK: - Private

private extension ChartCell {

    func setupChartViewLabels(_ statistics: Statistics) {
        let isSleepChart = statistics.chartType != .sleepQuantity && statistics.chartType != .sleepQuality
        seperatorBottomView.isHidden = statistics.chartType.bottomView == false

        guard statistics.chartType.labels.isEmpty == false else { return }
        guard isSleepChart else { return }

        let labels = statistics.chartType.labels
        let highlightColor = statistics.chartType.hightlightColor
        labelContentView.drawLabelsForColumns(labels: labels, textColor: .white20, highlightColor: highlightColor, font: Font.H7Title, center: true)
        layoutIfNeeded()
    }
}
