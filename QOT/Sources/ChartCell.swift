//
//  ChartCell.swift
//  QOT
//
//  Created by karmic on 07.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

var selectedChartTypes: [ChartType: Bool] = [.peakPerformanceUpcomingWeek: true,
                                             .peakPerformanceUpcomingNextWeek: false,
                                             .peakPerformanceAverageWeek: true,
                                             .peakPerformanceAverageMonth: false,
                                             .intensityLoadWeek: true,
                                             .intensityLoadMonth: false,
                                             .intensityRecoveryWeek: true,
                                             .intensityRecoveryMonth: false,
                                             .meetingAverageDay: true,
                                             .meetingAverageWeek: true,
                                             .meetingIncreaseDiff: true,
                                             .travelTripsAverageWeeks: true,
                                             .travelTripsAverageYear: false,
                                             .travelTripsTimeZoneChangedWeeks: true,
                                             .travelTripsTimeZoneChangedYear: false]

var chartViews: [ChartType: UIView?] = [.meetingAverageDay: nil,
                                        .meetingAverageWeek: nil,
                                        .meetingLength: nil,
                                        .meetingIncreaseDiff: nil,
                                        .meetingTimeBetween: nil,
                                        .travelTripsAverageWeeks: nil,
                                        .travelTripsAverageYear: nil,
                                        .travelTripsNextFourWeeks: nil,
                                        .travelTripsTimeZoneChangedWeeks: nil,
                                        .travelTripsTimeZoneChangedYear: nil,
                                        .travelTripsMaxTimeZone: nil,
                                        .peakPerformanceUpcomingWeek: nil,
                                        .peakPerformanceUpcomingNextWeek: nil,
                                        .peakPerformanceAverageWeek: nil,
                                        .peakPerformanceAverageMonth: nil,
                                        .sleepQuantity: nil,
                                        .sleepQuantityTime: nil,
                                        .sleepQuality: nil,
                                        .activitySittingMovementRatio: nil,
                                        .activityLevel: nil,
                                        .intensityLoadWeek: nil,
                                        .intensityLoadMonth: nil,
                                        .intensityRecoveryWeek: nil,
                                        .intensityRecoveryMonth: nil]

protocol ChartCellDelegate: class {

    func doReload()

    func didSelectAddSensor()

    func didSelectOpenSettings()

}

final class ChartCell: UICollectionViewCell, Dequeueable {

    struct Configuration {
        let infoFont: UIFont
        let infoLineSpacing: CGFloat
        let infoCharacterSpacing: CGFloat

        static func make(screenType: UIViewController.ScreenType) -> Configuration {
            switch screenType {
            case .big: return Configuration(infoFont: .DPText, infoLineSpacing: 10, infoCharacterSpacing: 1)
            case .medium: return Configuration(infoFont: .DPText2, infoLineSpacing: 9, infoCharacterSpacing: 1)
            case .small: return Configuration(infoFont: .PTextSmall, infoLineSpacing: 7, infoCharacterSpacing: 0)
            }
        }
    }

    // MARK: - Properties

    @IBOutlet private weak var userAverageValueLabel: UILabel!
    @IBOutlet private weak var userAverageLabel: UILabel!
    @IBOutlet private weak var teamAverageValueLabel: UILabel!
    @IBOutlet private weak var dataAverageValueLabel: UILabel!
    @IBOutlet private weak var teamLabel: UILabel!
    @IBOutlet private weak var dataLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var topContentView: UIView!
    @IBOutlet private weak var chartSegmentedView: UIView!
    @IBOutlet private weak var chartSegmentedContentView: UIView!
    @IBOutlet private weak var chartContentView: UIView!
    @IBOutlet private weak var bottomContentView: UIView!
    @IBOutlet private weak var labelContentView: UIView!
    @IBOutlet private weak var segmentedView: UIView!
    @IBOutlet private weak var seperatorTopView: UIView!
    @IBOutlet private weak var seperatorMiddleView: UIView!
    @IBOutlet private weak var seperatorBottomView: UIView!
    @IBOutlet private weak var leftSegmentedButton: UIButton!
    @IBOutlet private weak var rightSegmentedButton: UIButton!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var infoView: UIVisualEffectView!
    @IBOutlet private weak var infoScrollView: UIScrollView!
    @IBOutlet private weak var infoScrollBottomFadeView: UIVisualEffectView!
    @IBOutlet private weak var infoViewTextLabel: UILabel!
    @IBOutlet private weak var infoViewCloseButton: UIButton!
    @IBOutlet private weak var infoVieNavigationButton: UIButton!
    @IBOutlet private weak var addSenorView: UIView!
    @IBOutlet private weak var addSenorViewLabel: UILabel!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var overlayBackgroundImageView: UIImageView!
    @IBOutlet private weak var comingSoonView: UIView!
    @IBOutlet private weak var comingSoonLabel: UILabel!
    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var headerLabelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var headerLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topView: UIView!
    weak var delegate: ChartCellDelegate?
    private var selectedButtonTag = 0
    private var infoViewDestination: AppCoordinator.Router.Destination?
    private var chartTypes = [ChartType]()
    private var statistics: Statistics?
    private var charts: [Statistics] = []
    private var headerTitle: String = ""
    private var configuration = Configuration.make(screenType: .big)
    private var fitbitState = User.FitbitState.disconnected
    private var calandarAccessGranted = true

