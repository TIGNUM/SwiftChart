//
//  WalkthroughConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class WalkthroughConfigurator {

    static func make() -> (WalkthroughViewController, SelectedTrackType) -> Void {
        return { (viewController, trackType) in
            let router = WalkthroughRouter(viewController: viewController)
            let worker = WalkthroughWorker(selectedTrack: trackType)
            let presenter = WalkthroughPresenter(viewController: viewController)
            let interactor = WalkthroughInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
