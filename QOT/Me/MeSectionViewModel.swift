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
    let items = mockSpikes
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> Spike {
        return items[indexPath.row]
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
}

protocol Spike {
    var localID: String { get }
    var strokeColor: UIColor { get }
    var angle: CGFloat { get }
    var load: CGFloat { get }

    func spikeLoad() -> CGFloat
}

struct MockSpike: Spike {
    let localID: String
    let strokeColor: UIColor
    let angle: CGFloat
    let load: CGFloat

    // TODO: What da hack! Actually the is always from 0.1 to 0.9.
    func spikeLoad() -> CGFloat {
        return (load > 0.9 ? 0.9 : ((load < 0.1) ? 0.1 : load))
    }
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
