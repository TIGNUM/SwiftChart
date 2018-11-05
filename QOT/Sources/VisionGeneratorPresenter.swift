//
//  VisionGeneratorPresenter.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class VisionGeneratorPresenter {

    private weak var viewController: ChatViewControllerInterface?
    private weak var visionController: MyToBeVisionViewController?
    private weak var delegate: MyToBeVisionViewControllerDelegate?

    init(viewController: ChatViewControllerInterface,
         visionController: MyToBeVisionViewController,
         delegate: MyToBeVisionViewControllerDelegate?) {
        self.viewController = viewController
        self.visionController = visionController
        self.delegate = delegate
    }
}

// MARK: - VisionGeneratorPresenterInterface

extension VisionGeneratorPresenter: VisionGeneratorPresenterInterface {

    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }

    func hideLoadingIndicator() {
        viewController?.hideLoadingIndicator()
    }

    func updateVisionControllerModel(_ model: MyToBeVisionModel.Model) {
        visionController?.update(with: model)
    }

    func dismiss() {
        viewController?.dismiss()
    }

    func updateBottomButton(_ choice: VisionGeneratorChoice, questionType: VisionGeneratorChoice.QuestionType) {
        viewController?.updateBottomButton(choice, questionType: questionType)
    }

    func showContent(_ contentID: Int, choice: VisionGeneratorChoice) {
        viewController?.showContent(contentID, choice: choice)
    }

    func showMedia(_ mediaURL: URL, choice: VisionGeneratorChoice) {
        viewController?.showMedia(mediaURL, choice: choice)
    }

    func updateTabBarItem(visionModel: MyToBeVisionModel.Model?, navigationItem: NavigationItem?) {
        if let _ = ((delegate?.currentTBVController as? UINavigationController)?.viewControllers.first as? PageViewController)?.viewControllers?.first as? MyToBeVisionViewController {
            return
        }
        if
            let toBeVision = visionModel, toBeVision.headLine != nil, toBeVision.text != nil,
            let visionController = visionController,
            let navigationItem = navigationItem {
            let topTabBarController = UINavigationController(withPages: [visionController],
                                                             navigationItem: navigationItem,
                                                             topBarDelegate: visionController,
                                                             leftButton: .burger,
                                                             rightButton: .info)
            topTabBarController.tabBarItem = TabBarItem(config: TabBar.tbv.itemConfig)
            delegate?.didUpdateTabBarItemTBV(topBarController: topTabBarController)
        }
    }
}
