//
//  OnboardingLandingPageInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol OnboardingLandingPageViewControllerInterface: SigningInfoDelegate, OnboardingLoginDelegate {
    func update(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
}

protocol OnboardingLandingPagePresenterInterface {
    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
}

protocol OnboardingLandingPageInteractorInterface: Interactor {
    func didTapLogin(with email: String?, cachedToBeVision: QDMToBeVision?)
    func didFinishLogin()
    func didTapStart()
    func didTapBack()
    func showTrackSelection()
}

protocol OnboardingLandingPageRouterInterface {
    func openRegistration(with cachedTBV: QDMToBeVision?)
    func popToRoot()
    func showTrackSelection()
}
