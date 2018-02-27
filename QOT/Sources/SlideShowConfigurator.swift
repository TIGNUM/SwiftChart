//
//  SlideShowConfigurator.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SlideShowConfigurator: AppStateAccess {

    static func makeInitial() -> (SlideShowViewController) -> Void {
        return { (viewController) in
            let router = InitialSlideShowRouter(appCoordinator: appState.appCoordinator)
            SlideShowConfigurator.configure(viewController: viewController, router: router)
        }
    }

    static func makeModal() -> (SlideShowViewController) -> Void {
        return { (viewController) in
            let router = ModalSlideShowRouter(viewController: viewController)
            SlideShowConfigurator.configure(viewController: viewController, router: router)
        }
    }

    private static func configure(viewController: SlideShowViewController, router: SlideShowRouterInterface) {
        let worker = SlideShowWorker(services: appState.services)
        let presenter = SlideShowPresenter(viewController: viewController)
        let interactor = SlideShowInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
