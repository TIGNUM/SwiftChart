//
//  SettingsMenuViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 13/04/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class SettingsMenuViewModel {
    struct Profile {
        let name: String
        let position: String
        let photoURL: URL
    }

    struct Tile {
        let title: String
        let subtitle: String
    }

    private let tiles: [Tile] = mockTiles()

    let profile: Profile = mockProfile()

    let tileUpdates = PublishSubject<CollectionUpdate, NoError>()

    var tileCount: Int {
        return tiles.count
    }

    func tile(at row: Index) -> Tile {
        return tiles[row]
    }
}

// MARK: Mock Data

private func mockProfile() -> SettingsMenuViewModel.Profile {
    let url = URL(string: "https://randomuser.me/api/portraits/men/20.jpg")!
    return SettingsMenuViewModel.Profile(name: "CURTIS PHILLIPS", position: "FINANCIAL EXECUTIVE", photoURL: url)
}

private func mockTiles() -> [SettingsMenuViewModel.Tile] {
    return [
        SettingsMenuViewModel.Tile(title: "358 days", subtitle: "MEMBER SINCE"),
        SettingsMenuViewModel.Tile(title: "258784 min", subtitle: "QOT USAGE"),
        SettingsMenuViewModel.Tile(title: "258784 min", subtitle: "MESSAGES"),
        SettingsMenuViewModel.Tile(title: "7484", subtitle: "SOMETHING ELSE")
    ]
}
