//
//  ScreenHelpInteractor.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class ScreenHelpInteractor {
    private let presenter: ScreenHelpPresenterInterface
    private let router: ScreenHelpRouterInterface
    private let dataWorker: ScreenHelpDataWorker
    let screenHelp: ScreenHelp.Category

    init(presenter: ScreenHelpPresenterInterface,
         router: ScreenHelpRouterInterface,
         dataWorker: ScreenHelpDataWorker,
         screenHelp: ScreenHelp.Category) {
        self.presenter = presenter
        self.router = router
        self.dataWorker = dataWorker
        self.screenHelp = screenHelp
    }
}

// MARK: - ScreenHelpInteractorInterface

extension ScreenHelpInteractor: ScreenHelpInteractorInterface {
    func viewDidLoad() {
        do {
            presenter.load(try dataWorker.getItem(for: screenHelp))
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
