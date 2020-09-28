//
//  CoachPageViewController.swift
//  QOT
//
//  Created by karmic on 13.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

// MARK: Session Related Notification
public extension Notification.Name {
    static let showFirstLevelScreen = Notification.Name("showFirstLevelScreen")
}

protocol CoachCollectionViewControllerDelegate: class {
    func didTapCancel()
    func handlePan(offsetY: CGFloat, isDragging: Bool, isScrolling: Bool)
    func moveToCell(item: Int)
}

final class CoachCollectionViewController: BaseViewController, ScreenZLevel1 {

    enum Page: Int, CaseIterable {
        case know = 0
        case dailyBrief
        case myX
    }

    // MARK: - Properties
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var coachButton: UIButton!
    private var bottomSearchViewConstraint: NSLayoutConstraint!
    private var heightSearchViewConstraint: NSLayoutConstraint!
    private var preSelectedItem: Page? = .dailyBrief
    private var panActive = false
    private var panSearchShowing: Bool = false {
        didSet {
            refreshBottomNavigationItems()
        }
    }
    private var didDownSyncPreparations = false
    private var didDownSyncEvents = false
    private var displaySearchDragOffset: CGFloat = 88.0
    private var displaySearchWithDecelerating: Bool = false
    private var currentPage = Page.dailyBrief

    func getCurrentPage() -> Page {
        return currentPage
    }

    lazy var knowingNavigationController: KnowingNavigationController? = {
        let navController = R.storyboard.main().instantiateViewController(withIdentifier: KnowingNavigationController.storyboardID) as? KnowingNavigationController
        guard let knowingViewController = navController?.viewControllers.first  as? KnowingViewController else {
            return nil
        }
        KnowingConfigurator.configure(delegate: self, viewController: knowingViewController)
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
        let configurator = SearchConfigurator.make(delegate: self, startDeactivated: true)
        let searchViewController = SearchViewController(configure: configurator)
        return searchViewController
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(view)
        coachButton.layer.zPosition = 10000

        if let searchViewController = searchViewController {
            self.addChild(searchViewController)
            searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
            setupSearchConstraints(searchViewController.view, parentView: view)
        }

        _ = NotificationCenter.default.addObserver(forName: .showFirstLevelScreen,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didGetScreenChangeNotification(notification)
        }
        _ = NotificationCenter.default.addObserver(forName: .didFinishSynchronization,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.didFinishSynchronization(notification)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: .dark)

        coachButton.alpha = 0.0
        UIView.animate(withDuration: 0.75) { [weak self] in
            self?.coachButton.alpha = self?.panSearchShowing == true ? 0.0 : 1.0
        }

        let settingService = SettingService.main
        settingService.getSettingFor(key: .Level1ScreenSearchBarDragOffset) { (setting, _, _) in
            if let offset = setting?.longValue {
                self.displaySearchDragOffset = CGFloat(offset)
            }
        }

        settingService.getSettingFor(key: .Level1ScreenDisplaySearchWithDecelerating) { (setting, _, _) in
            self.displaySearchWithDecelerating = setting?.booleanValue ?? false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Handle stored link when it's ready to handle
        RestartHelper().checkRestartURLAndRoute()

        //because of QOT-2324, when Level 1 Screen is shown we can show PopUp screen for Preparations with unrecognized events.
        if didDownSyncEvents, didDownSyncPreparations {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .needToCheckDeletedEventForPreparation, object: nil)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if bottomSearchViewConstraint.constant == 0 {
            let currentViewsYPositionInWindow = view.convert(view.frame, to: view.window).minY
            bottomSearchViewConstraint.constant = -currentViewsYPositionInWindow
        }

        if heightSearchViewConstraint.constant != view.frame.height {
            heightSearchViewConstraint.constant = view.frame.height
        }
    }
}

// MARK: - Notification
extension CoachCollectionViewController {
    @objc func didGetScreenChangeNotification(_ notification: Notification) {
        guard let page = notification.object as? Page else { return }
        moveToCell(item: page.rawValue)
    }

    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext,
            syncResult.syncRequestType == .DOWN_SYNC else { return }
        switch syncResult.dataType {
        case .PREPARATION: didDownSyncPreparations = true
        case .CALENDAR_EVENT: didDownSyncEvents = true
        default: break
        }

        //because of QOT-2324, when Level 1 Screen is shown we can show PopUp screen for Preparations with unrecognized events.
        if didDownSyncEvents, didDownSyncPreparations, isTopVisibleViewController() {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .needToCheckDeletedEventForPreparation, object: nil)
            }
        }
    }
}

