//
//  ChartType.swift
//  QOT
//
//  Created by karmic on 05.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

enum ChartType: String, EnumCollection {
    case meetingAverageDay = "meetings.number.day"
    case meetingAverageWeek = "meetings.number.week"
    case meetingAverageNumber = "meetings.number.average"
    case meetingLength = "meetings.length"
    case meetingTimeBetween = "meetings.timeBetween"
    case travelTripsAverageWeeks = "travel.numberOfTrips.4weeks"
    case travelTripsAverageYear = "travel.numberOfTrips.year"
    case travelTripsNextFourWeeks = "travel.tripsNextFourWeeks"
    case travelTripsTimeZoneChangedWeeks = "travel.timeZoneChange.week"
    case travelTripsTimeZoneChangedYear = "travel.timeZoneChange.year"
    case travelTripsMaxTimeZone = "travel.tripsMaxTimeZone"
    case peakPerformanceUpcomingWeek = "peakPerformance.upcoming.week"
    case peakPerformanceUpcomingNextWeek = "peakPerformance.upcoming.nextWeek"
    case peakPerformanceAverageWeek = "peakPerformance.average.week"
    case peakPerformanceAverageMonth = "peakPerformance.average.month"
    case sleepQuantity = "sleep.quantity"
    case sleepQuality = "sleep.quality"
    case activitySittingMovementRatio = "activity.sedentary"
    case activityLevel  = "activity.level"
    case intensityLoadWeek = "intensity.load.week"
    case intensityLoadMonth = "intensity.load.month"
    case intensityRecoveryWeek = "intensity.recovery.week"
    case intensityRecoveryMonth = "intensity.recovery.month"

    var isBodyBrain: Bool {
        switch self {
        case .meetingAverageDay,
             .meetingAverageWeek,
             .meetingAverageNumber,
             .meetingLength,
             .meetingTimeBetween:
            return false
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks,
             .travelTripsTimeZoneChangedWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsMaxTimeZone:
            return false
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth:
            return false
        case .sleepQuantity,
             .sleepQuality:
            return true
        case .activitySittingMovementRatio,
             .activityLevel:
            return true
        case .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth:
            return false
        }
    }

    var labels: [String] {
        switch self {
        case .activityLevel,
             .activitySittingMovementRatio,
             .sleepQuality,
             .sleepQuantity: return weekdaySymbols(fullWeek: false)
        case .meetingAverageNumber,
             .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .intensityLoadWeek,
             .intensityRecoveryWeek: return weekdaySymbols(fullWeek: true)
        case .intensityLoadMonth,
             .intensityRecoveryMonth,
             .travelTripsTimeZoneChangedWeeks,
             .travelTripsAverageWeeks: return lastFourWeekNumbers
        case .travelTripsNextFourWeeks: return nextFourWeekNumbers
        case .travelTripsAverageYear,
             .travelTripsTimeZoneChangedYear: return monthNumbers
        default: return []
        }
    }

    var hightlightColor: UIColor {
        switch self {
        case .meetingAverageNumber,
             .activityLevel,
             .activitySittingMovementRatio,
             .sleepQuality,
             .sleepQuantity,
             .peakPerformanceUpcomingWeek,
             .intensityLoadWeek,
             .intensityRecoveryWeek,
             .intensityLoadMonth,
             .intensityRecoveryMonth,
             .travelTripsTimeZoneChangedWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsAverageWeeks,
             .travelTripsAverageYear: return .white
        default: return .white20
        }
    }

    private func weekdaySymbols(fullWeek: Bool) -> [String] {
        let lengthOfWeek = fullWeek == true ? 6 : 4
        var currentWeekday = Date().dayOfWeek
        var weekdaySymbols = [String]()
        let symbols = Calendar.sharedUTC.shortWeekdaySymbols

        for _ in 0...lengthOfWeek {
            currentWeekday = currentWeekday - 1

            if currentWeekday < 0 {
                currentWeekday = symbols.count - 1
            }

            weekdaySymbols.insert(symbols[currentWeekday], at: 0)
        }

        return weekdaySymbols
    }

