//
//  PartnerEditRouter.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnerEditRouter {

    // MARK: - Properties

    private let viewController: PartnerEditViewController
    private let permissionManager: PermissionsManager

    private lazy var imagePicker: ImagePickerController = {
        let picker = ImagePickerController(imageQuality: .high,
                                     imageSize: .large,
                                     permissionsManager: permissionManager)
        picker.delegate = viewController
        return picker
    }()

    // MARK: - Init

    init(viewController: PartnerEditViewController, permissionManager: PermissionsManager) {
        self.viewController = viewController
        self.permissionManager = permissionManager
    }
}

// MARK: - PartnerEditRouterInterface

extension PartnerEditRouter: PartnerEditRouterInterface {

    func showAlert(_ alert: AlertType) {
        viewController.showAlert(type: alert)
    }

    func dismiss() {
        viewController.dismiss(animated: true, completion: nil)
    }

    func showImagePicker() {
        imagePicker.show(in: viewController)
    }
}
