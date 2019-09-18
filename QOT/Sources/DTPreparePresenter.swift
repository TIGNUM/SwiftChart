//
//  DTPreparePresenter.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPreparePresenter: DTPresenter {

    // MARK: - Properties
    weak var prepareViewController: DTPrepareViewControllerInterface?
    var intensionViewModel: DTViewModel?

    override func createViewModel(_ presentationModel: DTPresentationModel) -> DTViewModel {
        return intensionViewModel ?? super.createViewModel(presentationModel)
    }

    override func previousIsHidden(questionKey: String) -> Bool {
        return questionKey == Prepare.QuestionKey.Intro || questionKey == Prepare.QuestionKey.Last
    }
}

// MARK: - DTPrepareInterface
extension DTPreparePresenter: DTPreparePresenterInterface {
    func presentCalendarPermission(_ permissionType: AskPermission.Kind) {
        prepareViewController?.presentCalendarPermission(permissionType)
    }
}
