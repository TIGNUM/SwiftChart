//
//  DTPrepareInterface.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol DTPrepareViewControllerInterface: class {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind)
}

protocol DTPreparePresenterInterface {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind)
}

protocol DTPrepareInteractorInterface: Interactor {
    func getUserPreparation(answer: DTViewModel.Answer,
                            event: DTViewModel.Event?,
                            completion: @escaping (QDMUserPreparation?) -> Void)
    func getUserPreparation(event: DTViewModel.Event?) -> QDMUserPreparation?
}

protocol DTPrepareRouterInterface {
    func presentPrepareResults(_ contentId: Int)
    func presentPrepareResults(_ preparation: QDMUserPreparation?)
    func presentCalendarPermission(_ permissionType: AskPermission.Kind)

    func openArticle(with contentID: Int)
    func openVideo(from url: URL, item: QDMContentItem?)
    func openShortTBVGenerator(completion: (() -> Void)?)
    func openImagePicker()

    func dismissAll()

    func presentAddEventController(_ eventStore: EKEventStore)
}