    private var shouldShowAddSensorView: Bool {
        return fitbitState != .connected && statistics?.chartType.sensorRequired == true
    }

    private var shouldShowAddCalendarView: Bool {
        return calandarAccessGranted == false && statistics?.chartType.calendarRequired == true
    }

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
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        infoView.layer.cornerRadius = 10
        infoView.layer.borderWidth = 1
        infoView.layer.borderColor = UIColor.white30.cgColor
        infoView.layer.masksToBounds = true
        overlayView.alpha = 0
    }

    // MARK: - Public

    func setup(headerTitle: String,
               chartTypes: [ChartType],
               statistics: Statistics?,
               charts: [Statistics],
               configuration: Configuration,
               fitbitState: User.FitbitState,
               calandarAccessGranted: Bool) {
        self.chartTypes = chartTypes
        self.statistics = statistics
        self.charts = charts
        self.headerTitle = headerTitle
        self.configuration = configuration
        self.fitbitState = fitbitState
        self.calandarAccessGranted = calandarAccessGranted
        infoView.alpha = 0
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

        chartSegmentedContentView.removeSubViews()
        labelContentView.removeSubViews()
        chartContentView.removeSubViews()
        containerView.alpha = 1
        overlayView.alpha = 0
        infoView.alpha = 0
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
        setupInfoView()
        setupInfoViewNavigationButton()
    }

    func setupSegmentedView(_ cardType: ChartType) {
        chartSegmentedView?.isHidden = cardType.segmentedView == false
        chartContentView.isHidden = chartSegmentedView?.isHidden == false
        guard chartTypes.count == 2 else { return }
        updateButtons()
    }

    func setupLabels(headerTitle: String, statistics: Statistics, charts: [Statistics]) {
        guard let statistics = statistics.chartType.selectedChart(charts: charts) else { return }
        setLabel(text: "INFO", color: .white40, label: bottomLabel)
        setLabel(text: "MY\nTEAM\nAVG.", color: .white40, label: teamLabel, lineSpacing: 2.5)
        setLabel(text: "DATA\nBASE\nAVG.", color: .white40, label: dataLabel, lineSpacing: 2.5)
        setLabel(text: statistics.chartType.personalText, color: .white40, label: userAverageLabel, lineSpacing: 2.5)
        setLabel(text: statistics.dataAverageDisplayableValue, color: .white, label: dataAverageValueLabel, font: .H7SectorTitle)
        setLabel(text: statistics.teamAverageDisplayableValue, color: .white, label: teamAverageValueLabel, font: .H7SectorTitle)
        setLabel(text: statistics.userAverageDisplayableValue, color: statistics.pathColor, label: userAverageValueLabel, characterSpacing: -2.7, font: .H1MainTitle)
        setLabel(text: headerTitle.uppercased(), color: .white, label: headerLabel, lineSpacing: 2.5, font: .PTextSubtitle)
        setLabel(text: R.string.localized.meChartCommingSoon().uppercased(), color: .white, label: comingSoonLabel, lineSpacing: 2.5, font: .PTextSubtitle)
        teamLabel.sizeToFit()
        dataLabel.sizeToFit()
    }

    func setLabel(text: String,
                  color: UIColor,
                  label: UILabel,
                  lineSpacing: CGFloat = 1,
                  characterSpacing: CGFloat = 2,
                  font: UIFont = .H7Tag,
                  alignment: NSTextAlignment = .natural) {
        label.setAttrText(text: text,
                          font: font,
                          alignment: alignment,
                          lineSpacing: lineSpacing,
                          characterSpacing: characterSpacing,
                          color: color)
    }

    func addCharts(statistics: Statistics, allCards: [Statistics]) {
        guard let stats = statistics.chartType.selectedChart(charts: allCards) else { return }
        setupChartViewLabels(stats)
        let charts = setupChartView(statistics: stats)
        if stats.chartType.segmentedView == true {
            chartSegmentedContentView.addSubview(charts)
        } else {
            chartContentView.addSubview(charts)
        }
    }

    func setupChartView(statistics: Statistics) -> UIView {
        guard statistics.chartType.comingSoon == false else {
            setupOverlayView(text: R.string.localized.meChartCommingSoon())
            return UIView()
        }
        if statistics.chartType.calendarRequired == true && shouldShowAddCalendarView == true {
            setupOverlayView(text: R.string.localized.meChartAddCalendar())
            return UIView()
        }
        if statistics.chartType.sensorRequired == true && shouldShowAddSensorView == true {
            setupOverlayView(text: fitbitState.addSensorText)
            return UIView()
        }

        if
            let chartView = chartViews[statistics.chartType] as? UIView,
            chartView.frame.height == frameFor(statistics: statistics, labelContentView: labelContentView).height {
                return chartView
        }

        return createChartView(statistics: statistics, labelContentView: labelContentView)
    }

    func frameFor(statistics: Statistics, labelContentView: UIView) -> CGRect {
        let segmentedFrame = CGRect(x: 0,
                                    y: 0,
                                    width: chartSegmentedContentView.frame.width,
                                    height: chartSegmentedContentView.frame.height)
        let segmentedBiggerFrame = CGRect(x: 0,
                                          y: 0,
                                          width: segmentedFrame.width,
                                          height: segmentedFrame.height + labelContentView.frame.height)
        let frame = chartContentView.frame
        let biggerFrame = CGRect(x: 0,
                                 y: 0,
                                 width: frame.width,
                                 height: frame.height + labelContentView.frame.height)

        switch statistics.chartType {
        case .meetingAverageDay: return segmentedBiggerFrame
        case .activityLevel,
             .activitySittingMovementRatio,
             .meetingAverageWeek,
             .meetingLength,
             .sleepQuality,
             .sleepQuantity,
             .sleepQuantityTime: return frame
        case .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth,
             .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return segmentedFrame
        case .travelTripsTimeZoneChangedWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks:
            let travelTripFrame = statistics.chartType == .travelTripsNextFourWeeks ? frame : segmentedFrame
            return travelTripFrame
        case .travelTripsMaxTimeZone,
             .meetingTimeBetween,
             .meetingIncreaseDiff: return biggerFrame
        }
    }

    func createChartView(statistics: Statistics, labelContentView: UIView) -> UIView {
        let chartFrame = frameFor(statistics: statistics, labelContentView: labelContentView)
        switch statistics.chartType {
        case .activityLevel,
             .activitySittingMovementRatio:
            return addView(ActivityChart(frame: chartFrame,
                                         statistics: statistics,
                                         labelContentView: labelContentView),
                           statistics)
        case .meetingAverageDay:
            return addView(MeetingsAverageChart(frame: chartFrame,
                                                statistics: statistics,
                                                labelContentView: labelContentView),
                           statistics)
        case .meetingAverageWeek:
            return addView(MeetingsAverageNumberChart(frame: chartFrame,
                                                      statistics: statistics,
                                                      labelContentView: labelContentView),
                           statistics)
        case .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth:
            return addView(IntensityChart(frame: chartFrame,
                                          statistics: statistics,
                                          labelContentView: labelContentView),
                           statistics)
        case .meetingLength:
            return addView(MeetingsLengthChart(frame: chartFrame,
                                               statistics: statistics,
                                               labelContentView: labelContentView),
                           statistics)
        case .meetingIncreaseDiff:
            return addView(MeetingsIncreasingChart(frame: chartFrame, statistics: statistics), statistics)
        case .meetingTimeBetween:
            return addView(MeetingsTimeBetweenChart(frame: chartFrame,
                                                    statistics: statistics,
                                                    labelContentView: labelContentView),
                           statistics)
        case .sleepQuality,
             .sleepQuantity,
             .sleepQuantityTime:
            return addView(SleepChart(frame: chartFrame,
                                      statistics: statistics),
                           statistics)
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek:
            return addView(PeakPerformanceUpcomingChart(frame: chartFrame,
                                                        statistics: statistics,
                                                        labelContentView: labelContentView),
                           statistics)
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth:
            return addView(PeakPerformanceAverageChart(frame: chartFrame,
                                                       statistics: statistics,
                                                       labelContentView: labelContentView),
                           statistics)
        case .travelTripsTimeZoneChangedWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks:
            let travelTripFrame = statistics.chartType == .travelTripsNextFourWeeks ? chartContentView.frame : chartFrame
            return addView(TravelTripsChart(frame: travelTripFrame,
                                            statistics: statistics,
                                            labelContentView: labelContentView),
                           statistics)
        case .travelTripsMaxTimeZone:
            return addView(TravelMaxTimeZoneChart(frame: chartFrame,
                                                  statistics: statistics,
                                                  labelContentView: labelContentView),
                           statistics)
        }
    }

    private func addView(_ view: UIView, _ statistics: Statistics) -> UIView {
        chartViews[statistics.chartType] = view
        return view
    }
}

