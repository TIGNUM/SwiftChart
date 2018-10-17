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
    private weak var delegate: OnboardingCoordinatorDelegate?
    private let windowManager: WindowManager
    private let chatViewModel = ChatViewModel<Choice>(items: [])
    private let permissionsManager: PermissionsManager
    private var userName: String

    class var isOnboardingComplete: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isOnboardingCompleteKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isOnboardingCompleteKey)
        }
    }

    init(windowManager: WindowManager,
         delegate: OnboardingCoordinatorDelegate,
         permissionsManager: PermissionsManager,
         userName: String) {
        self.windowManager = windowManager
        self.delegate = delegate
        self.permissionsManager = permissionsManager
        self.userName = userName
    }

    func start() {
        let chatViewController = ChatViewController(pageName: .onboardingChat,
                                                    viewModel: chatViewModel,
                                                    backgroundImage: R.image.backgroundChatBot(),
                                                    fadeMaskLocation: .top)
        chatViewController.title = R.string.localized.topTabBarItemTitlePerpareCoach()
        chatViewController.didSelectChoice = { [unowned self] (choice, viewController) in
            self.handleChoice(choice)
        }

        let navigationController = UINavigationController(rootViewController: chatViewController)
        let navigationBar = navigationController.navigationBar
        navigationBar.applyDefaultStyle()
        navigationBar.topItem?.title = R.string.localized.topTabBarItemTitlePerpareCoach().uppercased()
        navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.H5SecondaryHeadline,
                                             NSAttributedStringKey.foregroundColor: UIColor.white]
        startOnboarding() // must be called before adding chat vc to window, else chat won't animate
        windowManager.show(navigationController, animated: true, completion: nil)
    }

    // MARK: - private

    private func startOnboarding() {
        let choices = [
            Choice(title: R.string.localized.onboardingChoiceTitleAccessAll(), type: .yes),
            Choice(title: R.string.localized.onboardingChoiceTitleAccessLater(), type: .later),
            Choice(title: R.string.localized.onboardingChoiceTitleAccessWhy(), type: .why)
        ]
        let messages: [String] = [
            R.string.localized.onboardingChatItemWelcome(userName),
            R.string.localized.onboardingChatItemPermissions()
        ]
        showMessages(messages, followedByChoices: choices, at: Date())
    }

    private func handleChoice(_ choice: Choice) {
        let identifiers: [PermissionsManager.Permission.Identifier] = [
            .calendar, .notifications, .location
        ]

        switch choice.type {
        case .yes:
            permissionsManager.askPermission(for: identifiers, completion: { status in
                // decide what message to show, based on if everything was granted
                if status.filter({ $0.value == .denied }).count == 0 {
                    self.showLastStep()
                } else {
                    self.showSettings()
                }
            })
        case .later:
            identifiers.forEach({ identifier in
                permissionsManager.updateAskStatus(.askLater, for: identifier)
            })
            showSettings()
        case .why:
            showWhy()
        case .go:
            completeOnboarding()
        }
    }

    private func showWhy() {
        let choices = [
            Choice(title: R.string.localized.onboardingChoiceTitleAccessAllWhy(), type: .yes),
            Choice(title: R.string.localized.onboardingChoiceTitleAccessLaterWhy(), type: .later)
        ]
        showMessages([R.string.localized.onboardingChatItemWhy()], followedByChoices: choices, at: Date())
    }

    private func showSettings() {
        let choices = [Choice(title: R.string.localized.onboardingChoiceTitleLetsGo(), type: .go)]
        showMessages([R.string.localized.onboardingChatItemShowSettings()], followedByChoices: choices, at: Date())
    }

    private func showLastStep() {
        let choices = [Choice(title: R.string.localized.onboardingChoiceTitleLetsGo(), type: .go)]
        showMessages([R.string.localized.onboardingChatItemLastStep()], followedByChoices: choices, at: Date())
    }

    private func showMessages(_ messages: [String], followedByChoices choices: [Choice], at date: Date) {
        var items: [ChatItem<Choice>] = []
        for (index, message) in messages.enumerated() {
            let date = date.addingTimeInterval(TimeInterval(index))
            let item = messageChatItem(text: message,
                                       date: date,
                                       includeFooter: index == messages.count - 1,
                                       isAutoscrollSnapable: index == 0)
            items.append(item)
        }
        let choiceListDate = date.addingTimeInterval(TimeInterval(choices.count))
        items.append(choiceListChatItem(choices: choices, date: choiceListDate, includeFooter: true))
        chatViewModel.appendItems(items)
    }

    private func completeOnboarding() {
        OnboardingCoordinator.isOnboardingComplete = true
        delegate?.onboardingCoordinatorDidFinish(self)
    }

    private func messageChatItem(text: String,
                                 date: Date,
                                 includeFooter: Bool,
                                 isAutoscrollSnapable: Bool) -> ChatItem<Choice> {
        return ChatItem<Choice>(type: .message(text),
                                chatType: .onBoarding,
                                alignment: .left,
                                timestamp: date,
                                showFooter: includeFooter,
                                isAutoscrollSnapable: isAutoscrollSnapable)
    }

    private func choiceListChatItem(choices: [Choice], date: Date, includeFooter: Bool) -> ChatItem<Choice> {
        return ChatItem<Choice>(type: .choiceList(choices),
                                chatType: .onBoarding,
                                alignment: .right,
                                timestamp: date,
                                showFooter: includeFooter)
    }
}
