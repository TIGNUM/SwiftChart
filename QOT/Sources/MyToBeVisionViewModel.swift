//
//  MyToBeVisionViewModel.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionViewModel {

    // MARK: - Properties

    private var services: Services
    private var userService: UserService {
        return services.userService
    }
    private(set) var item: MyToBeVision?
    var headline: String? {
        return item?.headline
    }
    var subHeadline: String? {
        return item?.subHeadline
    }
    var text: String? {
        return item?.text
    }
    var profileImageResource: MediaResource? {
        return item?.profileImageResource
    }
    var dateText: String {
        guard let date = item?.date else {
            return ""
        }
        guard let text = DateComponentsFormatter.timeIntervalToString(-date.timeIntervalSinceNow, isShort: true) else {
            return ""
        }
        return R.string.localized.meSectorMyWhyVisionWriteDate(text).uppercased()
    }

    init(services: Services) {
        self.services = services
        self.item = services.userService.myToBeVision()
    }

    func updateHeadline(_ headline: String?) {
        guard let item = item else { return }
        userService.updateHeadline(myToBeVision: item, headline: headline)
        updateDate(Date())
    }

    func updateText(_ text: String?) {
        guard let item = item else { return }
        userService.updateText(myToBeVision: item, text: text)
        updateDate(Date())
    }

    func updateDate(_ date: Date) {
        guard let item = item else { return }
        userService.updateDate(myToBeVision: item, date: date)
    }

    func updateLocalProfileImageURL(_ url: URL) {
        guard let item = item else { return }

        userService.updateMyToBeVision(item) {
            $0.profileImageResource?.setLocalURL(url, format: .jpg, entity: .toBeVision, entitiyLocalID: $0.localID)
        }
    }

    func updateProfileImage(_ image: UIImage) -> Error? {
        guard let item = item else { return nil }
        do {
            let url = try image.save(withName: item.localID)
            updateLocalProfileImageURL(url)
            updateDate(Date())
            return nil
        } catch {
            return error
        }
    }
}
