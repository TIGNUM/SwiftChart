//
//  GuideConfigurator.swift
//  QOT
//
//  Created by karmic on 05.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

extension GuideViewController: GuidePresenterOutput {

    func successFetchedItems(viewModel: GuideModel.ViewModel) {

    }

    func errorFetchingItems() {

    }
}

//extension GuideInteractor: GuideViewControllerOutput {
//
//}

extension GuidePresenter: GuidePresenterOutput {
    func successFetchedItems(viewModel: GuideModel.ViewModel) {

    }

    func errorFetchingItems() {

    }
}

final class GuideConfigurator {

    static let shared = GuideConfigurator()

    private init() {}

    func configure(morningInterViewController: MorningInterviewViewController) {
        let router = GuideRouter()
        let presenter = GuidePresenter()
        let interactor = GuideInteractor()
        router.morningInterViewController = morningInterViewController        
//        interactor.output = presenter as! GuideInteractorOutput
    }
}
