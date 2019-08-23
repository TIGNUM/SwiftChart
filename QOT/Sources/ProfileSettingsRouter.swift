//
//  ProfileSettingsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 23/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ProfileSettingsRouter {

    private weak var viewController: ProfileSettingsViewController?
    private weak var popUpController: PopUpViewController?

    init(settingsMenuViewController: ProfileSettingsViewController) {
        self.viewController = settingsMenuViewController
    }
}

extension ProfileSettingsRouter: ProfileSettingsRouterInterface {
    func closeUpdateConfirmationScreen(completion: (() -> Void)?) {
        popUpController?.dismiss(animated: true, completion: completion)
    }

    func showUpdateConfirmationScreen() {
        guard let viewController = viewController else { return }
        let config = PopUpViewController.Config(title: R.string.localized.profileConfirmationHeader().uppercased(),
                                                description: R.string.localized.profileConfirmationDescription(),
                                                rightButtonTitle: R.string.localized.profileConfirmationDoneButton(),
                                                leftButtonTitle: R.string.localized.buttonTitleCancel())
        let popUpController = PopUpViewController(with: config, delegate: viewController)
        popUpController.modalPresentationStyle = .overCurrentContext
        self.popUpController = popUpController
        viewController.present(popUpController, animated: true, completion: nil)
    }
}
