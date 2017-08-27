//
//  MyDataViewModel.swift
//  QOT
//
//  Created by karmic on 04.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MyDataViewModel {

    // MARK: - Properties

    private let services: Services
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var profileImageResource: MediaResource? {
        return services.userService.myToBeVision()?.profileImageResource
    }

    var sectorCount: Int {
        return sectors.count
    }

    var sectors: [Sector] {
        return mockSectors(service: services.myStatisticsService)
    }

    func spike(for sector: Sector, at index: Index) -> Spike {
        return sector.spikes[index]
    }

    func sector(at index: Index) -> Sector {
        return sectors[index]
    }
    
    init(services: Services) {
        self.services = services
    }
}

// MARK: - Mocks

enum SectorType {
    case bodyBrain
    case load

    func lineWidth(load: CGFloat) -> CGFloat {
        switch self {
        case .load: return load * 16
        case .bodyBrain: return load * 2
        }
    }
}

enum SectorLabelType {
    case peak
    case meetings
    case intensity
    case travel
    case sleep
    case activity

    var text: String {
        switch self {
        case .peak: return R.string.localized.meSectorPeak()
        case .meetings: return R.string.localized.meSectorMeetings()
        case .intensity: return R.string.localized.meSectorIntensity()
        case .travel: return R.string.localized.meSectorTravel()
        case .sleep: return R.string.localized.meSectorSleep()
        case .activity: return R.string.localized.meSectorActivity()
        }
    }

    var angle: CGFloat {
        switch self {
        case .peak: return 229
        case .meetings: return 211
        case .intensity: return 187
        case .travel: return 165
        case .sleep: return 145
        case .activity: return 128
        }
    }

    var load: CGFloat {
        switch self {
        case .peak: return 1.3
        case .meetings: return 1.28
        case .intensity: return 1.27
        case .travel: return 1.17
        case .sleep: return 1.1
        case .activity: return 1.1
        }
    }
}

protocol Spike {

    var angle: CGFloat { get }

    var load: CGFloat { get }

    func spikeLoad() -> CGFloat
}

protocol Sector {

    var startAngle: CGFloat { get }

    var endAngle: CGFloat { get }

    var spikes: [Spike] { get }

    var labelType: SectorLabelType { get }

    var strokeColor: UIColor { get }

    var type: SectorType { get }
}

struct MockSpike: Spike {
    let angle: CGFloat
    let load: CGFloat

    //FIXME
    func spikeLoad() -> CGFloat {
        if load < 0.15 {
            return 0.15
        } else if load > 0.98 {
            return 0.98
        } else {
            return load
        }
    }
}

struct MockSector: Sector {
    let startAngle: CGFloat
    let endAngle: CGFloat
    let spikes: [Spike]
    let labelType: SectorLabelType
    let strokeColor: UIColor
    let type: SectorType
}

private func mockSectors(service: MyStatisticsService) -> [Sector] {
    return [
        MockSector(
            startAngle: 219,
            endAngle: 234,
            spikes: peakSpikes(service: service),
            labelType: .peak,
            strokeColor: .magenta,
            type: .load
        ),

        MockSector(
            startAngle: 200,
            endAngle: 233,
            spikes: meetingsSpikes(service: service),
            labelType: .meetings,
            strokeColor: .blue,
            type: .load
        ),

        MockSector(
            startAngle: 176,
            endAngle: 199,
            spikes: intensitySpikes(service: service),
            labelType: .intensity,
            strokeColor: .yellow,
            type: .load
        ),

        MockSector(
            startAngle: 137,
            endAngle: 175,
            spikes: travelSpikes(service: service),
            labelType: .travel,
            strokeColor: .green,
            type: .load
        ),

        MockSector(
            startAngle: 120,
            endAngle: 136,
            spikes: sleepSpikes(service: service),
            labelType: .sleep,
            strokeColor: .orange,
            type: .bodyBrain
        ),

        MockSector(
            startAngle: 119,
            endAngle: 135,
            spikes: activitySpikes(service: service),
            labelType: .activity,
            strokeColor: .cyan,
            type: .bodyBrain
        )
    ]
}

private func peakSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 245, load: service.card(key: StatisticCardType.peakPerformanceUpcomingWeek.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 235, load: service.card(key: StatisticCardType.peakPerformanceAverageWeek.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func meetingsSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 225, load: service.card(key: StatisticCardType.meetingAverageDay.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 215, load: service.card(key: StatisticCardType.meetingLength.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 205, load: service.card(key: StatisticCardType.meetingTimeBetween.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func intensitySpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 195, load: service.card(key: StatisticCardType.intensityLoadWeek.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 185, load: service.card(key: StatisticCardType.intensityRecoveryWeek.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func travelSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 175, load: service.card(key: StatisticCardType.travelTripsAverageWeeks.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 165, load: service.card(key: StatisticCardType.travelTripsNextFourWeeks.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 155, load: service.card(key: StatisticCardType.travelTripsTimeZoneChangedWeeks.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 145, load: service.card(key: StatisticCardType.travelTripsMaxTimeZone.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func sleepSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 135, load: service.card(key: StatisticCardType.sleepQuantity.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 125, load: service.card(key: StatisticCardType.sleepQuality.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func activitySpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 115, load: service.card(key: StatisticCardType.activitySittingMovementRatio.rawValue)?.universe.toFloat ?? 0),
        MockSpike(angle: 105, load: service.card(key: StatisticCardType.activityLevel.rawValue)?.universe.toFloat ?? 0)
    ]
}
