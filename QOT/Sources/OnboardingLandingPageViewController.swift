//
//  OnboardingLandingPageViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnboardingLandingPageViewController: BaseViewController, ScreenZLevelIgnore {

    // MARK: - Properties

    var interactor: OnboardingLandingPageInteractorInterface?
    private let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical)

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true

        self.view.addSubview(pageController.view)
        pageController.view.addConstraints(to: self.view)
        pageController.didMove(toParentViewController: self)

        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - OnboardingLandingPageViewControllerInterface

extension OnboardingLandingPageViewController: OnboardingLandingPageViewControllerInterface {
    func update(controller: UIViewController, direction: UIPageViewController.NavigationDirection) {
        pageController.setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
}

// MARK: - SigningInfoDelegate

extension OnboardingLandingPageViewController: SigningInfoDelegate {
    func didTapLogin() {
        if hasInternet() {
            interactor?.didTapLogin(with: nil, cachedToBeVision: nil)
        }
    }

    func didTapStart() {
        if hasInternet() {
            interactor?.didTapStart()
        }
    }
}

// MARK: - OnboardingLoginDelegate

extension OnboardingLandingPageViewController: OnboardingLoginDelegate {

    func didFinishLogin() {
        interactor?.didFinishLogin()
    }

    func showTrackSelection() {
        interactor?.showTrackSelection()
    }

    func didTapBack() {
        interactor?.didTapBack()
    }
}
