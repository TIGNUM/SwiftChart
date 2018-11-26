//
//  VisionGeneratorRouter.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class VisionGeneratorRouter {

    private let chatViewController: ChatViewController<VisionGeneratorChoice>
    private let permissionsManager: PermissionsManager
    private var imagePickerController: ImagePickerController?

    init(chatViewController: ChatViewController<VisionGeneratorChoice>, permissionsManager: PermissionsManager) {
        self.chatViewController = chatViewController
        self.permissionsManager = permissionsManager
        imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                      imageQuality: .high,
                                                      imageSize: .large,
                                                      permissionsManager: permissionsManager,
                                                      pageName: .imagePickerGenerator)
    }

    func setImagePickerDelegate(_ delegate: ImagePickerControllerDelegate) {
        imagePickerController?.delegate = delegate
    }
}

// MARK: - VisionGeneratorRouterInterface

extension VisionGeneratorRouter: VisionGeneratorRouterInterface {

    func loadLastQuestion() {
        chatViewController.laodLastQuestion()
    }

    func showPictureActionSheet(_ visionType: VisionGeneratorChoice.QuestionType) {
        chatViewController.resetVisionChoice()
        imagePickerController?.show(in: chatViewController, deletable: false)
    }
}
