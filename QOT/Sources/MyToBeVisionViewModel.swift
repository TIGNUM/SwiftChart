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
    private var mediaService: MediaService {
        return services.mediaService
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
    var dateText: String? {
        guard let date = item?.date else {
            return nil
        }
        let now = Date()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .weekOfMonth, .day, .hour, .minute, .second], from: date, to: now)
        guard let dateText = formatter.string(from: components) else {
            return nil
        }
        return R.string.localized.meSectorMyWhyVisionWriteDate(dateText).uppercased()
    }

    init(services: Services) {
        self.services = services
        self.item = services.userService.myToBeVision()
    }
    
    func updateHeadline(_ headline: String?) {
        guard let item = item else { return }
        userService.updateHeadline(myToBeVision: item, headline: headline)
    }
    
    func updateText(_ text: String?) {
        guard let item = item else { return }
        userService.updateText(myToBeVision: item, text: text)
    }
    
    func updateLocalProfileImageURL(_ localProfileImageURL: String?) {
        guard let profileImageResource = profileImageResource else { return }
        mediaService.updateLocalURLString(mediaResource: profileImageResource, localURLString: localProfileImageURL)
    }
    
    func updateRemoteProfileImageURL(_ remoteProfileImageURL: String?) {
        guard let profileImageResource = profileImageResource else { return }
        mediaService.updateRemoteURLString(mediaResource: profileImageResource, remoteURLString: remoteProfileImageURL)
    }
    
    func updateProfileImage(_ image: UIImage?) -> Error? {
        guard let item = item else { return nil }
        do {
            let url = try image?.save(withName: item.localID)
            updateLocalProfileImageURL(url?.absoluteString)
            return nil
        } catch {
            return error
        }
    }
}
