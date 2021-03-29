//
//  GuidedStoryJourneyInterface.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol GuidedStoryJourneyViewControllerInterface: class {
    func setupView()
    func setupHeaderView(title: String?, imageURL: URL?, color: UIColor)
}

protocol GuidedStoryJourneyPresenterInterface {
    func setupView()
    func setupHeaderView(content: QDMContentCollection?)
}

protocol GuidedStoryJourneyInteractorInterface: Interactor {

}

protocol GuidedStoryJourneyRouterInterface {
    func dismiss()
}
