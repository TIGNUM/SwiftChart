//
//  DecisionTreeRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DecisionTreeRouter {

    // MARK: - Properties
    private let viewController: DecisionTreeViewController
    private var imagePickerController: ImagePickerController?
    private var permissionsManager: PermissionsManager = AppCoordinator.appState.permissionsManager!

    // MARK: - Init
    init(viewController: DecisionTreeViewController) {
        self.viewController = viewController
        let adapter = ImagePickerControllerAdapter(self)
        self.imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                           imageQuality: .high,
                                                           imageSize: .large,
                                                           permissionsManager: permissionsManager,
                                                           pageName: .imagePickerGenerator,
                                                           adapter: adapter)
        self.imagePickerController?.delegate = self
    }
}

// MARK: - DecisionTreeRouterInterface
extension DecisionTreeRouter: DecisionTreeRouterInterface {
    func openArticle(with contentID: Int) {
        if let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: R.storyboard.main.qotArticleViewController.identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: contentID, viewController: controller)
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func openVideo(from url: URL) {
        viewController.stream(videoURL: url, contentItem: nil, pageName: .about)
        viewController.updateBottomNavigation(leftItems: [], rightItems: [])
    }

    func openImagePicker() {
        imagePickerController?.show(in: viewController, deletable: true)
    }

    func openShortTBVGenerator(completion: (() -> Void)?) {
        let configurator = DecisionTreeConfigurator.make(for: .mindsetShifterTBV)
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

    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType) {
        let configurator = SolveResultsConfigurator.make(from: selectedAnswer, type: type)
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

// MARK: - Prepare
extension DecisionTreeRouter {
    func openPrepareResults(_ contentId: Int) {
        presentPrepareResults(PrepareResultsConfigurator.configurate(contentId))
    }

    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer]) {
        presentPrepareResults(PrepareResultsConfigurator.configurate(preparation, answers, canDelete: true))
    }

    private func presentPrepareResults(_ configurator: Configurator<PrepareResultsViewController>) {
        let controller = PrepareResultsViewController(configure: configurator)
        viewController.present(controller, animated: true, completion: nil)
    }
}

// MARK: - Recovery
extension DecisionTreeRouter {
    func openRecoveryResults(_ recovery: QDMRecovery3D?) {
        let configurator = SolveResultsConfigurator.make(from: recovery)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        solveResultsController.delegate = viewController
        viewController.present(solveResultsController, animated: true)
    }
}

// MARK: - ImagePickerDelegate
extension DecisionTreeRouter: ImagePickerControllerAdapterProtocol {
    //
}

extension DecisionTreeRouter: ImagePickerControllerDelegate {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        viewController.interactor?.save(image)
        viewController.refreshBottomNavigationItems()
    }

    func cancelSelection() {
        viewController.refreshBottomNavigationItems()
    }
}
