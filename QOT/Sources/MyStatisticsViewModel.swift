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

final class MyStatisticsViewModel {

    // MARK: - Properties

    let updates = PublishSubject<CollectionUpdate, NoError>()
    fileprivate let cards: [[MyStatistics]]
    let allCards: [MyStatistics]

    var numberOfSections: Int {
        return MyStatisticsSectionType.allValues.count
    }

    func numberOfItems(in section: Int) -> Int {
        return sectionType(in: section).cardTypes.count
    }

    func title(in section: Int) -> String {
        return sectionType(in: section).title
    }

    func sectionType(in section: Int) -> MyStatisticsSectionType {
        guard let sectionType = MyStatisticsSectionType(rawValue: section) else {
            fatalError("Invalid section type")
        }

        return sectionType
    }

    func cardType(section: Int, item: Int) -> MyStatisticsCardType {
        let section = sectionType(in: section)

        return section.cardTypes[item]
    }

    init(cards: [[MyStatistics]], allCards: [MyStatistics]) {
        self.cards = cards
        self.allCards = allCards
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

    func cardType(sectionType: MyStatisticsSectionType, item: Int) -> MyStatisticsCardType {
        return sectionType.cardTypes[item]
    }

    func myStatistics(section: Int, item: Int) -> MyStatistics? {
        return cardType(section: section, item: item).myStatistics(cards: allCards)
    }
}

enum MyStatisticsCardType {
    case meetingAverage
    case meetingLength
    case meetingTimeBetween
    case travelTripsMeeting
    case travelTripsNextFourWeeks
    case travelTripsTimeZoneChanged
    case travelTripsMaxTimeZone
    case peakPerformanceUpcoming
    case peakPerformanceAverage
    case sleepQuantity
    case sleepQuality
    case activitySittingMovementRatio
    case activityLevel
    case intensity

    static var allValues: [MyStatisticsCardType] {
        return [
            .meetingAverage,
            .meetingLength,
            .meetingTimeBetween,
            .travelTripsMeeting,
            .travelTripsNextFourWeeks,
            .travelTripsTimeZoneChanged,
            .travelTripsMaxTimeZone,
            .peakPerformanceUpcoming,
            .peakPerformanceAverage,
            .sleepQuantity,
            .sleepQuality,
            .activitySittingMovementRatio,
            .activityLevel,
            .intensity
        ]
    }

    var sectionType: MyStatisticsSectionType {
        switch self {
        case .meetingAverage: return .meetings
        case .meetingLength: return .meetings
        case .meetingTimeBetween: return .meetings
        case .travelTripsMeeting: return .travel
        case .travelTripsNextFourWeeks: return .travel
        case .travelTripsTimeZoneChanged: return .travel
        case .travelTripsMaxTimeZone: return .travel
        case .peakPerformanceUpcoming: return .peakPerformance
        case .peakPerformanceAverage: return .peakPerformance
        case .sleepQuantity: return .sleep
        case .sleepQuality: return .sleep
        case .activitySittingMovementRatio: return .activity
        case .activityLevel: return .activity
        case .intensity: return .intensity
        }
    }

    var title: String {
        switch self {
        case .meetingAverage: return R.string.localized.meCardTitleMeetingsNumber()
        case .meetingLength: return R.string.localized.meCardTitleMeetingsLength()
        case .meetingTimeBetween: return R.string.localized.meCardTitleMeetingsTimeBetween()
        case .travelTripsMeeting: return R.string.localized.meCardTitleTravelMeetings()
        case .travelTripsNextFourWeeks: return R.string.localized.meCardTitleTravelTrips()
        case .travelTripsTimeZoneChanged: return R.string.localized.meCardTitleTravelTimeZoneChange()
        case .travelTripsMaxTimeZone: return R.string.localized.meCardTitleTravelTimeZoneMax()
        case .peakPerformanceUpcoming: return R.string.localized.meCardTitlePeakPerformacneUpcoming()
        case .peakPerformanceAverage: return R.string.localized.meCardTitlePeakPerformacneAverage()
        case .sleepQuantity: return R.string.localized.meCardTitleSleepQuantity()
        case .sleepQuality: return R.string.localized.meCardTitleSleepQuality()
        case .activitySittingMovementRatio: return R.string.localized.meCardTitleActivityRatio()
        case .activityLevel: return R.string.localized.meCardTitleActivityLevel()
        case .intensity: return R.string.localized.meCardTitleIntensity()
        }
    }

