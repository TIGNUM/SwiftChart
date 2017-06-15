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
    var data: MyStatisticsData { get }
}

struct MockMyStatisticsCard: MyStatisticsCard {
    let title: String
    let subtitle: String
    let type: MyStatisticsCardType
    let data: MyStatisticsData
}

enum MyStatisticsCardType {
    case meetingAverage
    case meetingLength
    case meetingTimeBetween
    case meetingHeartRateChange
    case travelTripsLastFourWeeks
    case travelTripsNextFourWeeks
    case travelTripsTimeZoneChanged
    case travelTripsTotalInYear
    case travelTripsMaxTimeZone
    case peakPerformanceNextMonth
    case peakPerformanceAverage
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

    private func makeData(_ cardType: MyStatisticsCardType) -> MyStatisticsData {
        switch cardType {
        case .meetingAverage:
            return MyStatisticsDataPeriodAverage(teamData: [DataDisplayType.day.id(): 3.5, DataDisplayType.week.id(): 15],
                                                 dataData: [DataDisplayType.day.id(): 4.7, DataDisplayType.week.id(): 17],
                                                 userData: [DataDisplayType.day.id(): 5.9, DataDisplayType.week.id(): 32],
                                                 maxData: [DataDisplayType.day.id(): 12, DataDisplayType.week.id(): 50],
                                                 thresholds: [DataDisplayType.day.id(): (upperThreshold: 0.8, lowerThreshold: 0.5), DataDisplayType.week.id(): (upperThreshold: 0.8, lowerThreshold: 0.5)],
                                                 displayType: .day)
        case .meetingLength:
            return MyStatisticsDataAverage(teamAverage: 148, dataAverage: 178, userAverage: 42, maximum: 200, threshold: (upperThreshold: 120, lowerThreshold: 45))
        case .meetingTimeBetween:
            return MyStatisticsDataAverage(teamAverage: 148, dataAverage: 178, userAverage: 42, maximum: 200, threshold: (upperThreshold: 120, lowerThreshold: 45))
        case .peakPerformanceAverage:
            return MyStatisticsDataPeriodAverage(teamData: [DataDisplayType.week.id(): 3.5, DataDisplayType.month.id(): 15],
                                                 dataData: [DataDisplayType.week.id(): 4.7, DataDisplayType.month.id(): 15],
                                                 userData: [DataDisplayType.week.id(): 7, DataDisplayType.month.id(): 32],
                                                 maxData: [DataDisplayType.week.id(): 12, DataDisplayType.month.id(): 50],
                                                 thresholds: [DataDisplayType.week.id(): (upperThreshold: 0.8, lowerThreshold: 0.5), DataDisplayType.month.id(): (upperThreshold: 0.8, lowerThreshold: 0.5)])
        case .travelTripsTimeZoneChanged:
            return MyStatisticsDataAverage(teamAverage: 148, dataAverage: 178, userAverage: 42, maximum: 200, threshold: (upperThreshold: 120, lowerThreshold: 45))
        default:
            return MyStatisticsDataAverage(teamAverage: 148, dataAverage: 178, userAverage: 42, maximum: 200, threshold: (upperThreshold: 120, lowerThreshold: 45))
        }
    }

    var sleepCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "8.5H", subtitle: "Sleep Quantity", type: .sleepQuantity, data: makeData(.sleepQuantity)),
            MockMyStatisticsCard(title: "7.5H", subtitle: "Sleep Quality", type: .sleepQuality, data: makeData(.sleepQuality))
        ]
    }

    var meetingCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "#11", subtitle: "Number of Meetings", type: .meetingAverage, data: makeData(.meetingAverage)),
            MockMyStatisticsCard(title: "2.4H", subtitle: "Length of Meetings", type: .meetingLength, data: makeData(.meetingLength)),
            MockMyStatisticsCard(title: "1.5H", subtitle: "Time Between Meetings", type: .meetingTimeBetween, data: makeData(.meetingTimeBetween))
        ]
    }

    var travelCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "25", subtitle: "Trips last four weeks", type: .travelTripsLastFourWeeks, data: makeData(.travelTripsLastFourWeeks)),
            MockMyStatisticsCard(title: "4", subtitle: "Trips next four Weeks", type: .travelTripsNextFourWeeks, data: makeData(.travelTripsNextFourWeeks)),
            MockMyStatisticsCard(title: "2", subtitle: "Of trips with time zone changed", type: .travelTripsMaxTimeZone, data: makeData(.travelTripsMaxTimeZone)),
            MockMyStatisticsCard(title: "125", subtitle: "Number of trips this year", type: .travelTripsTotalInYear, data: makeData(.travelTripsTotalInYear)),
            MockMyStatisticsCard(title: "#11", subtitle: "Time zone  max time zone", type: .travelTripsTimeZoneChanged, data: makeData(.travelTripsTimeZoneChanged))
        ]
    }

    var peakPerformanceCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "11", subtitle: "Next Month", type: .peakPerformanceNextMonth, data: makeData(.peakPerformanceNextMonth)),
            MockMyStatisticsCard(title: "222", subtitle: "Average number of peak performances", type: .peakPerformanceAverage, data: makeData(.peakPerformanceAverage)),
            MockMyStatisticsCard(title: "3333", subtitle: "Next week", type: .peakPerformanceNextWeek, data: makeData(.peakPerformanceNextWeek))
        ]
    }

    var activityCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "4.7H", subtitle: "Sitting / Movement Ratio", type: .activitySittingMovementRatio, data: makeData(.activitySittingMovementRatio)),
            MockMyStatisticsCard(title: "6.3H", subtitle: "Activity level", type: .activityLevel, data: makeData(.activityLevel))
        ]
    }
    
    var intensityCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "4.7H", subtitle: "ava", type: .intensity, data: makeData(.intensity))
        ]
    }
}
