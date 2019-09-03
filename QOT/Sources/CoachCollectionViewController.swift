//
//  CoachPageViewController.swift
//  QOT
//
//  Created by karmic on 13.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import qot_dal

protocol CoachCollectionViewControllerDelegate: class {
    func didTapCancel()
    func handlePan(offsetY: CGFloat)
    func moveToCell(item: Int)
}

final class CoachCollectionViewController: UIViewController, ScreenZLevel1 {

    enum Pages: Int, CaseIterable {
        case know = 0
        case dailyBrief
        case myQot
    }

    // MARK: - Properties

    var services: Services?
    private var currentPage = Pages.dailyBrief
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var coachButton: UIButton!
    private var bottomSearchViewConstraint: NSLayoutConstraint!
    private var panActive = false
    private var panSearchShowing: Bool = false {
        didSet {
            refreshBottomNavigationItems()
        }
    }

    lazy var pageTitle: String? = {
        return ScreenTitleService.main.localizedString(for: .knowPageTitle)
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
        guard let dailyBriefViewController = navController?.viewControllers.first as? DailyBriefViewController else {
            return nil
        }
        DailyBriefConfigurator.configure(delegate: self, viewController: dailyBriefViewController)
        return navController
    }()

    lazy var myQotNavigationController: MyQotNavigationController? = {
        let navController = R.storyboard.main().instantiateViewController(withIdentifier: MyQotNavigationController.storyboardID) as? MyQotNavigationController
        guard let myQotViewController = navController?.viewControllers.first  as? MyQotMainViewController else {
            return nil
        }
        MyQotMainConfigurator.configure(delegate: self, viewController: myQotViewController)
        return navController
    }()

    lazy var searchViewController: SearchViewController? = {
        let configurator = SearchConfigurator.make(delegate: self)
        let searchViewController = SearchViewController(configure: configurator, pageName: .sideBarSearch)
        return searchViewController
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return ColorMode.dark.statusBarStyle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(view)
        coachButton.layer.zPosition = 10000

        if let searchViewController = searchViewController {
            self.addChildViewController(searchViewController)
            searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
            setupSearchConstraints(searchViewController.view, parentView: view)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)

        coachButton.alpha = 0.0
        UIView.animate(withDuration: 0.75) {
            self.coachButton.alpha = 1.0
        }
    }
}

// MARK: - Coach button

extension CoachCollectionViewController {
    @IBAction func showCoachScreen() {
        guard let coachViewController = R.storyboard.coach().instantiateViewController(withIdentifier: R.storyboard.coach.coachViewControllerID.identifier) as? CoachViewController else {
            return
        }
        CoachConfigurator.make(viewController: coachViewController)
        let navi = UINavigationController(rootViewController: coachViewController)
        navi.modalTransitionStyle = .coverVertical
        navi.isNavigationBarHidden = true
        navi.isToolbarHidden = true
        navi.view.backgroundColor = .clear
        present(navi, animated: true)
        trackUserEvent(.OPEN, valueType: "COACH", action: .TAP)
    }
}
// MARK: - handlepan

extension CoachCollectionViewController {

    private func updatePan(currentY: CGFloat) {
        bottomSearchViewConstraint.constant = panActive ? -currentY : 0.0
        let duration: Double = panSearchShowing ? 0.25 : 0.0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }

        if panSearchShowing {
            searchViewController?.activate(duration)
        }
    }

    private func setupSearchConstraints(_ targetView: UIView, parentView: UIView) {
        if targetView.superview != parentView {
            parentView.addSubview(targetView)
        }
        bottomSearchViewConstraint = targetView.bottomAnchor.constraint(equalTo: parentView.topAnchor, constant: 0)
        NSLayoutConstraint.activate([
            targetView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            targetView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0),
            targetView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height),
            bottomSearchViewConstraint,
            targetView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: 0)
            ])
    }

    func display(contentController content: UIViewController, cell: UICollectionViewCell) {
        if content.parent != self {
            self.addChildViewController(content)
        }
        cell.contentView.removeSubViews()
        cell.contentView.addSubview(content.view)
        content.view.edges(to: cell.contentView)
        content.didMove(toParentViewController: self)
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
        panSearchShowing = false
        if let searchViewController = searchViewController {
            bottomSearchViewConstraint.constant = 0
            UIView.animate(withDuration: 0.25) {
                searchViewController.view.superview?.layoutIfNeeded()
            }
        }
    }

    func handlePan(offsetY: CGFloat) {
        if panSearchShowing { return }

        let maxDistance = view.frame.height * 0.25
        var newY: CGFloat = offsetY

        if panActive {
            if offsetY >= 0 {
                panActive = false
            }
        } else {
            if offsetY < 0 {
                panActive = true
            }
        }
        if offsetY <= -maxDistance {
            panSearchShowing = true
            newY = -view.frame.height
        }
        updatePan(currentY: newY)
    }

    func moveToCell(item: Int) {
        collectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension CoachCollectionViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Bottom Navigation
extension CoachCollectionViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if panSearchShowing {
            return nil
        }
        return super.bottomNavigationLeftBarItems()
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if panSearchShowing {
            return nil
        }
        return super.bottomNavigationRightBarItems()
    }
}
