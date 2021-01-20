//
//  StreamVideoPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 07.04.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol StreamVideoPresenterInterface {
    func showAddedAlert()
}

final class StreamVideoPresenter {

    // MARK: - Properties
    private weak var viewController: MediaPlayerViewControllerInterface?

    // MARK: - Init
    init(viewController: MediaPlayerViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - StreamVideoPresenterInterface
extension StreamVideoPresenter: StreamVideoPresenterInterface {
    func showAddedAlert() {
        viewController?.showInfoAlert()
    }
}
