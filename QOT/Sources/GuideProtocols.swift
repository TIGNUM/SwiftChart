//
//  GuideProtocols.swift
//  QOT
//
//  Created by Sam Wyndham on 24/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol GuideViewControllerInterface: class {
    func setLoading(_ loading: Bool)
    func updateHeader(greeting: String, message: String)
    func updateDays(days: [Guide.Day])
}

protocol GuidePresenterInterface {
    func presentLoading()
    func present(model: Guide.Model)
}

protocol GuideInteractorInterface: Interactor {
    func reload()
    func didTapItem(_ item: Guide.Item)
    func didTapWhatsHotItem(_ item: Guide.Item)
    func didTapMyToBeVision(_ item: Guide.Item)
}

protocol GuideRouterInterface {
    func open(item: Guide.Item)
}
