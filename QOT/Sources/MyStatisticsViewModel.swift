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

    private let sections = myStatisticsSections
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var numberOfSections: Int {
        return myStatisticsSections.count
    }

    func titleForSection(section: Int) -> String {
        switch section {
        case 0: return "Meeting"
        case 1: return "Travel"
        case 2: return "Peak Performance"
        case 3: return "Sleep"
        case 4: return "Activity"
        default: fatalError("Out of bounds")
        }
    }

    func numberOfItems(in section: Int) -> Int {
        return cards(in: section).count
    }

    func card(for indexPath: IndexPath) -> MyStatisticsCard {
        return cards(in: indexPath.section)[indexPath.row]
    }

    private func cards(in section: Int) -> [MyStatisticsCard] {
        return sections[section]
    }
}

// MARK: - Mocks

protocol MyStatisticsCard {
    var title: String { get }
    var subtitle: String { get }
    var type: MyStatisticsCardType { get }
}

struct MockMyStatisticsCard: MyStatisticsCard {
    let title: String
    let subtitle: String
    let type: MyStatisticsCardType
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
}

private var myStatisticsSections: [[MyStatisticsCard]] {
    return [
        meetings, travel, peakPerformance, sleep, activity
    ]
}

private var meetings: [MyStatisticsCard] {
    return [
        MockMyStatisticsCard(title: "8/8", subtitle: "Weekly Meeting", type: .meetingWeekly),
        MockMyStatisticsCard(title: "1:25m", subtitle: "Daily Meeting", type: .meetingDaily),
        MockMyStatisticsCard(title: "1:25m", subtitle: "Meeting Length", type: .meetingLength),
        MockMyStatisticsCard(title: "1:25m", subtitle: "Time in Between", type: .meetingTimeBetween),
        MockMyStatisticsCard(title: "1:25m", subtitle: "Heart rate change", type: .meetingHeartRateChange)
    ]
}

private var travel: [MyStatisticsCard] {
    return [
        MockMyStatisticsCard(title: "1:25m", subtitle: "Trips last four weeks", type: .travelTripsLastFourWeeks),
        MockMyStatisticsCard(title: "1:25m", subtitle: "Trips next four Weeks", type: .travelTripsNextFourWeeks),
        MockMyStatisticsCard(title: "1:25m", subtitle: "of trips with time zone changed", type: .travelTripsMaxTimeZone),
        MockMyStatisticsCard(title: "1:25m", subtitle: "# of trips this year", type: .travelTripsTotalInYear),
        MockMyStatisticsCard(title: "1:25m", subtitle: "time zone  max time zone", type: .travelTripsTimeZoneChanged)
    ]
}

private var peakPerformance: [MyStatisticsCard] {
    return [
        MockMyStatisticsCard(title: "1:25m", subtitle: "Next Month", type: .peakPerformanceNextMonth),
        MockMyStatisticsCard(title: "1:25m", subtitle: "Average per week", type: .peakPerformanceAveragePerWeek),
        MockMyStatisticsCard(title: "1:25m", subtitle: "next week", type: .peakPerformanceNextWeek)
    ]
}

private var sleep: [MyStatisticsCard] {
    return [
        MockMyStatisticsCard(title: "1:25m", subtitle: "Sleep Quantity", type: .sleepQuantity),
        MockMyStatisticsCard(title: "7", subtitle: "Sleep Quality", type: .sleepQuality)
    ]
}

private var activity: [MyStatisticsCard] {
    return [
        MockMyStatisticsCard(title: "7", subtitle: "sitting/movement ratio", type: .activitySittingMovementRatio),
        MockMyStatisticsCard(title: "7", subtitle: "Activity level", type: .activityLevel)
    ]
}
