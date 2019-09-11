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
    private weak var viewController: DecisionTreeViewController?
    private var imagePickerController: ImagePickerController?
    private var permissionsManager: PermissionsManager = AppCoordinator.permissionsManager!

    // MARK: - Init
    init(viewController: DecisionTreeViewController) {
        self.viewController = viewController
        let adapter = ImagePickerControllerAdapter(self)
        self.imagePickerController = ImagePickerController(cropShape: .rectangle,
                                                           imageQuality: .high,
                                                           imageSize: .large,
                                                           permissionsManager: permissionsManager,
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
            viewController?.present(controller, animated: true, completion: nil)
        }
    }

    func openVideo(from url: URL, item: QDMContentItem?) {
        viewController?.stream(videoURL: url, contentItem: item)
    }

    func openImagePicker() {
        guard let viewController = viewController else { return }
        imagePickerController?.show(in: viewController, deletable: true)
    }

    func openShortTBVGenerator(completion: (() -> Void)?) {
        let configurator = DecisionTreeConfigurator.make(for: .mindsetShifterTBV)
        let decisionTreeVC = DecisionTreeViewController(configure: configurator)
        viewController?.present(decisionTreeVC, animated: true, completion: completion)
    }

    func openMindsetShifterResult(resultItem: MindsetResult.Item, completion: @escaping () -> Void) {
        let configurator = ShifterResultConfigurator.make(resultItem: resultItem)
        let controller = ShifterResultViewController(configure: configurator)
        viewController?.present(controller, animated: true) {
            completion()
        }
    }

    func openSolveResults(from selectedAnswer: QDMAnswer, type: ResultType) {
        let configurator = SolveResultsConfigurator.make(from: selectedAnswer.remoteID ?? 0,
                                                         solutionCollectionId: selectedAnswer.targetId(.content) ?? 0,
                                                         type: type,
                                                         solve: nil)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        solveResultsController.delegate = viewController
        viewController?.present(solveResultsController, animated: true)
    }

    func openToBeVisionPage() {
        let identifier = R.storyboard.myToBeVision.myVisionViewController.identifier
        guard let myVisionViewController = R.storyboard
            .myToBeVision().instantiateViewController(withIdentifier: identifier) as? MyVisionViewController else {
                return
        }
        MyVisionConfigurator.configure(viewController: myVisionViewController)
        viewController?.present(myVisionViewController, animated: true) {
            self.viewController?.dismiss(animated: true, completion: nil)
        }
    }

    func dismissAndGoToMyQot() {
        viewController?.dismiss(animated: true) {
            self.viewController?.delegate?.didDismiss()
        }
    }

    func dismissAll() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func presentPermissionView(_ permissionType: AskPermission.Kind) {
        viewController?.presentPermissionView(permissionType)
    }
}

// MARK: - Prepare
extension DecisionTreeRouter {
    func openPrepareResults(_ contentId: Int) {
        presentPrepareResults(PrepareResultsConfigurator.configurate(contentId))
    }

    func openPrepareResults(_ preparation: QDMUserPreparation,
                            _ answers: [DecisionTreeModel.SelectedAnswer]) {
        presentPrepareResults(PrepareResultsConfigurator.configurate(preparation,
                                                                     answers,
                                                                     canDelete: answers.isEmpty == false,
                                                                     true))
    }

    private func presentPrepareResults(_ configurator: Configurator<PrepareResultsViewController>) {
        let controller = PrepareResultsViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}

// MARK: - Recovery
extension DecisionTreeRouter {
    func openRecoveryResults(_ recovery: QDMRecovery3D?) {
        let configurator = SolveResultsConfigurator.make(from: recovery)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        solveResultsController.delegate = viewController
        viewController?.present(solveResultsController, animated: true)
    }
}

// MARK: - ImagePickerDelegate
extension DecisionTreeRouter: ImagePickerControllerAdapterProtocol {
    //
}

extension DecisionTreeRouter: ImagePickerControllerDelegate {
    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        viewController?.interactor?.save(image)
        viewController?.refreshBottomNavigationItems()
    }

    func cancelSelection() {
        viewController?.refreshBottomNavigationItems()
    }
}
