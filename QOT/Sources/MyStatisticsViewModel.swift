//
//  MyStatisticsViewModel.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift
import UIKit

enum StatisticCardType: String {
    case meetingAverageDay = "meetings.number.day"
    case meetingAverageWeek = "meetings.number.week"
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
}

final class MyStatisticsViewModel {

    // MARK: - Properties

    let updates = PublishSubject<CollectionUpdate, NoError>()
    fileprivate let cards: [[MyStatistics]]
    fileprivate var sortedSections = [MyStatisticsSectionType]()
    let allCards: [MyStatistics]

    var numberOfSections: Int {
        return sortedSections.count
    }

    func numberOfItems(in section: Int) -> Int {
        return sectionType(in: section).cardTypes.count
    }

    func title(in section: Int) -> String {
        return sectionType(in: section).title
    }

    func sectionType(in section: Int) -> MyStatisticsSectionType {
        guard section < sortedSections.count else {
            fatalError("Invalid section type")
        }

        return sortedSections[section]
    }

    func cardType(section: Int, item: Int) -> MyStatisticsType {
        let section = sectionType(in: section)

        return section.cardTypes[item]
    }

    // MARK: - Init

    init(services: Services, startingSection: MyStatisticsSectionType) throws {
        do {
            self.cards = try services.myStatisticsService.cards()
            self.allCards = Array(services.myStatisticsService.allCardObjects())
            sortCards(startingSection: startingSection)
        } catch let error {
            throw error
        }
    }

    fileprivate func sortCards(startingSection: MyStatisticsSectionType) {
        var criticalSectionTypes = [MyStatisticsSectionType: CGFloat]()

        MyStatisticsSectionType.allValues.forEach { (sectionType: MyStatisticsSectionType) in
            let universeValue = (sectionType.cardTypes.flatMap { $0.myStatistics(cards: allCards)?.universe }).reduce(0, +)
            criticalSectionTypes[sectionType] = universeValue.toFloat
        }

        sortedSections = criticalSectionTypes.sorted { $0.value > $1.value }.flatMap { $0.key }
        sortedSections.remove(object: startingSection)
        sortedSections.insert(startingSection, at: 0)
    }

    func cardTitle(section: Int, item: Int) -> String {
        return cardType(section: section, item: item).title
    }

    func userAverage(section: Int, item: Int) -> CGFloat {
        guard let myStatistics = myStatistics(section: section, item: item) else {
            return 0
        }

        return CGFloat(myStatistics.userAverage)
    }

    func teamAverage(section: Int, item: Int) -> CGFloat {
        guard let myStatistics = myStatistics(section: section, item: item) else {
            return 0
        }

        return CGFloat(myStatistics.teamAverage)
    }

    func dataAverage(section: Int, item: Int) -> CGFloat {
        guard let myStatistics = myStatistics(section: section, item: item) else {
            return 0
        }

        return CGFloat(myStatistics.dataAverage)
    }

    func cardType(sectionType: MyStatisticsSectionType, item: Int) -> MyStatisticsType {
        return sectionType.cardTypes[item]
    }

    func myStatistics(section: Int, item: Int) -> MyStatistics? {
        return cardType(section: section, item: item).myStatistics(cards: allCards)
    }
}

enum MyStatisticsType: Int {
    case meetingAverage = 0
    case meetingLength
    case meetingTimeBetween
    case travelTripsAverage
    case travelTripsNextFourWeeks
    case travelTripsTimeZoneChanged
    case travelTripsMaxTimeZone
    case peakPerformanceUpcoming
    case peakPerformanceAverage
    case sleepQuantity
    case sleepQuality
    case activitySittingMovementRatio
    case activityLevel
    case intensityLoad
    case intensityRecovery

    static var allValues: [MyStatisticsType] {
        return [
            .meetingAverage,
            .meetingLength,
            .meetingTimeBetween,
            .travelTripsAverage,
            .travelTripsNextFourWeeks,
            .travelTripsTimeZoneChanged,
            .travelTripsMaxTimeZone,
            .peakPerformanceUpcoming,
            .peakPerformanceAverage,
            .sleepQuantity,
            .sleepQuality,
            .activitySittingMovementRatio,
            .activityLevel,
            .intensityLoad,
            .intensityRecovery
        ]
    }

