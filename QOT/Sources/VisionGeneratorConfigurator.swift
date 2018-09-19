//
//  VisionGeneratorConfigurator.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class VisionGeneratorConfigurator: AppStateAccess {

    static func make(_ chatViewModel: ChatViewModel<VisionGeneratorChoice>,
                     visionModel: MyToBeVisionModel.Model?,
                     visionController: MyToBeVisionViewController,
                     visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]])
        -> (ChatViewController<VisionGeneratorChoice>) -> Void {
        return { (chatViewController) in
            let router = VisionGeneratorRouter(chatViewController: chatViewController,
                                               permissionsManager: appState.permissionsManager)
            let worker = VisionGeneratorWorker(services: appState.services,
                                               networkManager: appState.networkManager,
                                               chatViewModel: chatViewModel,
                                               visionModel: visionModel,
                                               syncManager: appState.syncManager,
                                               allChatItems: visionChatItems)
            let presenter = VisionGeneratorPresenter(viewController: chatViewController,
                                                     visionController: visionController)
            let interactor = VisionGeneratorInteractor(worker: worker, router: router, presenter: presenter)
            router.setImagePickerDelegate(interactor)
            chatViewController.visionGeneratorInteractor = interactor
            chatViewModel.visionGeneratorInteractor = interactor
            chatViewController.didSelectChoice = { (choice, viewController) in
                interactor.handleChoice(choice)
            }
        }
    }

    static func visionGeneratorViewController(toBeVision: MyToBeVisionModel.Model?,
                                              visionController: MyToBeVisionViewController,
                                              visionChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]]) -> UIViewController {
        let chatViewModel = ChatViewModel<VisionGeneratorChoice>(items: [])
        let configurator = VisionGeneratorConfigurator.make(chatViewModel,
                                                            visionModel: toBeVision,
                                                            visionController: visionController,
                                                            visionChatItems: visionChatItems)
        let chatViewController = ChatViewController(pageName: .visionGenerator,
                                                    viewModel: chatViewModel,
                                                    backgroundImage: R.image.backgroundChatBot(),
                                                    configure: configurator)
        chatViewController.title = R.string.localized.guideToBeVisionNotFisishedTitle()
        return chatViewController
    }
}
