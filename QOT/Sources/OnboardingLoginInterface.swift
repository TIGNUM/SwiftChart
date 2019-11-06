//
//  OnboardingLoginInterface.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol OnboardingLoginViewControllerInterface: UIViewController {
    var preSetUserEmail: String? { get set }
    var cachedToBeVision: QDMToBeVision? { get set }
    func setupView()
    func updateView()
    func resetView()
    func beginCodeEntry()
}

protocol OnboardingLoginPresenterInterface {
    func setupView()
    func present()
    func presentReset() 
    func presentActivity(state: ActivityState?)
    func presentCodeEntry()
}

protocol OnboardingLoginInteractorInterface: Interactor {
    var title: String { get }
    var emailPlaceholder: String { get }
    var emailInstructions: String { get }
    var preCode: String { get }
    var digitDescription: String { get }
    var buttonGetHelp: String { get }
    var buttonChangeEmail: String { get }
    var buttonResendCode: String { get }
    var buttonSeparator: String { get }

    var viewModel: OnboardingLoginViewModel { get }
    func didTapBack()
    func didTapVerify(email: String?)
    func didTapSendCode(to email: String?)

    func validateLoginCode(_ code: String, for email: String?, toBeVision: QDMToBeVision?)
    func resetEmailError()
    func resetCodeError()
    func showFAQScreen()
}

protocol OnboardingLoginRouterInterface {
    func showHomeScreen()
    func showFAQScreen()
}

protocol OnboardingLoginDelegate: class {
    func didFinishLogin()
    func showTrackSelection()
    func didTapBack()
    func didNeedToRouteToRegistration()
}
