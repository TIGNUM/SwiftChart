//
//  OnboardingLandingPageInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class OnboardingLandingPageInteractor {

    // MARK: - Properties

    private let worker: OnboardingLandingPageWorker
    private let presenter: OnboardingLandingPagePresenterInterface
    private let router: OnboardingLandingPageRouterInterface
    private let notificationCenter: NotificationCenter

    private var presentedControllers = [UIViewController]()
    private var cachedToBeVision: QDMToBeVision?

    // Has to be reallocated because it keeps a state
    private var tbvController: UIViewController {
        let tbvConfigurator = DecisionTreeConfigurator.make(for: .mindsetShifterTBVOnboarding)
        let tbvController = DecisionTreeViewController(configure: tbvConfigurator)
        tbvController.delegate = self
        return tbvController
    }

    private lazy var createAccountController: CreateAccountInfoViewController = {
        guard let controller = R.storyboard.createAccountInfo.createAccountInfoViewController() else {
                return CreateAccountInfoViewController()
        }
        controller.delegate = self
        return controller
    }()

    // MARK: - Init

    init(worker: OnboardingLandingPageWorker,
        presenter: OnboardingLandingPagePresenterInterface,
        router: OnboardingLandingPageRouterInterface,
        notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.notificationCenter = notificationCenter

        presentedControllers.append(worker.infoController)
        notificationCenter.addObserver(self, selector: #selector(navigateToLogin(_:)), name: .registrationShouldShowLogin, object: nil)
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.present(controller: worker.infoController, direction: .forward)
    }

    @objc func navigateToLogin(_ notification: Notification) {
        let email = notification.userInfo?[Notification.Name.RegistrationKeys.email] as? String
        let cachedTBV = notification.userInfo?[Notification.Name.RegistrationKeys.toBeVision] as? QDMToBeVision
        didTapLogin(with: email, cachedToBeVision: cachedTBV)
        router.popToRoot()
        if let first = presentedControllers.first, let last = presentedControllers.last {
            presentedControllers = [first, last]
        }
    }
}

// Private methods

private extension OnboardingLandingPageInteractor {
    func navigateBack() {
        presentedControllers.removeLast()
        guard let previousController = presentedControllers.last else {
            return
        }
        presenter.present(controller: previousController, direction: .reverse)
    }
}

// MARK: - OnboardingLandingPageInteractorInterface

extension OnboardingLandingPageInteractor: OnboardingLandingPageInteractorInterface {

    func didTapStart() {
        let controller = tbvController
        presentedControllers.append(controller)
        presenter.present(controller: controller, direction: .forward)
    }

    func didTapLogin(with email: String? = nil, cachedToBeVision: QDMToBeVision? = nil) {
        let controller = worker.loginController
        presentedControllers.append(controller)
        controller.preSetUserEmail = email
        controller.cachedToBeVision = cachedToBeVision
        presenter.present(controller: controller, direction: .forward)
    }

    func didTapBack() {
        navigateBack()
    }

    func didTapSaveTBV() {
        let controller = createAccountController
        presentedControllers.append(controller)
        presenter.present(controller: controller, direction: .forward)
    }

    func showTrackSelection() {
        router.showTrackSelection()
    }
}

// MARK: - DecisionTreeViewControllerDelegate

extension OnboardingLandingPageInteractor: DecisionTreeViewControllerDelegate {
    func toBeVisionDidChange() {
        // noop
    }

    func didDismiss() {
        // noop
    }

    func dismissOnMoveBackwards() {
        navigateBack()
    }

    func createToBeVision(_ toBeVision: QDMToBeVision) {
        print("ZZ:\n\n________ EUREKA!!!________\n\n")
        cachedToBeVision = toBeVision
        didTapSaveTBV()
    }
}

// MARK: - CreateAccountInfoViewControllerDelegate

extension OnboardingLandingPageInteractor: CreateAccountInfoViewControllerDelegate {

    func didTapBack(_ controller: CreateAccountInfoViewController) {
        didTapBack()
    }

    func didTapCreate() {
        router.openRegistration(with: cachedToBeVision)
    }
}
