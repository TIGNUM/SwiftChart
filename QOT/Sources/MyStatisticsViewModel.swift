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
        case .activitySittingMovementRatio:
            let data: [EventGraphData] = [EventGraphData(start: 1, end: 0.4),
                                            EventGraphData(start: 1, end: 0.65),
                                            EventGraphData(start: 1, end: 0.2),
                                            EventGraphData(start: 1, end: 0.3),
                                            EventGraphData(start: 1, end: 0.8)]
            let threshold = StatisticsThreshold<CGFloat>(upperThreshold: 0.6, lowerThreshold: 0.2)

            return MyStatisticsDataActivity(teamAverage: 3.2, dataAverage: 5.4, userAverage: 2.1, teamActivityLevel: 1, dataActivityLevel: 0.55, userActivityLevel: 0.5, threshold: threshold, data: data, fillColumn: true)
        case .activityLevel:
            let data: [EventGraphData] = [EventGraphData(start: 1, end: 0.4),
                                            EventGraphData(start: 1, end: 0.65),
                                            EventGraphData(start: 1, end: 0.2),
                                            EventGraphData(start: 1, end: 0.3),
                                            EventGraphData(start: 1, end: 0.8)]
            let threshold = StatisticsThreshold<CGFloat>(upperThreshold: 0.6, lowerThreshold: 0.2)

            return MyStatisticsDataActivity(teamAverage: 3.2, dataAverage: 5.4, userAverage: 2.1, teamActivityLevel: 0.4, dataActivityLevel: 0.55, userActivityLevel: 0.5, threshold: threshold, data: data)
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
        case .peakPerformanceUpcoming:
            let lastWeek = Date().addingTimeInterval(-7 * 24 * 3600)
            let lastWeek8 = Date().addingTimeInterval(-8 * 24 * 3600)
            let lastWeek6 = Date().addingTimeInterval(-6 * 24 * 3600)
            let nextWeek = Date().addingTimeInterval(7 * 24 * 3600)
            let nextWeek10 = Date().addingTimeInterval(10 * 24 * 3600)

            let lastWeekPlus2h = lastWeek.addingTimeInterval(2 * 3600)
            let lastWeekMinus2h = lastWeek.addingTimeInterval(-2 * 3600)
            let nextWeekPlus5h = nextWeek.addingTimeInterval(5 * 3600)

            let periods: [Period] = [(start: lastWeek, duration: 3 * 3600),
                                     (start: lastWeek6, duration: 3 * 3600),
                                     (start: lastWeek8, duration: 3 * 3600),
                                     (start: lastWeekMinus2h, duration: 1 * 3600),
                                     (start: lastWeekPlus2h, duration: 4 * 3600),
                                     (start: nextWeek, duration: 1 * 3600),
                                     (start: nextWeek10, duration: 2 * 3600),
                                     (start: nextWeekPlus5h, duration: 16 * 3600)]

            return MyStatisticsDataPeriods(teamData: [DataDisplayType.lastWeek.id(): 3.5, DataDisplayType.nextWeek.id(): 15],
                                           dataData: [DataDisplayType.lastWeek.id(): 4.7, DataDisplayType.nextWeek.id(): 15],
                                           userData: [DataDisplayType.lastWeek.id(): 7, DataDisplayType.nextWeek.id(): 32],
                                           periods: periods,
                                           statsPeriods: [DataDisplayType.lastWeek.id(): ChartDimensions(columns: 7, rows: 24, length: 3600), DataDisplayType.nextWeek.id(): ChartDimensions(columns: 7, rows: 24, length: 3600)],
                                           thresholds: [DataDisplayType.lastWeek.id(): (upperThreshold: 12800, lowerThreshold: 4000), DataDisplayType.nextWeek.id(): (upperThreshold: 500000, lowerThreshold: 200000)],
                                           displayType: .lastWeek)
        case .peakPerformanceAverage:
            return MyStatisticsDataPeriodAverage(teamData: [DataDisplayType.week.id(): 3.5, DataDisplayType.month.id(): 15],
                                                 dataData: [DataDisplayType.week.id(): 4.7, DataDisplayType.month.id(): 15],
                                                 userData: [DataDisplayType.week.id(): 7, DataDisplayType.month.id(): 32],
                                                 maxData: [DataDisplayType.week.id(): 12, DataDisplayType.month.id(): 50],
                                                 thresholds: [DataDisplayType.week.id(): (upperThreshold: 0.8, lowerThreshold: 0.5), DataDisplayType.month.id(): (upperThreshold: 0.8, lowerThreshold: 0.5)])
        case .travelTripsMeeting:
            let now = Date()
            let now3 = now.addingTimeInterval(3 * 24 * 3600)

            let nowWeek = now.addingTimeInterval(7 * 24 * 3600)
            let now145 = now.addingTimeInterval(-145 * 24 * 3600)
            let now245 = now.addingTimeInterval(-245 * 24 * 3600)

            let periods: [Period] = [(start: now, duration: 12 * 3600),
                                     (start: now3, duration: 24 * 3600),
                                    (start: now145, duration: 12 * 24 * 3600),
                                    (start: now245, duration: 2 * 24 * 3600),
                                    (start: nowWeek, duration: 6 * 3600)]
            
            return MyStatisticsDataPeriods(teamData: [DataDisplayType.weeks.id(): 3.5, DataDisplayType.year.id(): 15],
                                           dataData: [DataDisplayType.weeks.id(): 4.7, DataDisplayType.year.id(): 15],
                                           userData: [DataDisplayType.weeks.id(): 7, DataDisplayType.year.id(): 32],
                                           periods: periods,
                                           statsPeriods: [DataDisplayType.weeks.id(): ChartDimensions(columns: 4, rows: 7, length: 24), DataDisplayType.year.id(): ChartDimensions(columns: 12, rows: 5, length: 7)],
                                           thresholds: [DataDisplayType.weeks.id(): (upperThreshold: 12800, lowerThreshold: 4000), DataDisplayType.year.id(): (upperThreshold: 500000, lowerThreshold: 200000)])
        case .travelTripsNextFourWeeks:
            let userTrips: UserUpcomingTrips = [[1, 2, 1, 0, 1, 0, 1],
                                                [2, 0, 1, 3, 1, 1, 0],
                                                [0, 1, 1, 5, 1, 0, 0],
                                                [1, 0, 1, 0, 2, 0, 0]]
            let labels: [String] = ["+1", "+2", "+3", "+4"]

            return MyStatisticsDataUpcomingTrips(teamAverage: 24.2, dataAverage: 32.1, userAverage: 24.9, userUpcomingTrips: userTrips, labels: labels)
        case .travelTripsTimeZoneChanged:
            let now = Date()
            let now3 = now.addingTimeInterval(3 * 24 * 3600)

            let nowWeek = now.addingTimeInterval(7 * 24 * 3600)
            let now145 = now.addingTimeInterval(-145 * 24 * 3600)
            let now245 = now.addingTimeInterval(-245 * 24 * 3600)

            let periods: [Period] = [(start: now, duration: 12 * 3600),
                                     (start: now3, duration: 24 * 3600),
                                     (start: now145, duration: 12 * 24 * 3600),
                                     (start: now245, duration: 2 * 24 * 3600),
                                     (start: nowWeek, duration: 6 * 3600)]

            return MyStatisticsDataPeriods(teamData: [DataDisplayType.weeks.id(): 3.5, DataDisplayType.year.id(): 15],
                                           dataData: [DataDisplayType.weeks.id(): 4.7, DataDisplayType.year.id(): 15],
                                           userData: [DataDisplayType.weeks.id(): 7, DataDisplayType.year.id(): 32],
                                           periods: periods,
                                           statsPeriods: [DataDisplayType.weeks.id(): ChartDimensions(columns: 4, rows: 7, length: 24), DataDisplayType.year.id(): ChartDimensions(columns: 12, rows: 5, length: 7)],
                                           thresholds: [DataDisplayType.weeks.id(): (upperThreshold: 12800, lowerThreshold: 4000), DataDisplayType.year.id(): (upperThreshold: 500000, lowerThreshold: 200000)])
        case .travelTripsMaxTimeZone:
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
            MockMyStatisticsCard(title: "125", subtitle: "Average number of meetings", type: .travelTripsMeeting, data: makeData(.travelTripsMeeting)),
            MockMyStatisticsCard(title: "4", subtitle: "Trips next four Weeks", type: .travelTripsNextFourWeeks, data: makeData(.travelTripsNextFourWeeks)),
            MockMyStatisticsCard(title: "2", subtitle: "# Of trips with time zone changed", type: .travelTripsTimeZoneChanged, data: makeData(.travelTripsTimeZoneChanged)),
            MockMyStatisticsCard(title: "#11", subtitle: "Time zone  max time zone", type: .travelTripsMaxTimeZone, data: makeData(.travelTripsMaxTimeZone))
        ]
    }

    var peakPerformanceCards: [MyStatisticsCard] {
        return [
            MockMyStatisticsCard(title: "11", subtitle: "# of upcoming peak peak performances", type: .peakPerformanceUpcoming, data: makeData(.peakPerformanceUpcoming)),
            MockMyStatisticsCard(title: "222", subtitle: "Average number of peak performances", type: .peakPerformanceAverage, data: makeData(.peakPerformanceAverage))
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