// MARK: - Actions

private extension ChartCell {

    @IBAction func overlayButtonTapped(sender: UIButton) {
        if shouldShowAddCalendarView == true {
            delegate?.didSelectOpenSettings()
        }

        if shouldShowAddSensorView == true {
            delegate?.didSelectAddSensor()
        }
    }

    @IBAction func infoButtonPressed(sender: UIButton) {
        infoView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.infoView.alpha = 1
        }
    }

    @IBAction func infoNavigationButtonPressed(_ sender: UIButton) {
        AppDelegate.current.appCoordinator.navigateToCalendarSettings(infoViewDestination)
    }

    @IBAction func closeInfoView() {
        UIView.animate(withDuration: 0.5) {
            self.infoView.alpha = 0
        }
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

    func setupChartViewLabels(_ statistics: Statistics?) {
        guard let statistics = statistics else { return }
        let isSleepChart = statistics.chartType != .sleepQuantityTime && statistics.chartType != .sleepQuality
        seperatorBottomView.isHidden = statistics.chartType.bottomView == false
        seperatorTopView.isHidden = statistics.chartType.topView == false
        topContentView.isHidden = statistics.chartType.topView == false
        guard statistics.chartType.labels.isEmpty == false else { return }
        guard isSleepChart else { return }
        let labels = statistics.chartType.labels
        let highlightColor = statistics.chartType.hightlightColor
        let highlightedIndex: Int
        if statistics.chartType == .meetingAverageWeek || statistics.chartType == .meetingLength {
            let currentDay = Date().dayOfWeek
            switch currentDay {
            case 1: // Sunday
                highlightedIndex = labels.count - 1
            case 2: // Monday
                highlightedIndex = 0
            default:
                highlightedIndex = currentDay - 2
            }
        } else {
            highlightedIndex = labels.count - 1
        }
        labelContentView.drawLabelsForColumns(titles: labels,
                                              textColor: .white20,
                                              highlightColor: highlightColor,
                                              font: .H7Title,
                                              center: true,
                                              highlightedIndex: highlightedIndex)
        layoutIfNeeded()
    }
}

