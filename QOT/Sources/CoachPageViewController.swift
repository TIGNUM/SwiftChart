//
//  CoachPageViewController.swift
//  QOT
//
//  Created by karmic on 13.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol CoachPageViewControllerDelegate: class {
    func presentCoach(from viewController: UIViewController)
    func navigateToKnowingViewController()
    func navigateToDailyBriefViewController()
    func navigateToMyQotViewController()
}

final class CoachPageViewController: UIPageViewController {

    enum Pages: Int, CaseIterable {
        case know = 0
        case dailyBrief
        case myQot
    }

    // MARK: - Properties

    var services: Services?
    private var currentPage = Pages.dailyBrief

    lazy var pageTitle: String? = {
        let predicate = ContentService.Tags.Navigation.FirstLevel.knowPageTitle.predicate
        return services?.contentService.contentItem(for: predicate)?.valueText
    }()

    lazy var knowingNavigationController: KnowingNavigationController? = {
        let navController = R.storyboard.main().instantiateViewController(withIdentifier: KnowingNavigationController.storyboardID) as? KnowingNavigationController
        guard let knowingViewController = navController?.viewControllers.first  as? KnowingViewController else {
            return nil
        }
        KnowingConfigurator.configure(delegate: self, services: services, viewController: knowingViewController)
        return navController
    }()

    lazy var dailyBriefNavigationController: DailyBriefNavigationController? = {
        let navController = R.storyboard.main().instantiateViewController(withIdentifier: DailyBriefNavigationController.storyboardID) as? DailyBriefNavigationController
        guard let dailyBriefViewController = navController?.viewControllers.first  as? DailyBriefViewController else {
            return nil
        }
        DailyBriefConfigurator.configure(delegate: self, services: services, viewController: dailyBriefViewController)
        return navController
    }()

    lazy var myQotNavigationController: MyQotNavigationController? = {
        let navController = R.storyboard.main().instantiateViewController(withIdentifier: MyQotNavigationController.storyboardID) as? MyQotNavigationController
        guard let myQotViewController = navController?.viewControllers.first  as? MyQotViewController else {
            return nil
        }
        MyQotConfigurator.configure(delegate: self, viewController: myQotViewController)
        return navController
    }()

    lazy var coachViewController: CoachViewController = {
        let coachViewController = CoachViewController(configure: CoachConfigurator.make())
        coachViewController.title = R.string.localized.topTabBarItemTitleGuide()
        return coachViewController
    }()

    private lazy var orderedControllers: [UIViewController] = {
        if
            let knowController = knowingNavigationController,
            let dailyBriefController = dailyBriefNavigationController,
            let myQotController = myQotNavigationController {
            return [myQotController,
                    dailyBriefController,
                    knowController]
        }
        return []
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        addScrollViewDelegate()
        setupViewControllers()
        setupFloatingButton()
    }
}

// MARK: - Private

private extension CoachPageViewController {

    func addScrollViewDelegate() {
        (view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView)?.delegate = self
    }

    func setupViewControllers() {
        if let dailyBriefController = knowingNavigationController {
            setViewControllers([dailyBriefController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    func setupFloatingButton() {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTabCoachButton), for: .touchUpInside)
        button.setImage(R.image.ic_coach(), for: .normal)
        let size = CGSize(width: 80, height: 80)
        let offset = (24 + size.width * 0.5)
        let center = CGPoint(x: view.frame.width - offset, y: view.frame.height - offset)
        button.frame = CGRect(center: center, size: size)
        let radius = button.bounds.width / 2
        button.corner(radius: radius)
        view.addSubview(button)
    }
}

// MARK: - Actions

extension CoachPageViewController {
    @objc func didTabCoachButton() {
        let permissionsManager = AppDelegate.appState.permissionsManager!
        let configurator = DecisionTreeConfigurator.make(for: .toBeVisionGenerator, permissionsManager: permissionsManager)
        let viewController = DecisionTreeViewController(configure: configurator)
        present(viewController, animated: true)
//        present(coachViewController, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension CoachPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedControllers.count > previousIndex else { return nil }
        return orderedControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return orderedControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed == true else { return }
        if pageViewController.viewControllers?.first is KnowingViewController {
            currentPage = .know
        }
        if pageViewController.viewControllers?.first is DailyBriefViewController {
            currentPage = .dailyBrief
        }
        if pageViewController.viewControllers?.first is MyQotViewController {
            currentPage = .myQot
        }
    }
}

extension CoachPageViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
    }
}

extension CoachPageViewController: CoachPageViewControllerDelegate {
    func navigateToKnowingViewController() {

    }

    func navigateToDailyBriefViewController() {

    }

    func navigateToMyQotViewController() {

    }

    func presentCoach(from viewController: UIViewController) {
        viewController.present(coachViewController, animated: true, completion: nil)
    }
}

// MARK: - NavigationItemDelegate

extension CoachPageViewController: NavigationItemDelegate {
    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {}

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        var nextController: UINavigationController? = dailyBriefNavigationController
        switch currentPage {
        case .know:
            nextController = dailyBriefNavigationController
            currentPage = .dailyBrief
        case .dailyBrief,
             .myQot: nextController = myQotNavigationController
            currentPage = .myQot
        }
        if let nextController = nextController {
            setViewControllers([nextController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}
