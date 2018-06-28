//
//  SharePresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SharePresenter {

    private weak var viewController: ShareViewControllerInterface?

    init(viewController: ShareViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SharePresenterInterface

extension SharePresenter: SharePresenterInterface {

    func setup(name: String, relationship: String, email: String, imageURL: URL?, initials: String,
               hasMyToBeVision: Bool, hasWeeklyChoice: Bool) {
        viewController?.setup(name: name,
                              relationship: relationship,
                              email: email)
        viewController?.setPartnerProfileImage(imageURL, initials: initials)
        viewController?.setAvailableShareTypes(myToBeVision: hasMyToBeVision, weeklyChoice: hasWeeklyChoice)
    }

    func setLoading(loading: Bool) {
        viewController?.setLoading(loading: loading)
    }
}