    var keys: [String] {
        switch self {
        case .meetingAverage: return ["meetingsNumber.day", "meetingsNumber.week"]
        case .meetingLength: return ["meetingsLength"]
        case .meetingTimeBetween: return ["meetingsTimeBetween"]
        case .travelTripsMeeting: return ["travelNumberOfMeetings.4weeks", "travelNumberOfMeetings.year"]
        case .travelTripsNextFourWeeks: return ["travelTripsNextFourWeeks.weeks", "travelTripsNextFourWeeks.year"]
        case .travelTripsTimeZoneChanged: return ["travelTimeZoneChange.week", "travelTimeZoneChange.year"]
        case .travelTripsMaxTimeZone: return ["travelTimeZoneChange.week"]
        case .peakPerformanceUpcoming: return ["peakPerformanceUpcoming.week", "peakPerformanceUpcoming.nextWeek"]
        case .peakPerformanceAverage: return ["peakPerformanceAverage.week", "peakPerformanceAverage.month"]
        case .sleepQuantity: return ["Sleep.Quantity"]
        case .sleepQuality: return ["Sleep.Quality"]
        case .activitySittingMovementRatio: return ["activitySittingMovement"]
        case .activityLevel: return ["activityLevel"]
        case .intensity: return ["intentensity.week", "intentensity.month"]
        }
    }

    func myStatistics(cards: [MyStatistics]) -> MyStatistics? {
        guard self.keys.isEmpty == false else {
            return nil
        }

        return cards.filter { $0.key == self.keys[0] }[0]
    }

    var statsPeriods: [Int: ChartDimensions] {
        switch self {
        case .meetingAverage: return [:]
        case .meetingLength: return [:]
        case .meetingTimeBetween: return [:]
        case .travelTripsMeeting:
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
        case .intensity: return [:]
        }
    }

    var displayTypes: [DataDisplayType] {
        switch self {
        case .meetingAverage: return [DataDisplayType.day, DataDisplayType.week]
        case .meetingLength: return []
        case .meetingTimeBetween: return []
        case .travelTripsMeeting: return [DataDisplayType.weeks, DataDisplayType.year]
        case .travelTripsNextFourWeeks: return []
        case .travelTripsTimeZoneChanged: return [DataDisplayType.weeks, DataDisplayType.year]
        case .travelTripsMaxTimeZone: return []
        case .peakPerformanceUpcoming: return [DataDisplayType.week, DataDisplayType.nextWeek]
        case .peakPerformanceAverage: return [DataDisplayType.week, DataDisplayType.month]
        case .sleepQuantity: return []
        case .sleepQuality: return []
        case .activitySittingMovementRatio: return []
        case .activityLevel: return []
        case .intensity: return []
        }
    }

    func cards(cards: [MyStatistics]) -> [MyStatistics] {
        guard self.keys.isEmpty == false else {
            return []
        }

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
        case .sleep: return "Sleep"
        case .activity: return "Activity"
        case .peakPerformance: return "Peak Performance"
        case .intensity: return "Intensity"
        case .meetings: return "Meetings"
        case .travel: return "Travel"
        }
    }

    var cardTypes: [MyStatisticsCardType] {
        switch self {
        case .sleep: return [.sleepQuantity, .sleepQuality]
        case .activity: return [.activitySittingMovementRatio, .activityLevel]
        case .peakPerformance: return [.peakPerformanceUpcoming, .peakPerformanceAverage]
        case .intensity: return [.intensity]
        case .meetings: return [.meetingAverage, .meetingLength, .meetingTimeBetween]
        case .travel: return [.travelTripsMeeting, .travelTripsNextFourWeeks, .travelTripsMaxTimeZone, .travelTripsTimeZoneChanged]
        }
    }
}