    private var lastFourWeekNumbers: [String] {
        var weekNumbers = [String]()
        var currentWeekNumber = Date().weekOfYear

        for _ in 0 ..< 4 {
            currentWeekNumber = currentWeekNumber - 1

            if currentWeekNumber <= 0 {
                currentWeekNumber = 52
            }

            weekNumbers.append(String(format: "%d", currentWeekNumber))
        }

        return weekNumbers.reversed()
    }

    private var nextFourWeekNumbers: [String] {
        var weekNumbers = [String]()
        var currentWeekNumber = Date().weekOfYear

        for _ in 0 ..< 4 {
            if currentWeekNumber > 52 {
                currentWeekNumber = 1
            }

            weekNumbers.append(String(format: "%d", currentWeekNumber))
            currentWeekNumber = currentWeekNumber + 1
        }

        return weekNumbers
    }

    private var monthNumbers: [String] {
        let upperBound = 11
        var labels: [String] = []
        let now = Date()
        let calendar = Calendar.sharedUTC

        for index in 0...upperBound {
            breakLabel:
                if let date = calendar.date(byAdding: .month, value: (index - upperBound), to: now) {
                let components = calendar.dateComponents([.month], from: date as Date)

                guard let monthOfYear = components.month else {
                    labels.append("")
                    break breakLabel
                }

                labels.append("\(monthOfYear)")
            }
        }

        return labels
    }

