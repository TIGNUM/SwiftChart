//
//  DecisionTreeRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DecisionTreeRouter {

    // MARK: - Properties

    private let viewController: DecisionTreeViewController
    private let permissionsManager: PermissionsManager
    private var imagePickerController: ImagePickerController?

    // MARK: - Init

    init(viewController: DecisionTreeViewController, permissionsManager: PermissionsManager) {
        self.viewController = viewController
        self.permissionsManager = permissionsManager
        self.imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                           imageQuality: .high,
                                                           imageSize: .large,
                                                           permissionsManager: permissionsManager,
                                                           pageName: .imagePickerGenerator)
        self.imagePickerController?.delegate = self
    }
}

// MARK: - DecisionTreeRouterInterface

extension DecisionTreeRouter: DecisionTreeRouterInterface {

    func openArticle(with contentID: Int) {
        AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentID)
    }

    func openVideo(from url: URL) {
        viewController.stream(videoURL: url, contentItem: nil, pageName: .about)
    }

    func openImagePicker() {
        imagePickerController?.show(in: viewController, deletable: true)
    }
}

// MARK: - ImagePickerDelegate

extension DecisionTreeRouter: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        // 1. saveImage
        // 2. load next question
        // 3. go next
    }

    func cancelSelection() {
        // 1. load next question
    }
}
