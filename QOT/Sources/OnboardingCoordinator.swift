//
//  OnboardingCoordinator.swift
//  QOT
//
//  Created by Lee Arromba on 20/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

import UIKit

protocol OnboardingCoordinatorDelegate: ParentCoordinator {

    func onboardingCoordinatorDidFinish(_ onboardingCoordinator: OnboardingCoordinator)
}

final class OnboardingCoordinator: ParentCoordinator {

    private struct Choice: ChatChoice {
        enum `Type` {
            case yes
            case later
            case why
            case go
        }
        
        var title: String
        var type: Type
    }

    private static let isOnboardingCompleteKey = "qot_onboarding_complete"
    var children: [Coordinator] = [Coordinator]()
    weak var delegate: OnboardingCoordinatorDelegate?
    private let window: UIWindow
    private let chatViewModel = ChatViewModel<Choice>()
    fileprivate let permissionHandler: PermissionHandler    

    class var isOnboardingComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isOnboardingCompleteKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isOnboardingCompleteKey)
        }
    }

    init(window: UIWindow, delegate: OnboardingCoordinatorDelegate, permissionHandler: PermissionHandler) {
        self.window = window
        self.delegate = delegate
        self.permissionHandler = permissionHandler
    }
    
    func start() {
        let chatViewController = ChatViewController(viewModel: chatViewModel, backgroundImage: R.image.backgroundChatBot())
        chatViewController.title = R.string.localized.topTabBarItemTitlePerpareCoach()
        chatViewController.didSelectChoice = { [unowned self] (choice, viewController) in
            self.handleChoice(choice)
        }
        
        let navigationController = UINavigationController(rootViewController: chatViewController)
        let navigationBar = navigationController.navigationBar
        navigationBar.applyDefaultStyle()
        
        startOnboarding() // must be called before adding chat vc to window, else chat won't animate

        window.setRootViewControllerWithFadeAnimation(navigationController)
        window.makeKeyAndVisible()
    }
    
    // MARK: - private
    
    private func startOnboarding() {
        // TODO: localise?
        let choices = [
            Choice(title: "Yes, I allow them", type: .yes),
            Choice(title: "I'll do it later", type: .later),
            Choice(title: "Why?", type: .why)
        ]
        let items = [
            ChatItem(type: .message("Welcome"), state: .typing, delay: 3.0),
            ChatItem(type: .message("QOT needs access to:\n_calendar\n_notification\n_location\nWill you allow?"), state: .typing, delay: 1.0),
            deliveredFooter(alignment: .left),
            ChatItem(type: .choiceList(choices, display: .list)),
            deliveredFooter(alignment: .right)
        ]
        chatViewModel.append(items: items)
    }
    
    private func handleChoice(_ choice: Choice) {
        switch choice.type {
        case .yes:
            permissionHandler.askForAllPermissions({ [unowned self] (result: PermissionHandler.Result) in
                if result.isAllGranted {
                    self.showLastStep()
                } else {
                    self.showSettings()
                    self.showLastStep()
                }
            })
        case .later:
            permissionHandler.isEnabledForSession = false
            showSettings()
            showLastStep()
        case .why:
            showWhy()
        case .go:
            completeOnboarding()
        }
    }
    
    private func showWhy() {
        // TODO: localise?
        let choices = [
            Choice(title: "Yes, I allow them", type: .yes),
            Choice(title: "I'll do it later", type: .later)
        ]
        let items = [
            ChatItem(type: .message("QOT needs permissions to access your calendar, your location and to send you notifications. This is so we can streamline your lifestyle. Will you allow?"), state: .typing, delay: 2.0),
            deliveredFooter(alignment: .left),
            ChatItem(type: .choiceList(choices, display: .list)),
            deliveredFooter(alignment: .right)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showSettings() {
        // TODO: localise?
        let items = [
            ChatItem<Choice>(type: .message("You didn't give QOT permission to access one or more areas of your phone. You can change this later in your 'Settings'"), state: .typing, delay: 3.0),
            deliveredFooter(alignment: .left)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showLastStep() {
        // TODO: localise?
        let choices = [
            Choice(title: "Let's go!", type: .go)
            ]
        let items = [
            ChatItem(type: .message("Now start experiencing the QOT app"), state: .typing, delay: 1.0),
            deliveredFooter(alignment: .left),
            ChatItem(type: .choiceList(choices, display: .list)),
            deliveredFooter(alignment: .right)
        ]
        chatViewModel.append(items: items)
    }
    
    private func completeOnboarding() {
        OnboardingCoordinator.isOnboardingComplete = true
        delegate?.onboardingCoordinatorDidFinish(self)
    }
    
    private func deliveredFooter(date: Date = Date(), alignment: NSTextAlignment) -> ChatItem<Choice> {
        let time = DateFormatter.displayTime.string(from: Date())
        return ChatItem(type: .footer(R.string.localized.prepareChatFooterDeliveredTime(time), alignment: alignment))
    }
}
