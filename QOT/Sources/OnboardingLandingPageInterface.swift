//
//  OnboardingLandingPageInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol OnboardingLandingPageViewControllerInterface: class, SigningInfoDelegate, OnboardingLoginDelegate {
    func update(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
}

protocol OnboardingLandingPagePresenterInterface {
    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection)
}

protocol OnboardingLandingPageInteractorInterface: Interactor {
    func didTapLogin(with email: String?, cachedToBeVision: CachedToBeVision?)
    func didTapStart()
    func didTapBack()
}

protocol OnboardingLandingPageRouterInterface {
    func openRegistration(with cachedTBV: CachedToBeVision?)
    func popToRoot()
}
