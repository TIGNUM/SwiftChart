//
//  DTPrepareRouter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPrepareRouter: DTRouter {}

// MARK: - DTPrepareRouterInterface
extension DTPrepareRouter: DTPrepareRouterInterface {
    func openArticle(with contentID: Int) {

    }

    func openVideo(from url: URL, item: QDMContentItem?) {

    }

    func openShortTBVGenerator(completion: (() -> Void)?) {

    }

    func openImagePicker() {

    }

    func dismissAll() {

    }

    func presentPermissionView(_ permissionType: AskPermission.Kind) {

    }

    func presentAddEventController(_ eventStore: EKEventStore) {

    }

    func presentPrepareResults(_ contentId: Int) {
        let configurator = PrepareResultsConfigurator.configurate(contentId)
        let controller = PrepareResultsViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentPrepareResults(_ preparation: QDMUserPreparation, _ answers: [SelectedAnswer]) {
//        let configurator = PrepareResultsConfigurator.configurate(preparation,
//                                                                  answers,
//                                                                  canDelete: answers.isEmpty == false,
//                                                                  true)
//        let controller = PrepareResultsViewController(configure: configurator)
//        viewController?.present(controller, animated: true)
    }
}
