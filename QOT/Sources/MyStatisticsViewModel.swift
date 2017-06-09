//
//  MyStatisticsViewModel.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MyStatisticsViewModel {

    // MARK: - Properties

    let updates = PublishSubject<CollectionUpdate, NoError>()

    var numberOfSections: Int {
        return MyStatisticsSectionType.allValues.count
    }

    func title(in section: Int) -> String {
        return sectionType(in: section).title
    }

    private func sectionType(in section: Int) -> MyStatisticsSectionType {
        guard let sectionType = MyStatisticsSectionType(rawValue: section) else {
            fatalError("Invalid section type")
        }

        return sectionType
    }
}

// MARK: - Mocks

protocol MyStatisticsCard {
    var title: String { get }
    var subtitle: String { get }
    var type: MyStatisticsCardType { get }
    var data: [CGFloat] { get }
}

struct MockMyStatisticsCard: MyStatisticsCard {
    let title: String
    let subtitle: String
    let type: MyStatisticsCardType
    let data: [CGFloat]
}

enum MyStatisticsCardType {
    case meetingDaily
    case meetingWeekly
    case meetingLength
    case meetingTimeBetween
    case meetingHeartRateChange
    case travelTripsLastFourWeeks
    case travelTripsNextFourWeeks
    case travelTripsTimeZoneChanged
    case travelTripsTotalInYear
    case travelTripsMaxTimeZone
    case peakPerformanceNextMonth
    case peakPerformanceAveragePerWeek
    case peakPerformanceNextWeek
    case sleepQuantity
    case sleepQuality
    case activitySittingMovementRatio
    case activityLevel
    case intensity
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

    var cards: [MyStatisticsCard] {
        switch self {
        case .sleep: return sleepCards
        case .activity: return activityCards
        case .peakPerformance: return peakPerformanceCards
        case .intensity: return intensityCards
        case .meetings: return meetingCards
        case .travel: return travelCards
        }
    }
}

private extension MyStatisticsSectionType {

    private func makeData() -> [CGFloat] {
        return [
            CGFloat(Int.random(between: 1, and: 10))/CGFloat(10),
            CGFloat(Int.random(between: 1, and: 10))/CGFloat(10),
            CGFloat(Int.random(between: 1, and: 10))/CGFloat(10),
            CGFloat(Int.random(between: 1, and: 10))/CGFloat(10),
            CGFloat(Int.random(between: 1, and: 10))/CGFloat(10)
        ]
    }

    var sleepCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "8.5H", subtitle: "Sleep Quantity", type: .sleepQuantity, data: makeData()),
            MockMyStatisticsCard(title: "7.5H", subtitle: "Sleep Quality", type: .sleepQuality, data: makeData())
        ]
    }

    var meetingCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "#12", subtitle: "Number of Meetings", type: .meetingWeekly, data: makeData()),
            MockMyStatisticsCard(title: "2.4H", subtitle: "Length of Meetings", type: .meetingDaily, data: makeData()),
            MockMyStatisticsCard(title: "1.5H", subtitle: "Time Between Meetings", type: .meetingTimeBetween, data: makeData())
        ]
    }

    var travelCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "25", subtitle: "Trips last four weeks", type: .travelTripsLastFourWeeks, data: makeData()),
            MockMyStatisticsCard(title: "4", subtitle: "Trips next four Weeks", type: .travelTripsNextFourWeeks, data: makeData()),
            MockMyStatisticsCard(title: "2", subtitle: "Of trips with time zone changed", type: .travelTripsMaxTimeZone, data: makeData()),
            MockMyStatisticsCard(title: "125", subtitle: "Number of trips this year", type: .travelTripsTotalInYear, data: makeData()),
            MockMyStatisticsCard(title: "13", subtitle: "Time zone  max time zone", type: .travelTripsTimeZoneChanged, data: makeData())
        ]
    }

    var peakPerformanceCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "11", subtitle: "Next Month", type: .peakPerformanceNextMonth, data: makeData()),
            MockMyStatisticsCard(title: "222", subtitle: "Average per week", type: .peakPerformanceAveragePerWeek, data: makeData()),
            MockMyStatisticsCard(title: "3333", subtitle: "Next week", type: .peakPerformanceNextWeek, data: makeData())
        ]
    }

    var activityCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "4.7H", subtitle: "Sitting / Movement Ratio", type: .activitySittingMovementRatio, data: makeData()),
            MockMyStatisticsCard(title: "6.3H", subtitle: "Activity level", type: .activityLevel, data: makeData())
        ]
    }
    
    var intensityCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "4.7H", subtitle: "ava", type: .intensity, data: makeData())
        ]
    }
}
