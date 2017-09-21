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

    class var isOnboardingComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isOnboardingCompleteKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isOnboardingCompleteKey)
        }
    }

    init(windowManager: WindowManager, delegate: OnboardingCoordinatorDelegate, permissionHandler: PermissionHandler) {
        self.windowManager = windowManager
        self.delegate = delegate
        self.permissionHandler = permissionHandler
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
            Choice(title: "Yes, I give you confidential access to all", type: .yes),
            Choice(title: "Thank you. I prefer to give you access later", type: .later),
            Choice(title: "Why do you need access?", type: .why)
        ]
        let items = [
            ChatItem(type: .message("Welcome"), state: .typing, delay: 3.0),
            ChatItem(type: .message("Before you start, I would like access to your calendar and your location. Also, I would like to get permission to send you notifications. As always, all of your information is secure and confidential."), state: .typing, delay: 1.0),
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
            Choice(title: "Thank you. Yes, I give you confidential access to all", type: .yes),
            Choice(title: "Thank you. I prefer to give you access later", type: .later)
        ]
        let items = [
            ChatItem(type: .message("Your events and, therefore, your load is kept on your calendar. When I analyze your information, I am looking for how many meetings you have, how much time you have between meetings, how often you need to travel, etc. When I know these things, I can help you rule your impact every day. By knowing your location, I can analyze timezone changes when you travel. This way, I can provide you with custom strategies during your entire trip. Lastly, permission to send you notifications allows me to interact with you when you need it most"), state: .typing, delay: 2.0),
            deliveredFooter(alignment: .left),
            ChatItem(type: .choiceList(choices, display: .list)),
            deliveredFooter(alignment: .right)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showSettings() {
        // TODO: localise?
        let items = [
            ChatItem<Choice>(type: .message("No worries. If you change your mind, you can change this access in your preferences at any time"), state: .typing, delay: 3.0),
            deliveredFooter(alignment: .left)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showLastStep() {
        // TODO: localise?
        let items = [
            ChatItem(type: .message("Thank you, if you give me a minute, I will give you my first analysis"), state: .typing, delay: 1.0),
            deliveredFooter(alignment: .left)
        ]
        chatViewModel.append(items: items)
    }
    
    private func showLetsGo() {
        // TODO: localise?
        let choices = [
            Choice(title: "Let's go!", type: .go)
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