// MARK: - InfoView

private extension ChartCell {

    func setupInfoView() {
        guard let infoText = statistics?.chartType.infoText else { return }
        let font = configuration.infoFont
        let lineSpacing = configuration.infoLineSpacing
        let characterSpacing = configuration.infoCharacterSpacing
        infoViewTextLabel.setAttrText(text: infoText,
                                      font: font,
                                      lineSpacing: lineSpacing,
                                      characterSpacing: characterSpacing,
                                      color: .white)
        infoViewCloseButton.setAttributedTitle(Style.tag("CLOSE", .white30).attributedString(lineSpacing: 2),
                                               for: .normal)
        infoViewCloseButton.setAttributedTitle(Style.tag("CLOSE", .white50).attributedString(lineSpacing: 2),
                                               for: .selected)
        infoScrollBottomFadeView.setFadeMask(at: .top, height: infoScrollBottomFadeView.bounds.height/3)
        if UIDevice.isVersion10 == true {
            infoScrollBottomFadeView.backgroundColor = .black15
        }
    }

    func setupInfoViewNavigationButton() {
        infoVieNavigationButton.isHidden = true
        guard
            let destination = statistics?.chartType.infoViewNavigation,
            let buttonTitle = statistics?.chartType.infoViewNavigationButtonTitle?.uppercased() else { return }
        infoVieNavigationButton.isHidden = false
        infoVieNavigationButton.setAttributedTitle(Style.tag(buttonTitle, .white30).attributedString(lineSpacing: 2),
                                                   for: .normal)
        infoVieNavigationButton.setAttributedTitle(Style.tag(buttonTitle, .white50).attributedString(lineSpacing: 2),
                                                   for: .selected)
        infoViewDestination = destination
    }
}

// MARK: - OverlayView

private extension ChartCell {

    func setupOverlayView(text: String) {
        overlayView.alpha = 1
        containerView.alpha = 0
        addSenorView.isHidden = statistics?.chartType.comingSoon == true
        comingSoonView.isHidden = statistics?.chartType.comingSoon == false
        overlayBackgroundImageView.image = statistics?.chartType.overlayImage
        if statistics?.chartType.comingSoon == false {
            setLabel(text: text,
                     color: .white40,
                     label: addSenorViewLabel,
                     lineSpacing: 5,
                     characterSpacing: 1,
                     font: .DPText,
                     alignment: .center)
        }
    }
}
