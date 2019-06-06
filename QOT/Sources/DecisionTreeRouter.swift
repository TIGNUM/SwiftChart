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
    func openPrepareChecklist(with contentID: Int) {
        print("openPrepareChecklist with contentID: ", contentID)
        let configurator = PrepareCheckListConfigurator.make(contentID: contentID)
        let controller = PrepareCheckListViewController(configure: configurator)
        viewController.present(controller, animated: true, completion: nil)
    }

    func openArticle(with contentID: Int) {
        AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentID)
    }

    func openVideo(from url: URL) {
        viewController.stream(videoURL: url, contentItem: nil, pageName: .about)
    }

    func openImagePicker() {
        imagePickerController?.show(in: viewController, deletable: true)
    }

    func openShortTBVGenerator() {
        let configurator = DecisionTreeConfigurator.make(for: .mindsetShifterTBV, permissionsManager: permissionsManager)
        let decisionTreeVC = DecisionTreeViewController(configure: configurator)
        viewController.present(decisionTreeVC, animated: true)
    }

    func openMindsetShifterChecklist(trigger: String, reactions: [String], lowPerformanceItems: [String]) {
        let configurator = MindsetShifterChecklistConfigurator.make(trigger: trigger,
                                                                    reactions: reactions,
                                                                    lowPerformanceItems: lowPerformanceItems)
        let mindsetShifterChecklistVC = MindsetShifterChecklistViewController(configure: configurator)
        viewController.present(mindsetShifterChecklistVC, animated: true)
    }
}

// MARK: - ImagePickerDelegate

extension DecisionTreeRouter: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        viewController.interactor?.save(image)
    }

    func cancelSelection() {
    }
}
