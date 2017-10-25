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

    var load: CGFloat {
        return 1.1
    }
    
    var sectionType: StatisticsSectionType {
        switch self {
        case .activity: return .activity
        case .intensity: return .intensity
        case .meetings: return .meetings
        case .peak: return .peakPerformance
        case .sleep: return .sleep
        case .travel: return .travel
        }
    }
    
    func angle(for sector: Sector) -> CGFloat {
        return (sector.startAngle + sector.endAngle) / 2
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

struct SectorLabel {
    var label: UILabel
    var sector: Sector
}

struct ChartSpike: Spike {
    let angle: CGFloat
    let load: CGFloat
    
    private let min: CGFloat = 0.15
    private let max: CGFloat = 0.98
    private let divisions: Int = 4 // must be >= 2. represents divisions in the grid that we snap the spikeLoad to
    private let grid: [CGFloat]
    
    init(angle: CGFloat, load: CGFloat) {
        self.angle = angle
        self.load = load
        
        let jumpValue = (max - min) / CGFloat(divisions - 1)
        var grid = [min]
        for i in 1..<divisions {
            grid.append(grid[i-1] + jumpValue)
        }
        self.grid = grid
    }
    
    func spikeLoad() -> CGFloat {
        var gridIndex = -1
        for (index, value) in grid.enumerated() where load <= value {
            gridIndex = index
            break
        }
        if gridIndex == -1 {
            gridIndex = grid.endIndex - 1
        }
        return grid[gridIndex]
    }
}

struct ChartSector: Sector {
    var startAngle: CGFloat {
        guard spikes.count > 0 else {
            return 0.0
        }
        var result = spikes[0]
        for i in 1..<spikes.count where spikes[i].angle < result.angle {
            result = spikes[i]
        }
        return result.angle
    }
    var endAngle: CGFloat {
        guard spikes.count > 0 else {
            return 0.0
        }
        var result = spikes[0]
        for i in 1..<spikes.count where spikes[i].angle > result.angle {
            result = spikes[i]
        }
        return result.angle
    }
    let spikes: [Spike]
    let labelType: SectorLabelType
    let strokeColor: UIColor
    let type: SectorType
}

struct ChartDataPoint {
    let dot: CALayer
    let sector: Sector
    let frame: CGRect
}

private func chartSectors(service: StatisticsService) -> [ChartSector] {
    return [
        ChartSector(
            spikes: peakSpikes(service: service),
            labelType: .peak,
            strokeColor: .magenta,
            type: .load
        ),

        ChartSector(
            spikes: intensitySpikes(service: service),
            labelType: .intensity,
            strokeColor: .blue,
            type: .load
        ),

        ChartSector(
            spikes: meetingsSpikes(service: service),
            labelType: .meetings,
            strokeColor: .yellow,
            type: .load
        ),

        ChartSector(
            spikes: travelSpikes(service: service),
            labelType: .travel,
            strokeColor: .green,
            type: .load
        ),

        ChartSector(
            spikes: sleepSpikes(service: service),
            labelType: .sleep,
            strokeColor: .orange,
            type: .bodyBrain
        ),

        ChartSector(
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