// MARK: - Coach button
extension CoachCollectionViewController {
    @IBAction func showCoachScreen() {
//        guard let coachViewController = R.storyboard.coach().instantiateViewController(withIdentifier: R.storyboard.coach.coachViewControllerID.identifier) as? CoachViewController else {
//            return
//        }

        guard let teamVisionTrackerDetails = R.storyboard.teamVisionTrackerDetails.teamVisionTrackerDetailsID() else {
            return
        }
        let configurator = TeamVisionTrackerDetailsConfigurator.make()
        configurator(teamVisionTrackerDetails)
//        CoachConfigurator.make(viewController: coachViewController)
        let navi = UINavigationController(rootViewController: teamVisionTrackerDetails)
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
    private func updatePan(currentY: CGFloat, isDragging: Bool) {
        let currentViewsYPositionInWindow = view.convert(view.frame, to: view.window).minY
        bottomSearchViewConstraint.constant = panActive ? -currentY : -currentViewsYPositionInWindow
        let duration: Double = panSearchShowing ? 0.25 : 0.0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        refreshCoachButton(isDragging: isDragging)
        searchViewController?.showing = panSearchShowing
        if panSearchShowing {
            searchViewController?.activate(duration)
        }
    }

    private func refreshCoachButton(isDragging: Bool) {
        if isDragging, bottomSearchViewConstraint.constant <= 0 {
            UIView.animate(withDuration: 0.5) {
                self.coachButton.alpha = 0
            }
        } else if !isDragging || bottomSearchViewConstraint.constant > 0 {
            let newAlpha: CGFloat = abs(1 - min((CGFloat(bottomSearchViewConstraint.constant) / 100), 1))
            let alpha = min(newAlpha, 1.0)
            UIView.animate(withDuration: 0.5) {
                self.coachButton.alpha = alpha
            }
        }
    }

    private func setupSearchConstraints(_ targetView: UIView, parentView: UIView) {
        if targetView.superview != parentView {
            parentView.addSubview(targetView)
        }
        let currentViewsYPositionInWindow = view.convert(view.frame, to: view.window).minY
        bottomSearchViewConstraint = targetView.bottomAnchor.constraint(equalTo: parentView.topAnchor,
                                                                        constant: -currentViewsYPositionInWindow)
        heightSearchViewConstraint = targetView.heightAnchor.constraint(equalToConstant: parentView.bounds.height)
        NSLayoutConstraint.activate([
            targetView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            targetView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0),
            heightSearchViewConstraint,
            bottomSearchViewConstraint,
            targetView.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: 0)
            ])
    }

    func display(contentController content: UIViewController, cell: UICollectionViewCell) {
        if content.parent != self {
            self.addChild(content)
        }
        cell.contentView.removeSubViews()
        cell.contentView.addSubview(content.view)
        content.view.edges(to: cell.contentView)
        content.didMove(toParent: self)
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
        guard let page = Page(rawValue: indexPath.row) else {
            assertionFailure()
            return UICollectionViewCell()
        }
        switch page {
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
        case .myX:
            if let myQotNavigationController = myQotNavigationController {
                display(contentController: myQotNavigationController, cell: cell)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Show Daily Brief on app launch
        guard let item = preSelectedItem else { return }
        moveToCell(item: item.rawValue, animated: false)
        preSelectedItem = nil
    }
}

// MARK: - CoachCollectionViewControllerDelegate
extension CoachCollectionViewController: CoachCollectionViewControllerDelegate {
    func didTapCancel() {
        panSearchShowing = false
        if let searchViewController = searchViewController {
            let currentViewsYPositionInWindow = view.convert(view.frame, to: view.window).minY
            bottomSearchViewConstraint.constant = -currentViewsYPositionInWindow
            UIView.animate(withDuration: 0.25) {
                self.refreshCoachButton(isDragging: false)
                searchViewController.view.superview?.layoutIfNeeded()
            }
        }
    }

    func handlePan(offsetY: CGFloat, isDragging: Bool, isScrolling: Bool) {
        if panSearchShowing { return }

        let maxDistance = displaySearchDragOffset
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
        if offsetY <= -maxDistance, (isDragging || displaySearchWithDecelerating) {
            panSearchShowing = true
            newY = -view.frame.height
        }
        updatePan(currentY: newY, isDragging: isDragging)
    }

    func moveToCell(item: Int) {
        moveToCell(item: item, animated: true)
    }
}

// MARK: - Private methods
private extension CoachCollectionViewController {
    func moveToCell(item: Int, animated: Bool) {
        collectionView.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CoachCollectionViewController {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
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

// MARK: - UIScrollViewDelegate
extension CoachCollectionViewController: UIScrollViewDelegate {
    func getCurrentIndexPath() -> IndexPath {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        return collectionView.indexPathForItem(at: visiblePoint) ?? IndexPath(item: 0, section: 0)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch getCurrentIndexPath().item {
        case 0:
            currentPage = .know
        case 1:
            currentPage = .dailyBrief
        case 2:
            currentPage = .myX
        default: return
        }
    }
}
