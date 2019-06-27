//
//  CoachPageViewController.swift
//  QOT
//
//  Created by karmic on 13.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol CoachCollectionViewControllerDelegate: class {
    func didTapCancel()
}

final class CoachCollectionViewController: UIViewController, ScreenZLevelBottom {

    enum Pages: Int, CaseIterable {
        case know = 0
        case dailyBrief
        case myQot
    }

    // MARK: - Properties

    var services: Services?
    private var currentPage = Pages.dailyBrief
    @IBOutlet private weak var collectionView: UICollectionView!

    lazy var pageTitle: String? = {
        let predicate = ContentService.Navigation.FirstLevel.knowPageTitle.predicate
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
        guard let myQotViewController = navController?.viewControllers.first  as? MyQotProfileViewController else {
            return nil
        }
        MyQotProfileConfigurator.configure(delegate: self, viewController: myQotViewController)
        return navController
    }()

    lazy var coachViewController: CoachViewController? = {
        let coachViewController = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.coachViewControllerID.identifier) as? CoachViewController
        CoachConfigurator.make(viewController: coachViewController)
        return coachViewController
    }()

    lazy var searchViewController: SearchViewController? = {
        let configurator = SearchConfigurator.make(delegate: self)
        let searchViewController = SearchViewController(configure: configurator, pageName: .sideBarSearch)
        return searchViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(swipeDown)
        if let searchViewController = searchViewController {
            self.addChildViewController(searchViewController)
            searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
            setupConstraints(searchViewController.view, parentView: view)
            searchViewController.view.alpha = 0
        }
        view.addSubview(collectionView)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBar(colorMode: ColorMode.dark)
    }
}

// MARK: - Private

extension CoachCollectionViewController {

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        if let view = sender.view {
            collectionView.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
        }
        view.sendSubview(toBack: collectionView)
        if translation.y > view.frame.height * 0.05 {
            let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                      rightBarButtonItems: [],
                                                      backgroundColor: view.backgroundColor ?? .clear)
            NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
            if let searchViewController = searchViewController {
                searchViewController.view.isHidden = false
                searchViewController.view.alpha = 0.8
            }
        }
      sender.setTranslation(CGPoint.zero, in: collectionView)
    }

    private func setupConstraints(_ targetView: UIView, parentView: UIView) {
        if targetView.superview != parentView {
            parentView.addSubview(targetView)
        }
        NSLayoutConstraint.activate([
            targetView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            targetView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            targetView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            targetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            targetView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
            ])
    }

    func display(contentController content: UIViewController, cell: UICollectionViewCell) {
            self.addChildViewController(content)
            cell.contentView.addSubview(content.view)
            content.view.translatesAutoresizingMaskIntoConstraints = false
            content.didMove(toParentViewController: self)
            content.view.layoutIfNeeded()
    }
}

// MARK: - UICollectionViewControllerDataSource, UICollectionViewControllerDelegate

extension CoachCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        cell.layoutIfNeeded()
        guard let section = Pages(rawValue: indexPath.row) else {
            assertionFailure()
            return UICollectionViewCell()
        }
        switch section {
        case .know:
            if let knowingNavigationController = knowingNavigationController {
                display(contentController: knowingNavigationController, cell: cell)
            }
            return cell
        case .dailyBrief:
            if let dailyBriefNavigationController = dailyBriefNavigationController {
                display(contentController: dailyBriefNavigationController, cell: cell)
            }
            return cell
        case .myQot:
            if let myQotNavigationController = myQotNavigationController {
                display(contentController: myQotNavigationController, cell: cell)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
}

extension CoachCollectionViewController: CoachCollectionViewControllerDelegate {

    func didTapCancel() {
        if let searchViewController = searchViewController {
            view.sendSubview(toBack: searchViewController.view)
        }
        let navigationItem = BottomNavigationItem(leftBarButtonItems: [],
                                                  rightBarButtonItems: [coachNavigationItem()],
                                                  backgroundColor: view.backgroundColor ?? .clear)
        NotificationCenter.default.post(name: .updateBottomNavigation, object: navigationItem)
    }
}

extension CoachCollectionViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