    var sectionType: MyStatisticsSectionType {
        switch self {
        case .meetingAverage: return .meetings
        case .meetingLength: return .meetings
        case .meetingTimeBetween: return .meetings
        case .travelTripsAverage: return .travel
        case .travelTripsNextFourWeeks: return .travel
        case .travelTripsTimeZoneChanged: return .travel
        case .travelTripsMaxTimeZone: return .travel
        case .peakPerformanceUpcoming: return .peakPerformance
        case .peakPerformanceAverage: return .peakPerformance
        case .sleepQuantity: return .sleep
        case .sleepQuality: return .sleep
        case .activitySittingMovementRatio: return .activity
        case .activityLevel: return .activity
        case .intensityLoad: return .intensity
        case .intensityRecovery: return .intensity
        }
    }

    var title: String {
        switch self {
        case .meetingAverage: return R.string.localized.meCardTitleMeetingsNumber()
        case .meetingLength: return R.string.localized.meCardTitleMeetingsLength()
        case .meetingTimeBetween: return R.string.localized.meCardTitleMeetingsTimeBetween()
        case .travelTripsAverage: return R.string.localized.meCardTitleTravelAverage()
        case .travelTripsNextFourWeeks: return R.string.localized.meCardTitleTravelTrips()
        case .travelTripsTimeZoneChanged: return R.string.localized.meCardTitleTravelTimeZoneChange()
        case .travelTripsMaxTimeZone: return R.string.localized.meCardTitleTravelTimeZoneMax()
        case .peakPerformanceUpcoming: return R.string.localized.meCardTitlePeakPerformacneUpcoming()
        case .peakPerformanceAverage: return R.string.localized.meCardTitlePeakPerformacneAverage()
        case .sleepQuantity: return R.string.localized.meCardTitleSleepQuantity()
        case .sleepQuality: return R.string.localized.meCardTitleSleepQuality()
        case .activitySittingMovementRatio: return R.string.localized.meCardTitleActivityRatio()
        case .activityLevel: return R.string.localized.meCardTitleActivityLevel()
        case .intensityLoad: return R.string.localized.meCardTitleIntensityLoad()
        case .intensityRecovery: return R.string.localized.meCardTitleIntensityRecovery()
        }
    }

    var keys: [String] {
        switch self {
        case .meetingAverage: return [StatisticCardType.meetingAverageDay.rawValue, StatisticCardType.meetingAverageWeek.rawValue]
        case .meetingLength: return [StatisticCardType.meetingLength.rawValue]
        case .meetingTimeBetween: return [StatisticCardType.meetingTimeBetween.rawValue]
        case .travelTripsAverage: return [StatisticCardType.travelTripsAverageWeeks.rawValue, StatisticCardType.travelTripsAverageYear.rawValue]
        case .travelTripsNextFourWeeks: return [StatisticCardType.travelTripsNextFourWeeks.rawValue]
        case .travelTripsTimeZoneChanged: return [StatisticCardType.travelTripsTimeZoneChangedWeeks.rawValue, StatisticCardType.travelTripsTimeZoneChangedYear.rawValue]
        case .travelTripsMaxTimeZone: return [StatisticCardType.travelTripsMaxTimeZone.rawValue]
        case .peakPerformanceUpcoming: return [StatisticCardType.peakPerformanceUpcomingWeek.rawValue, StatisticCardType.peakPerformanceUpcomingNextWeek.rawValue]
        case .peakPerformanceAverage: return [StatisticCardType.peakPerformanceAverageWeek.rawValue, StatisticCardType.peakPerformanceAverageMonth.rawValue]
        case .sleepQuantity: return [StatisticCardType.sleepQuantity.rawValue]
        case .sleepQuality: return [StatisticCardType.sleepQuality.rawValue]
        case .activitySittingMovementRatio: return [StatisticCardType.activitySittingMovementRatio.rawValue]
        case .activityLevel: return [StatisticCardType.activityLevel.rawValue]
        case .intensityLoad: return [StatisticCardType.intensityLoadWeek.rawValue, StatisticCardType.intensityLoadMonth.rawValue]
        case .intensityRecovery: return [StatisticCardType.intensityRecoveryWeek.rawValue, StatisticCardType.intensityRecoveryMonth.rawValue]
        }
    }

