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
        return chartSectors(service: services.statisticsService)
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

// MARK: - Sectors

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
    case intensity
    case meetings
    case travel
    case sleep
    case activity

    var text: String {
        switch self {
        case .peak: return R.string.localized.meSectorPeak()
        case .intensity: return R.string.localized.meSectorIntensity()
        case .meetings: return R.string.localized.meSectorMeetings()
        case .travel: return R.string.localized.meSectorTravel()
        case .sleep: return R.string.localized.meSectorSleep()
        case .activity: return R.string.localized.meSectorActivity()
        }
    }

    var angle: CGFloat {
        switch self {
        case .peak: return 229
        case .intensity: return 211
        case .meetings: return 187
        case .travel: return 165
        case .sleep: return 145
        case .activity: return 128
        }
    }

    var load: CGFloat {
        switch self {
        case .peak: return 1.3
        case .intensity: return 1.28
        case .meetings: return 1.27
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

struct ChartSpike: Spike {
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

struct ChartSector: Sector {
    let startAngle: CGFloat
    let endAngle: CGFloat
    let spikes: [Spike]
    let labelType: SectorLabelType
    let strokeColor: UIColor
    let type: SectorType
}

private func chartSectors(service: StatisticsService) -> [Sector] {
    return [
        ChartSector(
            startAngle: 219,
            endAngle: 234,
            spikes: peakSpikes(service: service),
            labelType: .peak,
            strokeColor: .magenta,
            type: .load
        ),

        ChartSector(
            startAngle: 184,
            endAngle: 233,
            spikes: intensitySpikes(service: service),
            labelType: .intensity,
            strokeColor: .blue,
            type: .load
        ),

        ChartSector(
            startAngle: 166,
            endAngle: 183,
            spikes: meetingsSpikes(service: service),
            labelType: .meetings,
            strokeColor: .yellow,
            type: .load
        ),

        ChartSector(
            startAngle: 137,
            endAngle: 165,
            spikes: travelSpikes(service: service),
            labelType: .travel,
            strokeColor: .green,
            type: .load
        ),

        ChartSector(
            startAngle: 120,
            endAngle: 136,
            spikes: sleepSpikes(service: service),
            labelType: .sleep,
            strokeColor: .orange,
            type: .bodyBrain
        ),

        ChartSector(
            startAngle: 119,
            endAngle: 135,
            spikes: activitySpikes(service: service),
            labelType: .activity,
            strokeColor: .cyan,
            type: .bodyBrain
        )
    ]
}

private func peakSpikes(service: StatisticsService) -> [Spike] {
    return [
        ChartSpike(angle: 245, load: service.chart(key: ChartType.peakPerformanceUpcomingWeek.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 235, load: service.chart(key: ChartType.peakPerformanceAverageWeek.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func intensitySpikes(service: StatisticsService) -> [Spike] {
    return [
        ChartSpike(angle: 225, load: service.chart(key: ChartType.intensityLoadWeek.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 215, load: service.chart(key: ChartType.intensityRecoveryWeek.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func meetingsSpikes(service: StatisticsService) -> [Spike] {
    return [
        ChartSpike(angle: 205, load: service.chart(key: ChartType.meetingAverageDay.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 195, load: service.chart(key: ChartType.meetingLength.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 185, load: service.chart(key: ChartType.meetingTimeBetween.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func travelSpikes(service: StatisticsService) -> [Spike] {
    return [
        ChartSpike(angle: 175, load: service.chart(key: ChartType.travelTripsAverageWeeks.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 165, load: service.chart(key: ChartType.travelTripsNextFourWeeks.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 155, load: service.chart(key: ChartType.travelTripsTimeZoneChangedWeeks.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 145, load: service.chart(key: ChartType.travelTripsMaxTimeZone.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func sleepSpikes(service: StatisticsService) -> [Spike] {
    return [
        ChartSpike(angle: 135, load: service.chart(key: ChartType.sleepQuantity.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 125, load: service.chart(key: ChartType.sleepQuality.rawValue)?.universe.toFloat ?? 0)
    ]
}

private func activitySpikes(service: StatisticsService) -> [Spike] {
    return [
        ChartSpike(angle: 115, load: service.chart(key: ChartType.activitySittingMovementRatio.rawValue)?.universe.toFloat ?? 0),
        ChartSpike(angle: 105, load: service.chart(key: ChartType.activityLevel.rawValue)?.universe.toFloat ?? 0)
    ]
}
