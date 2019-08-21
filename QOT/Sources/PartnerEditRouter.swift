//
//  PartnerEditRouter.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD

final class PartnerEditRouter {

    // MARK: - Properties

    private let viewController: PartnerEditViewController
    private let permissionManager: PermissionsManager

    private lazy var imagePicker: ImagePickerController = {
        let adapter = ImagePickerControllerAdapter(viewController)
        let picker = ImagePickerController(imageQuality: .high,
                                     imageSize: .large,
                                     permissionsManager: permissionManager,
                                     pageName: .imagePickerPartner,
                                     adapter: adapter)
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

    func dismiss(_ partner: Partners.Partner) {
        viewController.dismiss()
    }

    func showImagePicker() {
        imagePicker.show(in: viewController, deletable: false)
    }

    func showProgressHUD(_ message: String?) {
        SVProgressHUD.show()
    }

    func hideProgressHUD() {
        SVProgressHUD.dismiss()
    }
}
