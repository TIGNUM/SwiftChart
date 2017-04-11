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

    func radius(for load: CGFloat, layout: Layout.MeSection) -> CGFloat {
        let factor: CGFloat = layout.radiusMaxLoad
        let offset: CGFloat = (layout.profileImageViewFrame.width * 0.5 + Layout.MeSection.loadOffset)
        return (load * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4)
    }

    func fillColor(radius: CGFloat, load: CGFloat, layout: Layout.MeSection) -> UIColor {
        return radius > average(for: load, layout: layout) ? Color.MeSection.redFilled : .white
    }

    func strokeColor(radius: CGFloat, load: CGFloat, layout: Layout.MeSection) -> UIColor {
        return radius > average(for: load, layout: layout) ? Color.MeSection.redStroke : Color.MeSection.whiteStroke
    }

    func labelValues(for sector: Sector, layout: Layout.MeSection) -> (font: UIFont, textColor: UIColor, widthOffset: CGFloat) {
        let criticalLoads = sector.spikes.filter { (spike: Spike) -> Bool in
            let distanceCenter = radius(for: spike.spikeLoad(), layout: layout)
            return distanceCenter > average(for: spike.load, layout: layout)
        }

        if criticalLoads.isEmpty == true {
            return (font: Font.MeSection.sectorDefault, textColor: Color.MeSection.whiteLabel, widthOffset: 0)
        }

        return (font: Font.MeSection.sectorRed, textColor: Color.MeSection.redFilled, widthOffset: 15)
    }

    private func average(for load: CGFloat, layout: Layout.MeSection) -> CGFloat {
        return (layout.radiusAverageLoad - (load * 4))
    }
}

struct SectorLabel {
    let text: String
    let angle: CGFloat
    let load: CGFloat
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
    var label: SectorLabel { get }
    var strokeColor: UIColor { get }
}

struct MockSpike: Spike {
    let localID: String
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
    let label: SectorLabel
    let strokeColor: UIColor
}

private var mockSectors: [Sector] {
    return [
        MockSector(
            startAngle: 240,
            endAngle: 264,
            spikes: peakSpikes,
            label: SectorLabel(text: R.string.localized.meSectorPeak(), angle: 245, load: 1.15),
            strokeColor: .magenta
        ),

        MockSector(
            startAngle: 200,
            endAngle: 239,
            spikes: meetingsSpikes,
            label: SectorLabel(text: R.string.localized.meSectorMeetings(), angle: 220, load: 1.15),
            strokeColor: .blue
        ),

        MockSector(
            startAngle: 176,
            endAngle: 199,
            spikes: intensitySpikes,
            label: SectorLabel(text: R.string.localized.meSectorIntensity(), angle: 195, load: 1.2),
            strokeColor: .yellow
        ),

        MockSector(
            startAngle: 137,
            endAngle: 175,
            spikes: travelSpikes,
            label: SectorLabel(text: R.string.localized.meSectorTravel(), angle: 170, load: 1.15),
            strokeColor: .green
        ),

        MockSector(
            startAngle: 120,
            endAngle: 136,
            spikes: sleepSpikes,
            label: SectorLabel(text: R.string.localized.meSectorSleep(), angle: 142, load: 1.1),
            strokeColor: .orange
        ),

        MockSector(
            startAngle: 100,
            endAngle: 119,
            spikes: activitySpikes,
            label: SectorLabel(text: R.string.localized.meSectorActivity(), angle: 120, load: 1.1),
            strokeColor: .cyan
        )
    ]
}

private var peakSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 260, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 252, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 244, load: randomNumber)
    ]
}

private var meetingsSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 236, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 228, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 220, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 212, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 204, load: randomNumber)
    ]
}

private var intensitySpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 196, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 188, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 180, load: randomNumber)
    ]
}

private var travelSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 172, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 164, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 156, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 148, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 140, load: randomNumber)
    ]
}

private var sleepSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 132, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 124, load: randomNumber)
    ]
}

private var activitySpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, angle: 116, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 108, load: randomNumber),
        MockSpike(localID: UUID().uuidString, angle: 100, load: randomNumber)
    ]
}
