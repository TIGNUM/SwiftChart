//
//  WalkthroughInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class WalkthroughInteractor {

    // MARK: - Properties

    private let worker: WalkthroughWorker
    private let presenter: WalkthroughPresenterInterface
    private let router: WalkthroughRouterInterface

    private lazy var searchController: UIViewController = {
        let controller = R.storyboard.walkthroughSearch.walkthroughSearchViewController() ?? WalkthroughSearchViewController()
        let configurator = WalkthroughSearchConfigurator.make()
        configurator(controller)
        return controller
    }()

    private lazy var coachController: UIViewController = {
        let controller = R.storyboard.walkthroughCoach.walkthroughCoachViewController() ?? WalkthroughCoachViewController()
        let configurator = WalkthroughCoachConfigurator.make()
        configurator(controller)
        return controller
    }()

    private lazy var swipeController: UIViewController = {
        let controller = R.storyboard.walkthroughSwipe.walkthroughSwipeViewController() ?? WalkthroughSwipeViewController()
        let configurator = WalkthroughSwipeConfigurator.make()
        configurator(controller)
        return controller
    }()

    private lazy var controllers: [UIViewController] = {
        return [searchController, coachController, swipeController]
    }()

    // MARK: - Init

    init(worker: WalkthroughWorker,
        presenter: WalkthroughPresenterInterface,
        router: WalkthroughRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }

    // MARK: - Texts

    var buttonGotItTitle: String {
        return worker.buttonGotIt
    }
}

// MARK: - WalkthroughInteractorInterface

extension WalkthroughInteractor: WalkthroughInteractorInterface {

    var firstController: UIViewController {
        return searchController
    }

    var controllerCount: Int {
        return controllers.count
    }

    func index(of controller: UIViewController?) -> Int? {
        guard let controller = controller else { return nil }
        return controllers.index(of: controller)
    }

    func viewController(after controller: UIViewController) -> UIViewController {
        guard var index = controllers.index(of: controller) else { return searchController }
        if index < controllers.count - 1 {
            index += 1
        } else {
            index = 0
        }
        return controllers[index]
    }

    func viewController(before controller: UIViewController) -> UIViewController {
        guard var index = controllers.index(of: controller) else { return searchController }
        if index > 0 {
            index -= 1
        } else {
            index = controllers.count - 1
        }
        return controllers[index]
    }

    func didTapGotIt() {
        worker.saveViewedWalkthrough()
        router.navigateToTrack(type: worker.selectedTrack)
    }
}
