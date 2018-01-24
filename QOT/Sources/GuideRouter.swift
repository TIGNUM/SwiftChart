//
//  GuideRouter.swift
//  QOT
//
//  Created by Sam Wyndham on 24/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class GuideRouter: GuideRouterInterface {

    let launchHandler: LaunchHandler

    init(launchHandler: LaunchHandler) {
        self.launchHandler = launchHandler
    }

    func open(item: Guide.Item) {
        guard item.isDailyPrepCompleted == false, let url = item.link else { return }

        launchHandler.process(url: url, notificationID: item.identifier, guideItem: item)
    }
}