    func myStatistics(cards: [MyStatistics]) -> MyStatistics? {
        guard let key = keys.first else {
            return nil
        }

        return cards.filter { $0.key == key }.first
    }

    var statsPeriods: [Int: ChartDimensions] {
        switch self {
        case .meetingAverage: return [:]
        case .meetingLength: return [:]
        case .meetingTimeBetween: return [:]
        case .travelTripsAverage:
            return [
                DataDisplayType.weeks.id: ChartDimensions(columns: 4, rows: 7, length: 24),
                DataDisplayType.year.id: ChartDimensions(columns: 12, rows: 5, length: 7)
            ]
        case .travelTripsNextFourWeeks: return [:]
        case .travelTripsTimeZoneChanged:
            return [
                DataDisplayType.weeks.id: ChartDimensions(columns: 4, rows: 7, length: 24),
                DataDisplayType.year.id: ChartDimensions(columns: 12, rows: 5, length: 7)
            ]
        case .travelTripsMaxTimeZone: return [:]
        case .peakPerformanceUpcoming:
            return [
                DataDisplayType.week.id: ChartDimensions(columns: 7, rows: 24, length: 3600),
                DataDisplayType.nextWeek.id: ChartDimensions(columns: 7, rows: 24, length: 3600)
            ]
        case .peakPerformanceAverage: return [:]
        case .sleepQuantity: return [:]
        case .sleepQuality: return [:]
        case .activitySittingMovementRatio: return [:]
        case .activityLevel: return [:]
        case .intensityLoad: return [:]
        case .intensityRecovery: return [:]
        }
    }

    var displayTypes: [DataDisplayType] {
        switch self {
        case .meetingAverage: return [.day, .week]
        case .meetingLength: return []
        case .meetingTimeBetween: return []
        case .travelTripsAverage: return [.weeks, .year]
        case .travelTripsNextFourWeeks: return []
        case .travelTripsTimeZoneChanged: return [.weeks, .year]
        case .travelTripsMaxTimeZone: return []
        case .peakPerformanceUpcoming: return [.week, .nextWeek]
        case .peakPerformanceAverage: return [.week, .month]
        case .sleepQuantity: return []
        case .sleepQuality: return []
        case .activitySittingMovementRatio: return []
        case .activityLevel: return []
        case .intensityLoad: return [.week, .month]
        case .intensityRecovery: return [.week, .month]
        }
    }

    func cards(cards: [MyStatistics]) -> [MyStatistics] {
        var myStatisticsArray: [MyStatistics] = []

        keys.forEach { (key: String) in
            if let card = (cards.filter { $0.key == key }).first {
                myStatisticsArray.append(card)
            }
        }

        return myStatisticsArray
    }
}

enum MyStatisticsSectionType: Int {
    case sleep = 0
    case activity
    case peakPerformance
    case intensity
    case meetings
    case travel

    static var allValues: [MyStatisticsSectionType] {
        return [
            sleep,
            activity,
            peakPerformance,
            intensity,
            meetings,
            travel
        ]
    }
    
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

    var cardTypes: [MyStatisticsType] {
        switch self {
        case .sleep: return [.sleepQuantity, .sleepQuality]
        case .activity: return [.activitySittingMovementRatio, .activityLevel]
        case .peakPerformance: return [.peakPerformanceUpcoming, .peakPerformanceAverage]
        case .intensity: return [.intensityLoad, .intensityRecovery]
        case .meetings: return [.meetingAverage, .meetingLength, .meetingTimeBetween]
        case .travel: return [.travelTripsAverage, .travelTripsNextFourWeeks, .travelTripsMaxTimeZone, .travelTripsTimeZoneChanged]
        }
    }
}
