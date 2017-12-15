//
//  ScreenHelpInteractor.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class ScreenHelpInteractor {
    private let presenter: ScreenHelpPresenterInterface
    private let router: ScreenHelpRouterInterface
    private let dataWorker: ScreenHelpDataWorker
    private let plistKey: ScreenHelp.Plist.Key

    init(presenter: ScreenHelpPresenterInterface,
         router: ScreenHelpRouterInterface,
         dataWorker: ScreenHelpDataWorker,
         plistKey: ScreenHelp.Plist.Key) {
        self.presenter = presenter
        self.router = router
        self.dataWorker = dataWorker
        self.plistKey = plistKey
    }
}

// MARK: - ScreenHelpInteractorInterface

extension ScreenHelpInteractor: ScreenHelpInteractorInterface {
    func viewDidLoad() {
        do {
            presenter.load(try dataWorker.getItem(for: plistKey))
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func didTapMinimiseButton() {
        router.dismiss()
    }

    func didTapVideo(with url: URL) {
        router.showVideo(with: url)
    }
}
