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

    private var services: Services
    private var userService: UserService {
        return services.userService
    }

    struct Tile {
        let title: String
        let subtitle: String
    }

    private lazy var tiles: [Tile] = userTiles(user: self.user)
    private let user: User
    let tileUpdates = PublishSubject<CollectionUpdate, NoError>()
    private let settingTitles = [R.string.localized.sidebarSettingsMenuGeneralButton(),
                                 R.string.localized.sidebarSettingsMenuNotificationsButton(),
                                 R.string.localized.sidebarSettingsMenuSecurityButton()]
    private let timer: QOTUsageTimer

    var tileCount: Int {
        return tiles.count
    }

    var userName: String {
        return String(format: "%@\n%@", user.givenName, user.familyName).uppercased()
    }

    var userJobTitle: String? {
        return user.jobTitle?.uppercased()
    }

    var userProfileImageResource: MediaResource? {
        return user.userImage
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

    func updateProfileImage(_ image: UIImage) -> Error? {
        do {
            let url = try image.save(withName: user.localID)
            updateProfileImageURL(url)
            return nil
        } catch {
            return error
        }
    }

    init?(services: Services) {
        guard let user = services.userService.user() else {
            return nil
        }

        self.services = services
        self.timer = QOTUsageTimer.sharedInstance
        self.user = user
    }
}

// MARK: Private

private extension SettingsMenuViewModel {

    func userTiles(user: User) -> [SettingsMenuViewModel.Tile] {
        return [
            SettingsMenuViewModel.Tile(title: daysBetweenDates(startDate: user.memberSince),
                                       subtitle: R.string.localized.sidebarUserTitlesMemberSince()),
            SettingsMenuViewModel.Tile(title: usageTimeString(),
                                       subtitle: R.string.localized.sidebarUserTitlesMemberQOTUsage())
        ]
    }

    private func daysBetweenDates(startDate: Date) -> String {
        return DateComponentsFormatter.timeIntervalToString(-startDate.timeIntervalSinceNow, isShort: true)?
            .replacingOccurrences(of: ", ", with: "\n")
            .uppercased() ?? R.string.localized.qotUsageTimerDefault()
    }

    private func usageTimeString() -> String {
        return timer.totalTimeString(timer.totalSeconds)
    }

    private func updateProfileImageURL(_ url: URL) {
        services.userService.updateUser(user: user) { (user) in
            user.userImage?.setLocalURL(url, format: .jpg, entity: .user, entitiyLocalID: user.localID)
        }
    }
}
