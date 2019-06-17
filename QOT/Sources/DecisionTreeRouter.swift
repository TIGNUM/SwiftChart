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
    func openPrepareChecklist(with contentID: Int,
                              checkListType: PrepareCheckListType,
                              selectedEvent: CalendarEvent?,
                              eventType: String?,
                              relatedStrategyID: Int?,
                              selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                              benefits: String?) {
        let configurator = PrepareCheckListConfigurator.make(contentID: contentID,
                                                             checkListType: checkListType,
                                                             event: selectedEvent,
                                                             eventType: eventType,
                                                             relatedStrategyID: relatedStrategyID,
                                                             selectedAnswers: selectedAnswers,
                                                             benefits: benefits)
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

    func openShortTBVGenerator(completion: (() -> Void)?) {
        let configurator = DecisionTreeConfigurator.make(for: .mindsetShifterTBV, permissionsManager: permissionsManager)
        let decisionTreeVC = DecisionTreeViewController(configure: configurator)
        viewController.present(decisionTreeVC, animated: true, completion: completion)
    }

    func openMindsetShifterChecklist(trigger: String,
                                     reactions: [String],
                                     lowPerformanceItems: [String],
                                     highPerformanceItems: [String]) {
        let configurator = MindsetShifterChecklistConfigurator.make(trigger: trigger,
                                                                    reactions: reactions,
                                                                    lowPerformanceItems: lowPerformanceItems,
                                                                    highPerformanceItems: highPerformanceItems)
        let mindsetShifterChecklistVC = MindsetShifterChecklistViewController(configure: configurator)
        viewController.present(mindsetShifterChecklistVC, animated: true)
    }

    func openSolveResults(from selectedAnswer: Answer) {
        let configurator = SolveResultsConfigurator.make(from: selectedAnswer)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        solveResultsController.delegate = viewController
        viewController.present(solveResultsController, animated: true)
    }

    func openToBeVisionPage() {
        let configurator = MyToBeVisionConfigurator.make(navigationItem: NavigationItem())
        let visionViewController = MyToBeVisionViewController(configurator: configurator)
        viewController.present(visionViewController, animated: true) {
           self.viewController.dismiss(animated: true, completion: nil)
        }
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
