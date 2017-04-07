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
    let spikes = mockSpikes
    let sectors = mockSectors
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var spikeCount: Int {
        return spikes.count
    }

    var sectorCount: Int {
        return sectors.count
    }

    func radius(for load: CGFloat) -> CGFloat {
        let factor: CGFloat = Layout.MeSection.radiusMaxLoad
        let offset: CGFloat = (Layout.MeSection.profileImageViewFrame.width * 0.5 + Layout.MeSection.loadOffset)
        return (load * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4)
    }

    func fillColor(radius: CGFloat, load: CGFloat) -> UIColor {
        let average = (Layout.MeSection.radiusAverageLoad - (load * 4))
        return radius > average ? Color.MeSection.redFilled : .white
    }

    func strokeColor(radius: CGFloat, load: CGFloat) -> UIColor {
        let average = (Layout.MeSection.radiusAverageLoad - (load * 4))
        return radius > average ? Color.MeSection.redStroke : Color.MeSection.whiteStroke
    }

    func sector(location: CGPoint) {
        let angleX = location.x.degreesToRadians
        let angleY = location.y.degreesToRadians

        let sinY = sin(angleY)
        let cosX = cos(angleX)

        print("angleX: \(angleX) - \(cosX)")
        print("angleY: \(angleY) - \(sinY)")
    }
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
}

private var mockSectors: [Sector] {
    return [
        MockSector(startAngle: 240, endAngle: 264),
        MockSector(startAngle: 200, endAngle: 239),
        MockSector(startAngle: 176, endAngle: 199),
        MockSector(startAngle: 120, endAngle: 175),
        MockSector(startAngle: 100, endAngle: 119)
    ]
}

private var mockSpikes: [Spike] {
    return [
        MockSpike(localID: UUID().uuidString, strokeColor: .magenta, angle: 260, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .magenta, angle: 252, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .magenta, angle: 244, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 236, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 228, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 220, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 212, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .blue, angle: 204, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .yellow, angle: 196, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .yellow, angle: 188, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .yellow, angle: 180, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 172, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 164, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 156, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 148, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .green, angle: 140, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .orange, angle: 132, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .orange, angle: 124, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .cyan, angle: 116, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .cyan, angle: 108, load: randomNumber),
        MockSpike(localID: UUID().uuidString, strokeColor: .cyan, angle: 100, load: randomNumber)
    ]
}

struct CategoryLabel {
    let text: String
    let angle: CGFloat
    let load: CGFloat

    static let allLabels: [CategoryLabel] = [
        CategoryLabel(text: R.string.localized.meSectorPeak(), angle: 245, load: 1.15),
        CategoryLabel(text: R.string.localized.meSectorMeetings(), angle: 220, load: 1.15),
        CategoryLabel(text: R.string.localized.meSectorIntensity(), angle: 195, load: 1.2),
        CategoryLabel(text: R.string.localized.meSectorTravel(), angle: 170, load: 1.15),
        CategoryLabel(text: R.string.localized.meSectorSleep(), angle: 145, load: 1.1),
        CategoryLabel(text: R.string.localized.meSectorActivity(), angle: 120, load: 1.1)
    ]
}
