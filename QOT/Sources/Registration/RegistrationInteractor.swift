//
//  RegistrationInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct RegistrationData {
    var email: String = ""
    var code: String = ""
    var firstName: String = ""
    var lastName: String?
    var birthYear: String = ""
}

final class RegistrationInteractor: RegistrationInteractorInterface {

    // MARK: - Properties
    private let presenter: RegistrationPresenterInterface
    private let router: RegistrationRouterInterface
    private var registrationData = RegistrationData()
    private var presentedControllers: [UIViewController] = [UIViewController]()
    private lazy var worker = RegistrationWorker()

    private var codeController: RegistrationCodeViewController {
        let configurator = RegistrationCodeConfigurator.make()
        let controller = R.storyboard.registrationCode.registrationCodeViewController() ?? RegistrationCodeViewController()
        configurator(controller, registrationData.email, self)
        return controller
    }

    private lazy var namesController: RegistrationNamesViewController = {
        let configurator = RegistrationNamesConfigurator.make()
        let controller = R.storyboard.registrationNames.registrationNamesViewController() ?? RegistrationNamesViewController()
        configurator(controller, self)
        return controller
    }()

    private var ageController: RegistrationAgeViewController {
        let configurator = RegistrationAgeConfigurator.make()
        let controller = R.storyboard.registrationAge.registrationAgeViewController() ?? RegistrationAgeViewController()
        configurator(controller, self)
        return controller
    }

    private lazy var trackSelectionController: TrackSelectionViewController = {
        let configurator = TrackSelectionConfigurator.make()
        let controller = R.storyboard.trackSelection.trackSelectionViewController() ?? TrackSelectionViewController()
        configurator(controller, TrackSelectionControllerType.registration)
        return controller
    }()

    var totalPageCount: Int {
        return 4
    }

    var currentPage: Int {
        return presentedControllers.count - 1
    }

    var currentController: UIViewController? {
        return presentedControllers.last
    }

    // MARK: - Init
    init(presenter: RegistrationPresenterInterface, router: RegistrationRouter) {
        self.presenter = presenter
        self.router = router

        let controller = R.storyboard.registrationEmail.registrationEmailViewController() ?? RegistrationEmailViewController()
        let configurator = RegistrationEmailConfigurator.make()
        presentedControllers = [controller]
        configurator(controller, self)
    }

    // MARK: - Interactorq
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - RegistrationDelegate
extension RegistrationInteractor: RegistrationDelegate {
    func didTapBack() {
        guard presentedControllers.count > 1 else {
            router.popBack()
            return
        }
        _ = presentedControllers.removeLast()
        if let next = presentedControllers.last {
            presenter.present(controller: next, direction: .reverse)
        }
    }

    func didVerifyEmail(_ email: String) {
        registrationData.email = email
        presentedControllers.append(codeController)
        presenter.present(controller: codeController, direction: .forward)
    }

    func didVerifyCode(_ code: String) {
        registrationData.code = code
        presentedControllers.append(namesController)
        presenter.present(controller: namesController, direction: .forward)
    }

    func didSave(firstName: String, lastName: String?) {
        registrationData.firstName = firstName
        registrationData.lastName = lastName
        presentedControllers.append(ageController)
        presenter.present(controller: ageController, direction: .forward)
    }

    func didTapCreateAccount(with birthYear: String) {
        registrationData.birthYear = birthYear
        presenter.presentActivity(state: .inProgress)
        worker.createAccount(with: registrationData) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            self?.presenter.presentActivity(state: nil)
            if case .userCreated =  result.code {
                // Success
                self?.handleSuccess()
            } else {
                // Failure
                strongSelf.presenter.presentAlert(message: result.message ?? strongSelf.worker.generalError)
            }
        }
    }
}

private extension RegistrationInteractor {
    func handleSuccess() {
        self.presentedControllers.append(self.trackSelectionController)
        self.presenter.present(controller: self.trackSelectionController, direction: .forward)
    }
}