    func selectedChart(charts: [Statistics]) -> Statistics? {
        switch self {
        case .meetingAverageDay,
             .meetingAverageWeek:
                let selectedType = selectedChartTypes.filter { ($0.key == .meetingAverageDay || $0.key == .meetingAverageWeek) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        case .meetingAverageNumber: return statistics(charts)
        case .meetingLength: return statistics(charts)
        case .meetingTimeBetween: return statistics(charts)
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear:
                let selectedType = selectedChartTypes.filter { ($0.key == .travelTripsAverageWeeks || $0.key == .travelTripsAverageYear) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        case .travelTripsNextFourWeeks: return statistics(charts)
        case .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks:
                let selectedType = selectedChartTypes.filter { ($0.key == .travelTripsTimeZoneChangedYear || $0.key == .travelTripsTimeZoneChangedWeeks) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        case .travelTripsMaxTimeZone: return statistics(charts)
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek:
                let selectedType = selectedChartTypes.filter { ($0.key == .peakPerformanceUpcomingWeek || $0.key == .peakPerformanceUpcomingNextWeek) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth:
                let selectedType = selectedChartTypes.filter { ($0.key == .peakPerformanceAverageWeek || $0.key == .peakPerformanceAverageMonth) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        case .sleepQuality: return statistics(charts)
        case .sleepQuantity: return statistics(charts)
        case .activitySittingMovementRatio: return statistics(charts)
        case .activityLevel: return statistics(charts)
        case .intensityLoadWeek,
             .intensityLoadMonth:
                let selectedType = selectedChartTypes.filter { ($0.key == .intensityLoadMonth || $0.key == .intensityLoadWeek) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        case .intensityRecoveryWeek,
             .intensityRecoveryMonth:
                let selectedType = selectedChartTypes.filter { ($0.key == .intensityRecoveryWeek || $0.key == .intensityRecoveryMonth) && $0.value == true }[0]
                return charts.filter { $0.chartType == selectedType.key }[0]
        }
    }

    var sectionType: StatisticsSectionType {
        switch self {
        case .meetingAverageNumber,
             .meetingAverageDay,
             .meetingAverageWeek,
             .meetingLength,
             .meetingTimeBetween: return .meetings
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks,
             .travelTripsMaxTimeZone: return .travel
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return .peakPerformance
        case .sleepQuality,
             .sleepQuantity: return .sleep
        case .activitySittingMovementRatio,
             .activityLevel: return .activity
        case .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth: return .intensity
        }
    }

    var title: String {
        switch self {
        case .meetingAverageNumber,
             .meetingAverageDay,
             .meetingAverageWeek: return R.string.localized.meCardTitleMeetingsNumber()
        case .meetingLength: return R.string.localized.meCardTitleMeetingsLength()
        case .meetingTimeBetween: return R.string.localized.meCardTitleMeetingsTimeBetween()
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear: return R.string.localized.meCardTitleTravelAverage()
        case .travelTripsNextFourWeeks: return R.string.localized.meCardTitleTravelTrips()
        case .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks: return R.string.localized.meCardTitleTravelTimeZoneChange()
        case .travelTripsMaxTimeZone: return R.string.localized.meCardTitleTravelTimeZoneMax()
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek: return R.string.localized.meCardTitlePeakPerformacneUpcoming()
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return R.string.localized.meCardTitlePeakPerformacneAverage()
        case .sleepQuality: return R.string.localized.meCardTitleSleepQuality()
        case .sleepQuantity: return R.string.localized.meCardTitleSleepQuantity()
        case .activitySittingMovementRatio: return R.string.localized.meCardTitleActivityRatio()
        case .activityLevel: return R.string.localized.meCardTitleActivityLevel()
        case .intensityLoadWeek,
             .intensityLoadMonth: return R.string.localized.meCardTitleIntensityLoad()
        case .intensityRecoveryWeek,
             .intensityRecoveryMonth: return R.string.localized.meCardTitleIntensityRecovery()
        }
    }

    // TODO: Replace return values when available.
    var infoText: String {
        switch self {
        case .meetingAverageNumber,
             .meetingAverageDay,
             .meetingAverageWeek: return R.string.localized.meChartInfoTextMeetingsAverageNumber()
        case .meetingLength: return R.string.localized.meChartInfoTextMeetingsAverageLength()
        case .meetingTimeBetween: return R.string.localized.meChartInfoTextMeetingsAverageTimeBetween()
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear: return R.string.localized.meChartInfoTextTravelAverageNumber()
        case .travelTripsNextFourWeeks: return R.string.localized.meChartInfoTextTravelTrips()
        case .travelTripsTimeZoneChangedYear: return ""
        case .travelTripsTimeZoneChangedWeeks: return ""
        case .travelTripsMaxTimeZone: return ""
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek: return R.string.localized.meChartInfoTextPeakPerformanceUpcoming()
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return R.string.localized.meChartInfoTextPeakPerformanceAverage()
        // TODO: make these input values dynamic from Statistics object (lowerThreshold / upperThreshold etc)
        case .sleepQuality: return R.string.localized.meChartInfoTextSleepQuality(1, 10)
        case .sleepQuantity: return R.string.localized.meChartInfoTextSleepQuantity()
        case .activitySittingMovementRatio: return R.string.localized.meChartInfoTextActivityOscillation(1, 10, 7)
        case .activityLevel: return R.string.localized.meChartInfoTextActivityIndex(1, 10)
        case .intensityLoadWeek,
             .intensityLoadMonth: return R.string.localized.meChartInfoTextIntensityLoad()
        case .intensityRecoveryWeek,
             .intensityRecoveryMonth: return R.string.localized.meChartInfoTextIntensityRecovery()
        }
    }

    var segmentedView: Bool {
        switch self {
        case .meetingAverageDay,
             .meetingAverageWeek: return true
        case .meetingAverageNumber: return false
        case .meetingLength: return false
        case .meetingTimeBetween: return false
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear: return true
        case .travelTripsNextFourWeeks: return false
        case .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks: return true
        case .travelTripsMaxTimeZone: return false
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek: return true
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return true
        case .sleepQuality,
             .sleepQuantity: return false
        case .activitySittingMovementRatio: return false
        case .activityLevel: return false
        case .intensityLoadWeek,
             .intensityLoadMonth: return true
        case .intensityRecoveryWeek,
             .intensityRecoveryMonth: return true
        }
    }

    var bottomView: Bool {
        switch self {
        case .meetingAverageNumber,
             .meetingAverageDay,
             .meetingAverageWeek,
             .meetingLength,
             .meetingTimeBetween: return false
        case .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks: return true
        case .travelTripsMaxTimeZone: return false
        case .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek: return true
        case .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return false
        case .sleepQuality,
             .sleepQuantity: return false
        case .activitySittingMovementRatio,
             .activityLevel,
             .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth: return true
        }
    }

    var sensorRequired: Bool {
        switch self {
        case .sleepQuality,
             .sleepQuantity,
             .activityLevel,
             .activitySittingMovementRatio: return true
        default: return false
        }
    }

    var calendarRequired: Bool {
        switch self {
        case .meetingAverageNumber,
             .meetingAverageDay,
             .meetingAverageWeek,
             .meetingLength,
             .meetingTimeBetween,
             .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return true
        default: return false
        }
    }

    var comingSoon: Bool {
        switch self {
        case .meetingLength,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth,
             .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .travelTripsAverageWeeks,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks,
             .travelTripsMaxTimeZone: return true
        default: return false
        }
    }

    var personalText: String {
        switch self {
        case .meetingAverageWeek,
             .meetingAverageDay,
             .travelTripsAverageYear,
             .travelTripsNextFourWeeks,
             .travelTripsAverageWeeks,
             .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks: return ""
        default: return R.string.localized.meSectorMyStatisticsPersonalAverage()
        }
    }

    var overlayImage: UIImage? {
        switch self {
        case .meetingAverageNumber,
             .meetingAverageDay,
             .meetingAverageWeek,
             .travelTripsTimeZoneChangedYear,
             .travelTripsTimeZoneChangedWeeks: return R.image.overlay_travel_01()
        case .travelTripsMaxTimeZone,
             .sleepQuantity,
             .activityLevel,
             .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek,
             .meetingTimeBetween: return R.image.overlay_travel_02()
        case .travelTripsNextFourWeeks,
             .meetingLength,
             .activitySittingMovementRatio: return R.image.overlay_travel_03()
        case .sleepQuality,
             .travelTripsAverageYear,
             .travelTripsAverageWeeks,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth: return R.image.overlay_travel_04()
        default: return nil
        }
    }

    func segmentedTitle(selected: Bool?) -> NSAttributedString? {
        switch self {
        case .meetingAverageNumber: return nil
        case .meetingAverageDay: return R.string.localized.meSectorMyStatisticsToday().attrString(selected)
        case .meetingAverageWeek: return R.string.localized.meSectorMyStatisticsThisWeek().attrString(selected)
        case .meetingLength: return nil
        case .meetingTimeBetween: return nil
        case .travelTripsAverageWeeks: return R.string.localized.meSectorMyStatisticsWeeks("4").attrString(selected)
        case .travelTripsAverageYear: return R.string.localized.meSectorMyStatisticsYear().attrString(selected)
        case .travelTripsNextFourWeeks: return nil
        case .travelTripsTimeZoneChangedYear: return R.string.localized.meSectorMyStatisticsYear().attrString(selected)
        case .travelTripsTimeZoneChangedWeeks: return R.string.localized.meSectorMyStatisticsWeeks("4").attrString(selected)
        case .travelTripsMaxTimeZone: return nil
        case .peakPerformanceUpcomingWeek: return R.string.localized.meSectorMyStatisticsLastWeek().attrString(selected)
        case .peakPerformanceUpcomingNextWeek: return R.string.localized.meSectorMyStatisticsNextWeek().attrString(selected)
        case .peakPerformanceAverageWeek: return R.string.localized.meSectorMyStatisticsWeek().attrString(selected)
        case .peakPerformanceAverageMonth: return R.string.localized.meSectorMyStatisticsMonth().attrString(selected)
        case .sleepQuality: return nil
        case .sleepQuantity: return nil
        case .activitySittingMovementRatio: return nil
        case .activityLevel: return nil
        case .intensityLoadWeek: return R.string.localized.meSectorMyStatisticsWeek().attrString(selected)
        case .intensityLoadMonth: return R.string.localized.meSectorMyStatisticsMonth().attrString(selected)
        case .intensityRecoveryWeek: return R.string.localized.meSectorMyStatisticsWeek().attrString(selected)
        case .intensityRecoveryMonth: return R.string.localized.meSectorMyStatisticsMonth().attrString(selected)
        }
    }

    var statsPeriods: ChartDimensions {
        let defaultChartDimensions = ChartDimensions(columns: 1, rows: 1, length: 1)
        let weeklyChartDimensions = ChartDimensions(columns: 4, rows: 7, length: 24)
        let yearlyChartDimensions = ChartDimensions(columns: 12, rows: 4, length: 7)

        switch self {
        case .meetingAverageNumber,
             .travelTripsAverageWeeks,
             .travelTripsNextFourWeeks,
             .travelTripsTimeZoneChangedWeeks,
             .peakPerformanceUpcomingWeek,
             .peakPerformanceUpcomingNextWeek: return weeklyChartDimensions
        case .travelTripsAverageYear,
             .travelTripsTimeZoneChangedYear: return yearlyChartDimensions
        case .travelTripsMaxTimeZone,
             .peakPerformanceAverageWeek,
             .peakPerformanceAverageMonth,
             .sleepQuality,
             .sleepQuantity,
             .activitySittingMovementRatio,
             .activityLevel,
             .intensityLoadWeek,
             .intensityLoadMonth,
             .intensityRecoveryWeek,
             .intensityRecoveryMonth,
             .meetingAverageDay,
             .meetingAverageWeek,
             .meetingLength,
             .meetingTimeBetween: return defaultChartDimensions
        }
    }

    func statistics(_ charts: [Statistics]) -> Statistics? {
        return charts.filter { $0.key == rawValue }.first
    }
}

enum StatisticsSectionType: Int, EnumCollection {
    case sleep = 0
    case activity
    case peakPerformance
    case intensity
    case meetings
    case travel

    var title: String {
        switch self {
        case .sleep: return R.string.localized.meSectorSleep()
        case .activity: return R.string.localized.meSectorActivity()
        case .peakPerformance: return R.string.localized.meSectorPeakPerformance()
        case .intensity: return R.string.localized.meSectorIntensity()
        case .meetings: return R.string.localized.meSectorMeetings()
        case .travel: return R.string.localized.meSectorTravel()
        }
    }

    var chartTypes: [[ChartType]] {
        switch self {
        case .sleep: return [[.sleepQuality],
                             [.sleepQuantity]]
        case .activity: return [[.activitySittingMovementRatio],
                                [.activityLevel]]
        case .peakPerformance: return [[.peakPerformanceUpcomingWeek, .peakPerformanceUpcomingNextWeek],
                                       [.peakPerformanceAverageWeek, .peakPerformanceAverageMonth]]
        case .intensity: return [[.intensityLoadWeek, .intensityLoadMonth],
                                 [.intensityRecoveryWeek, .intensityRecoveryMonth]]
        case .meetings: return [[.meetingAverageNumber],
//                                [.meetingAverageDay, .meetingAverageWeek], // FIXME: hidden for now, but should we delete them?
                                [.meetingLength],
                                [.meetingTimeBetween]]
        case .travel: return [[.travelTripsNextFourWeeks],
                              [.travelTripsAverageWeeks, .travelTripsAverageYear],
                              [.travelTripsTimeZoneChangedWeeks, .travelTripsTimeZoneChangedYear],
                              [.travelTripsMaxTimeZone]]
        }
    }

    var universeChartTypes: [ChartType] {
        switch self {
        case .sleep: return [.sleepQuality, .sleepQuantity]
        case .activity: return [.activitySittingMovementRatio, .activityLevel]
        case .peakPerformance: return [.peakPerformanceUpcomingWeek, .peakPerformanceAverageWeek]
        case .intensity: return [.intensityLoadWeek, .intensityRecoveryWeek]
        case .meetings: return [.meetingAverageNumber, .meetingAverageDay, .meetingLength, .meetingTimeBetween]
        case .travel: return [.travelTripsAverageWeeks, .travelTripsNextFourWeeks, .travelTripsMaxTimeZone, .travelTripsTimeZoneChangedWeeks]
        }
    }

    var sectionKeys: [[String]] {
        return chartTypes.map { $0.map { $0.rawValue } }
    }
}
