//
//  TrackSelectionWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import UserNotifications
import qot_dal

final class TrackSelectionWorker {

    // MARK: - Properties

    lazy var title: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionTitle()
    }()

    lazy var descriptionText: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionMessage()
    }()

    lazy var fastTrackButton: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionButtonFastTrack()
    }()

    lazy var guidedTrackButton: String = {
        return R.string.localized.onboardingRegistrationTrackSelectionButtonGuidedTrack()
    }()

    // MARK: - Init

    init() {
    }

    func notificationRequestType(completion: @escaping ((AskPermission.Kind?) -> Void)) {
        RemoteNotificationPermission().authorizationStatus { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .provisional: completion(nil)
                case .denied: completion(.notificationOpenSettings)
                case .notDetermined: completion(.notification)
                }
            }
        }
    }

    func guideTrackBucketVisible(_ visible: Bool) {
        guard let currentAccount = SessionService.main.getCurrentSession()?.useremail else {
            return
        }
        var emails = UserDefault.showGuideTrackBucket.object as? [String] ?? [String]()
        if visible, emails.contains(obj: currentAccount) != true {
            emails.append(currentAccount)
        } else if !visible, emails.contains(obj: currentAccount) == true {
            emails.remove(object: currentAccount)
        }
        UserDefault.showGuideTrackBucket.setObject(emails)
    }
}
