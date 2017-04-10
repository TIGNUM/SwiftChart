//
//  MeSectionViewModel.swift
//  QOT
//
//  Created by karmic on 04.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class MeSectionViewModel {

    // MARK: - Properties

    let profileImage = R.image.profileImage()
    let sectors = mockSectors
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectorCount: Int {
        return mockSectors.count
    }

    func spike(for sector: Sector, at index: Index) -> Spike {
        return sector.spikes[index]
    }

    func sector(at index: Index) -> Sector {
        return sectors[index]
    }

    func radius(for load: CGFloat) -> CGFloat {
        let factor: CGFloat = Layout.MeSection.radiusMaxLoad
        let offset: CGFloat = (Layout.MeSection.profileImageViewFrame.width * 0.5 + Layout.MeSection.loadOffset)
        return (load * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4)
    }

    func fillColor(radius: CGFloat, load: CGFloat) -> UIColor {
        return radius > average(for: load) ? Color.MeSection.redFilled : .white
    }

    func strokeColor(radius: CGFloat, load: CGFloat) -> UIColor {
        return radius > average(for: load) ? Color.MeSection.redStroke : Color.MeSection.whiteStroke
    }

    func labelValues(for sector: Sector) -> (font: UIFont, textColor: UIColor) {
        let criticalLoads = sector.spikes.filter { (spike: Spike) -> Bool in
            let distanceCenter = radius(for: spike.spikeLoad())
            return distanceCenter > average(for: spike.load)
        }

        if criticalLoads.isEmpty == true {
            return (font: Font.MeSection.sectorDefault, textColor: Color.MeSection.whiteLabel)
        }

        return (font: Font.MeSection.sectorRed, textColor: Color.MeSection.redFilled)
    }

    private func average(for load: CGFloat) -> CGFloat {
        return (Layout.MeSection.radiusAverageLoad - (load * 4))
    }
}

struct SectorLabel {
    let text: String
    let angle: CGFloat
    let load: CGFloat
}

protocol Spike {
    var localID: String { get }
    var strokeColor: UIColor { get }
    var angle: CGFloat { get }
    var load: CGFloat { get }

    func spikeLoad() -> CGFloat
}

protocol Sector {
    var startAngle: CGFloat { get }
    var endAngle: CGFloat { get }
    var spikes: [Spike] { get }
    var label: SectorLabel { get }
}

struct MockSpike: Spike {
    let localID: String
    let strokeColor: UIColor
    let angle: CGFloat
    let load: CGFloat

    // TODO: What da hack! Actually the load is always from 0.1 to 0.9.
    func spikeLoad() -> CGFloat {
        return (load > 0.9 ? 0.9 : ((load < 0.1) ? 0.1 : load))
    }
}

struct MockSector: Sector {
    let startAngle: CGFloat
    let endAngle: CGFloat
    let spikes: [Spike]
    var label: SectorLabel
}

private var mockSectors: [Sector] {
    return [
        MockSector(
            startAngle: 240,
            endAngle: 264,
            spikes: peakSpikes,
            label: SectorLabel(text: R.string.localized.meSectorPeak(), angle: 245, load: 1.16)
        ),

        MockSector(
            startAngle: 200,
            endAngle: 239,
            spikes: meetingsSpikes,
            label: SectorLabel(text: R.string.localized.meSectorMeetings(), angle: 220, load: 1.18)
        ),

        MockSector(
            startAngle: 176,
            endAngle: 199,
            spikes: intensitySpikes,
            label: SectorLabel(text: R.string.localized.meSectorIntensity(), angle: 195, load: 1.23)
        ),

        MockSector(
            startAngle: 137,
            endAngle: 175,
            spikes: travelSpikes,
            label: SectorLabel(text: R.string.localized.meSectorTravel(), angle: 170, load: 1.16)
        ),

        MockSector(
            startAngle: 120,
            endAngle: 136,
            spikes: sleepSpikes,
            label: SectorLabel(text: R.string.localized.meSectorSleep(), angle: 145, load: 1.1)
        ),

        MockSector(
            startAngle: 100,
            endAngle: 119,
            spikes: activitySpikes,
            label: SectorLabel(text: R.string.localized.meSectorActivity(), angle: 120, load: 1.1)
        )
    ]
}

private var peakSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .magenta, angle: 260, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .magenta, angle: 252, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .magenta, angle: 244, load: randomNumber)
    ]
}

private var meetingsSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 236, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 228, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 220, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 212, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 204, load: randomNumber)
    ]
}

private var intensitySpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .yellow, angle: 196, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .yellow, angle: 188, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .yellow, angle: 180, load: randomNumber)
    ]
}

private var travelSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 172, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 164, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 156, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 148, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 140, load: randomNumber)
    ]
}

private var sleepSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .orange, angle: 132, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .orange, angle: 124, load: randomNumber)
    ]
}

private var activitySpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .cyan, angle: 116, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .cyan, angle: 108, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .cyan, angle: 100, load: randomNumber)
    ]
}
