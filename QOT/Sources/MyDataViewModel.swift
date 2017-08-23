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

    func spikeLoad() -> CGFloat {
        if load < 0.15 {
            return 0.15
        } else if load > 0.9 {
            return 0.9
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
        MockSpike(angle: 245, load: service.universeValue(statistics: service.card(key: "peakPerformance.upcoming.week"))),
        MockSpike(angle: 235, load: service.universeValue(statistics: service.card(key: "peakPerformance.average.week")))
    ]
}

private func meetingsSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 225, load: service.universeValue(statistics: service.card(key: "meetings.number.day"))),
        MockSpike(angle: 215, load: service.universeValue(statistics: service.card(key: "meetings.length"))),
        MockSpike(angle: 205, load: service.universeValue(statistics: service.card(key: "meetings.timeBetween")))
    ]
}

private func intensitySpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 195, load: service.universeValue(statistics: service.card(key: "intentensity.week")))
    ]
}

private func travelSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 185, load: service.universeValue(statistics: service.card(key: "travel.numberOfMeetings.4weeks"))),
        MockSpike(angle: 175, load: service.universeValue(statistics: service.card(key: "travel.tripsNextFourWeeks"))),
        MockSpike(angle: 165, load: service.universeValue(statistics: service.card(key: "travel.timeZoneChange.week"))),
        MockSpike(angle: 155, load: service.universeValue(statistics: service.card(key: "travel.tripsMaxTimeZone")))
    ]
}

private func sleepSpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 145, load: service.universeValue(statistics: service.card(key: "sleep.quantity"))),
        MockSpike(angle: 135, load: service.universeValue(statistics: service.card(key: "sleep.quality")))
    ]
}

private func activitySpikes(service: MyStatisticsService) -> [Spike] {
    return [
        MockSpike(angle: 125, load: service.universeValue(statistics: service.card(key: "activity.sittingMovement"))),
        MockSpike(angle: 115, load: service.universeValue(statistics: service.card(key: "activity.level")))
    ]
}
