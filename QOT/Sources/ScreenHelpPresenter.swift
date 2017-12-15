//
//  ScreenHelpPresenter.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class ScreenHelpPresenter {
    private weak var viewController: ScreenHelpViewControllerInterface?

    init(viewController: ScreenHelpViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ScreenHelpPresenterInterface

extension ScreenHelpPresenter: ScreenHelpPresenterInterface {
    func load(_ item: ScreenHelp.Plist.Item) {
        viewController?.updateViewModel(ScreenHelp.ViewModel(
            title: item.title,
            image: UIImage(named: item.imageName),
            videoURL: URL(string: item.videoURL),
            message: item.message
        ))
    }
}
