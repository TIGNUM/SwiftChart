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
    private let windowManager: WindowManager
    private let chatViewModel = ChatViewModel<Choice>()
    fileprivate let permissionHandler: PermissionHandler
    private var userName: String

    class var isOnboardingComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isOnboardingCompleteKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isOnboardingCompleteKey)
        }
    }

    init(windowManager: WindowManager, delegate: OnboardingCoordinatorDelegate, permissionHandler: PermissionHandler, userName: String) {
        self.windowManager = windowManager
        self.delegate = delegate
        self.permissionHandler = permissionHandler
        self.userName = userName
    }
    
    func start() {
        let chatViewController = ChatViewController(pageName: .onboardingChat, viewModel: chatViewModel, backgroundImage: R.image.backgroundChatBot())
        chatViewController.title = R.string.localized.topTabBarItemTitlePerpareCoach()
        chatViewController.didSelectChoice = { [unowned self] (choice, viewController) in
            self.handleChoice(choice)
        }
        
        let navigationController = UINavigationController(rootViewController: chatViewController)
        let navigationBar = navigationController.navigationBar
        navigationBar.applyDefaultStyle()
        navigationBar.topItem?.title = R.string.localized.topTabBarItemTitlePerpareCoach().uppercased()
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Font.H5SecondaryHeadline, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        startOnboarding() // must be called before adding chat vc to window, else chat won't animate
        
        windowManager.setRootViewController(navigationController, atLevel: .normal, animated: true, completion: nil)
    }
    
    // MARK: - private
    
    private func startOnboarding() {
        // TODO: localise?
        let choices = [
            Choice(title: R.string.localized.onboardingChoiceTitleAccessAll(), type: .yes),
            Choice(title: R.string.localized.onboardingChoiceTitleAccessLater(), type: .later),
            Choice(title: R.string.localized.onboardingChoiceTitleAccessWhy(), type: .why)
        ]
        let items = [
            ChatItem(type: .message(R.string.localized.onboardingChatItemWelcome(userName)), state: .typing, delay: 3.0),
            ChatItem(type: .message(R.string.localized.onboardingChatItemPermissions()), state: .typing, delay: 1.0),
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

                if result.location == true {
                    UserDefault.locationService.setBoolValue(value: true)
                }

                if result.isAllGranted {
                    self.showLastStep()
                    self.showLetsGo()
                } else {
                    self.showSettings()
                    self.showLetsGo()
                }
            })
        case .later:
            permissionHandler.isEnabledForSession = false
            showSettings()
            showLetsGo()
        case .why:
            showWhy()
        case .go:
            completeOnboarding()
        }
    }
    
    private func showWhy() {
        // TODO: localise?
        let choices = [
            Choice(title: R.string.localized.onboardingChoiceTitleAccessAllWhy(), type: .yes),
            Choice(title: R.string.localized.onboardingChoiceTitleAccessLaterWhy(), type: .later)
        ]
        let items = [
            ChatItem(type: .message(R.string.localized.onboardingChatItemWhy()), state: .typing, delay: 2.0),
            deliveredFooter(alignment: .left),
            ChatItem(type: .choiceList(choices, display: .list)),
            deliveredFooter(alignment: .right)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showSettings() {
        // TODO: localise?
        let items = [
            ChatItem<Choice>(type: .message(R.string.localized.onboardingChatItemShowSettings()), state: .typing, delay: 3.0),
            deliveredFooter(alignment: .left)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showLastStep() {
        // TODO: localise?
        let items = [
            ChatItem(type: .message(R.string.localized.onboardingChatItemLastStep()), state: .typing, delay: 1.0),
            deliveredFooter(alignment: .left)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showLetsGo() {
        // TODO: localise?
        let choices = [
            Choice(title: R.string.localized.onboardingChoiceTitleLetsGo(), type: .go)
        ]
        let items = [
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
