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

    struct Tile {
        let title: String
        let subtitle: String
    }

    private let settingTitles = [
        R.string.localized.sidebarSettingsMenuGeneralButton(),
        R.string.localized.sidebarSettingsMenuNotificationsButton(),
        R.string.localized.sidebarSettingsMenuSecurityButton()
    ]
    fileprivate lazy var tiles: [Tile] = userTiles(user: self.user)
    fileprivate let user: User
    let tileUpdates = PublishSubject<CollectionUpdate, NoError>()

    var tileCount: Int {
        return tiles.count
    }

    var userName: String {
        return String(format: "%@\n%@", user.givenName, user.familyName).uppercased()
    }

    var userJobTitle: String? {
        return user.jobTitle?.uppercased()
    }

    var userProfileImagePath: String? {
        return user.userImageURLString
    }

    var settingsCount: Int {
        return settingTitles.count
    }

    func tile(at row: Index) -> Tile {
        return tiles[row]
    }

    func settingTitle(at row: Index) -> String {
        return settingTitles[row]
    }

    init?(services: Services) {
        guard let user = services.userService.user() else {
            return nil
        }

        self.user = user
    }
}

// MARK: Mock Data

private func userTiles(user: User) -> [SettingsMenuViewModel.Tile] {
    return [
        SettingsMenuViewModel.Tile(title: daysBetweenDates(startDate: user.memberSince), subtitle: "MEMBER SINCE"),
        SettingsMenuViewModel.Tile(title: totalMinutesUsage, subtitle: "QOT USAGE")
    ]
}

private var totalMinutesUsage: String {
    let totalSeconds = QOTUsageTimer.sharedInstance.totalSeconds
    let totalMinutes = Int(totalSeconds / 60)
    
    if totalMinutes == 1 {
        return String(format: "%d MINUTE", totalMinutes)
    }

    return String(format: "%d MINUTES", totalMinutes)
}

private func daysBetweenDates(startDate: Date) -> String {
    let calendar = Calendar.current
    let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: Date())

    guard let days = components.day else {
        return "0 DAYS"
    }

    if days == 1 {
        return String(format: "%d DAY", days)
    }

    return String(format: "%d DAYS", days)
}
