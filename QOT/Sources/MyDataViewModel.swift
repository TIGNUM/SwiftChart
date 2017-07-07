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

    var profileImage: UIImage? {
        return myToBeVision?.profileImage
    }
    let sectors = mockSectors
    let updates = PublishSubject<CollectionUpdate, NoError>()
    private let myToBeVision: MyToBeVision?
    
    var sectorCount: Int {
        return sectors.count
    }

    func spike(for sector: Sector, at index: Index) -> Spike {
        return sector.spikes[index]
    }

    func sector(at index: Index) -> Sector {
        return sectors[index]
    }
    
    init(vision: MyToBeVision?) {
        self.myToBeVision = vision
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
    var localID: String { get }
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
    let localID: String
    let angle: CGFloat
    let load: CGFloat

    // TODO: What da hack! Actually the load is always from 0.1 to 0.9.
    func spikeLoad() -> CGFloat {
        return (load > 0.9 ? 0.9 : ((load < 0.15) ? 0.15 : load))
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

private var mockSectors: [Sector] {
    return [
        MockSector(
            startAngle: 219,
            endAngle: 234,
            spikes: peakSpikes,
            labelType: .peak,
            strokeColor: .magenta,
            type: .load
        ),

        MockSector(
            startAngle: 200,
            endAngle: 233,
            spikes: meetingsSpikes,
            labelType: .meetings,
            strokeColor: .blue,
            type: .load
        ),

        MockSector(
            startAngle: 176,
            endAngle: 199,
            spikes: intensitySpikes,
            labelType: .intensity,
            strokeColor: .yellow,
            type: .load
        ),

        MockSector(
            startAngle: 137,
            endAngle: 175,
            spikes: travelSpikes,
            labelType: .travel,
            strokeColor: .green,
            type: .load
        ),

        MockSector(
            startAngle: 120,
            endAngle: 136,
            spikes: sleepSpikes,
            labelType: .sleep,
            strokeColor: .orange,
            type: .bodyBrain
        ),

        MockSector(
            startAngle: 119,
            endAngle: 135,
            spikes: activitySpikes,
            labelType: .activity,
            strokeColor: .cyan,
            type: .bodyBrain
        )
    ]
}

private var peakSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 245, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 240, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 235, load: randomNumber)
    ]
}

private var meetingsSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 225, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 220, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 215, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 210, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 205, load: randomNumber)
    ]
}

private var intensitySpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 195, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 190, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 185, load: randomNumber)
    ]
}

private var travelSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 175, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 170, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 165, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 160, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 155, load: randomNumber)
    ]
}

private var sleepSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 145, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 140, load: randomNumber)
    ]
}

private var activitySpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 130, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 125, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 112, load: randomNumber)
    ]
}
