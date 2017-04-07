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

    func centerPointValues(load: CGFloat) -> (radius: CGFloat, load: CGFloat) {
        var resultLoad = load
        let factor: CGFloat = Layout.MeSection.radiusMaxLoad
        let offset: CGFloat = (50 + Layout.MeSection.loadOffset)
        let radius: CGFloat = (resultLoad * (factor - Layout.MeSection.loadOffset)) + (offset * 0.4)

        return (radius: radius, load: resultLoad)
    }

    func fillColor(radius: CGFloat, load: CGFloat) -> UIColor {
        let average = (Layout.MeSection.radiusAverageLoad - (load * 4))
        return radius > average ? .red : .white
    }

    func strokeColor(radius: CGFloat, load: CGFloat) -> UIColor {
        let average = (Layout.MeSection.radiusAverageLoad - (load * 4))
        return radius > average ? UIColor(red: 1, green: 0, blue: 0, alpha: 0.8) : UIColor(white: 1, alpha: 0.7)
    }
}

protocol Spike {
    var localID: String { get }
    var strokeColor: UIColor { get }
    var angle: CGFloat { get }
    var load: CGFloat { get }
}

struct MockSpike: Spike {
    let localID: String
    let strokeColor: UIColor
    let angle: CGFloat
    let load: CGFloat
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
    let textColor: UIColor
    let angle: CGFloat
    let load: CGFloat

    static let allLabels: [CategoryLabel] = [
        CategoryLabel(text: "Peak", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 245, load: 1.1),
        CategoryLabel(text: "Meetings", textColor: .red, angle: 220, load: 1.25),
        CategoryLabel(text: "Intensity", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 195, load: 1.3),
        CategoryLabel(text: "Travel", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 170, load: 1.2),
        CategoryLabel(text: "Sleep", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 145, load: 1.1),
        CategoryLabel(text: "Activity", textColor: UIColor(white: 0.7, alpha: 0.6), angle: 120, load: 1.1)
    ]
}
