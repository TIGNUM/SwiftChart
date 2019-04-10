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

    lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .carbonDark
        navBar.tintColor = .white
        navBar.isTranslucent = false
        let navigationItem = NavigationItem()
        navigationItem.delegate = self
        let rightBarButtonItem = UIBarButtonItem(withImage: R.image.ic_navbar_arrow_right())
        navigationItem.configure(leftButton: nil,
                                 rightButton: rightBarButtonItem,
                                 tabTitles: [pageTitle ?? ""],
                                 style: NavigationItem.Style.sand)
        navBar.items = [navigationItem]
        return navBar
    }()

    lazy var knowingViewController: KnowingViewController = {
        let knowingViewController = KnowingViewController(configure: KnowingConfigurator.make(delegate: self,
                                                                                              services: services))
        knowingViewController.title = R.string.localized.topTabBarItemTitleGuide()
        return knowingViewController
    }()

    lazy var dailyBriefViewController: DailyBriefViewController = {
        let dailyBriefViewController = DailyBriefViewController(configure: DailyBriefConfigurator.make(delegate: self,
                                                                                                       services: services))
        dailyBriefViewController.title = R.string.localized.topTabBarItemTitleGuide()
        return dailyBriefViewController
    }()

    lazy var myQotViewController: MyQotViewController = {
        let myQotViewController = MyQotViewController(configure: MyQotConfigurator.make(delegate: self))
        myQotViewController.title = R.string.localized.topTabBarItemTitleGuide()
        return myQotViewController
    }()

    lazy var coachViewController: CoachViewController = {
        let coachViewController = CoachViewController(configure: CoachConfigurator.make())
        coachViewController.title = R.string.localized.topTabBarItemTitleGuide()
        return coachViewController
    }()

    private lazy var orderedViewControllers: [UIViewController] = {
        return [myQotViewController,
                dailyBriefViewController,
                knowingViewController]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupiew()
        addScrollViewDelegate()
        setupViewControllers()
        setupFloatingButton()
    }
}

// MARK: - Private

private extension CoachPageViewController {
    func setupiew() {
        view.addSubview(navigationBar)
        if #available(iOS 11.0, *) {
            navigationBar.topAnchor == view.safeTopAnchor
            navigationBar.leadingAnchor == view.leadingAnchor
            navigationBar.trailingAnchor == view.trailingAnchor
        } else {
            navigationBar.topAnchor == view.topAnchor
            navigationBar.leadingAnchor == view.leadingAnchor
            navigationBar.trailingAnchor == view.trailingAnchor
        }
        navigationBar.heightAnchor == 44
    }

    func addScrollViewDelegate() {
        (view.subviews.filter { $0 is UIScrollView }.first as? UIScrollView)?.delegate = self
    }

    func setupViewControllers() {
        setViewControllers([dailyBriefViewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
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
        present(coachViewController, animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate

extension CoachPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        return orderedViewControllers[nextIndex]
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
    func presentCoach(from viewController: UIViewController) {
        viewController.present(coachViewController, animated: true, completion: nil)
    }

    func navigateToKnowingViewController() {
        setViewControllers([knowingViewController],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    func navigateToDailyBriefViewController() {
        setViewControllers([dailyBriefViewController],
                           direction: .forward,
                           animated: false,
                           completion: nil)
    }

    func navigateToMyQotViewController() {
        setViewControllers([myQotViewController],
                           direction: .reverse,
                           animated: false,
                           completion: nil)
    }
}

// MARK: - NavigationItemDelegate

extension CoachPageViewController: NavigationItemDelegate {
    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {}

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        var nexController: UIViewController = dailyBriefViewController
        switch currentPage {
        case .know:
            nexController = dailyBriefViewController
            currentPage = .dailyBrief
        case .dailyBrief,
             .myQot: nexController = myQotViewController
            currentPage = .myQot
        }
        setViewControllers([nexController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}
