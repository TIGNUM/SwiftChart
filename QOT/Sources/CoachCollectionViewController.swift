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
    func didTapCancelSearch()
    func handlePan(offsetY: CGFloat, isDragging: Bool, isScrolling: Bool)
    func scrollToPage(item: Int)
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
    private var didDownSyncPreparations = false
    private var didDownSyncEvents = false
    private var displaySearchDragOffset: CGFloat = 88.0
    private var displaySearchWithDecelerating: Bool = false
    private var currentPage = Page.dailyBrief
    private var isAppStart = true

    private var shouldShowSearch: Bool = false {
        didSet {
            refreshBottomNavigationItems()
        }
    }

    lazy var knowingNavigationController: KnowingNavigationController? = {
        let identifier = KnowingNavigationController.storyboardID
        let navController = instantiateViewController(with: identifier) as? KnowingNavigationController
        if let controller = navController?.viewControllers.first as? KnowingViewController {
            KnowingConfigurator.configure(delegate: self, viewController: controller)
            return navController
        }
        return nil
    }()

    lazy var dailyBriefNavigationController: DailyBriefNavigationController? = {
        let identifier = DailyBriefNavigationController.storyboardID
        let navController = instantiateViewController(with: identifier) as? DailyBriefNavigationController
        if let controller = navController?.viewControllers.first as? DailyBriefViewController {
            DailyBriefConfigurator.configure(delegate: self, viewController: controller)
            return navController
        }
        return nil
    }()

    lazy var myQotNavigationController: MyQotNavigationController? = {
        let identifier = MyQotNavigationController.storyboardID
        let navController = instantiateViewController(with: identifier) as? MyQotNavigationController
        if let controller = navController?.viewControllers.first as? MyQotMainViewController {
            MyQotMainConfigurator.configure(delegate: self, viewController: controller)
            return navController
        }
        return nil
    }()

    lazy var searchViewController: SearchViewController? = {
        let configurator = SearchConfigurator.make(delegate: self, startDeactivated: true)
        let searchViewController = SearchViewController(configure: configurator)
        return searchViewController
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        ThemeView.level1.apply(view)
        setupCoachButton()
        setupSearchViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: .dark)
        updateSearchView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RestartHelper().checkRestartURLAndRoute()
        showPreparationPopUpIfNeeded()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateSearchViewControllerConstraintsIfNeeded()
    }

    func getCurrentPage() -> Page {
        return currentPage
    }
}

// MARK: - Notification
extension CoachCollectionViewController {
    @objc func didGetScreenChangeNotification(_ notification: Notification) {
        guard let page = notification.object as? Page else { return }
        scrollToPage(item: page.rawValue)
    }

    fileprivate func updateSyncFlags(_ syncResult: SyncResultContext) {
        switch syncResult.dataType {
        case .PREPARATION: didDownSyncPreparations = true
        case .CALENDAR_EVENT: didDownSyncEvents = true
        default: break
        }
    }

    @objc func didFinishSynchronization(_ notification: Notification) {
        guard let syncResult = notification.object as? SyncResultContext,
            syncResult.syncRequestType == .DOWN_SYNC else { return }
        updateSyncFlags(syncResult)
        showPreparationPopUpIfNeeded()
    }
}

// MARK: - Coach button
extension CoachCollectionViewController {
    @IBAction func showCoachScreen() {
        let identifier = R.storyboard.coach.coachViewControllerID.identifier
        guard let controller = R.storyboard.coach()
                .instantiateViewController(withIdentifier: identifier) as? CoachViewController else { return }

        CoachConfigurator.make(viewController: controller)
        let navi = UINavigationController(rootViewController: controller)
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
    private func updateSearchViewController(currentY: CGFloat) {
        bottomSearchViewConstraint.constant = -currentY
        let duration: Double = shouldShowSearch ? 0.25 : 0.0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }

        searchViewController?.isVisible = shouldShowSearch
        if shouldShowSearch {
            searchViewController?.activate(duration)
            refreshCoachButton(alpha: 0)
        }
    }

    func updateCurrentPageController(_ controller: UIViewController?, cell: UICollectionViewCell) {
        guard let controller = controller else { return }
        if controller.parent != self {
            addChild(controller)
        }
        cell.contentView.removeSubViews()
        cell.contentView.addSubview(controller.view)
        controller.view.edges(to: cell.contentView)
        controller.didMove(toParent: self)
    }

    func currentPageController(at indexPath: IndexPath) -> UIViewController? {
        guard let page = Page(rawValue: indexPath.row) else { return nil }
        switch page {
        case .know: return knowingNavigationController
        case .dailyBrief: return dailyBriefNavigationController
        case .myX: return myQotNavigationController
        }
    }
}

// MARK: - UICollectionVieControllerDataSource, UICollectionViewControllerDelegate
extension CoachCollectionViewController: UICollectionViewDataSource,
                                         UICollectionViewDelegate,
                                         UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Page.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        cell.layoutIfNeeded()
        updateCurrentPageController(currentPageController(at: indexPath), cell: cell)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if isAppStart {
            isAppStart = false
            scrollToPage(item: Page.dailyBrief.rawValue)
        }
    }
}

// MARK: - CoachCollectionViewControllerDelegate
extension CoachCollectionViewController: CoachCollectionViewControllerDelegate {
    func didTapCancelSearch() {
        shouldShowSearch = false
        if let searchViewController = searchViewController {
            let currentViewsYPositionInWindow = view.convert(view.frame, to: view.window).minY
            bottomSearchViewConstraint.constant = -currentViewsYPositionInWindow
            UIView.animate(withDuration: 0.25) {
                searchViewController.view.superview?.layoutIfNeeded()
            }
        }
        refreshCoachButton(alpha: 1)
    }

    func handlePan(offsetY: CGFloat, isDragging: Bool, isScrolling: Bool) {
        guard shouldShowSearch == false else { return }

        let maxDistance = displaySearchDragOffset
        var newY: CGFloat = offsetY
        if offsetY <= -maxDistance, (isDragging || displaySearchWithDecelerating) {
            shouldShowSearch = true
            newY = -view.frame.height
        }
        updateSearchViewController(currentY: newY)
    }

    func scrollToPage(item: Int) {
        collectionView.scrollToItem(at: IndexPath(item: item, section: 0),
                                    at: .centeredHorizontally, animated: true)
    }
}

// MARK: - Private methods
private extension CoachCollectionViewController {
    func setupCoachButton() {
        coachButton.layer.zPosition = 10000
        let title = AppTextService.get(AppTextKey.generic_coach_button_title)
        coachButton.setAttributedTitle(NSAttributedString(string: title.uppercased(),
                                                          font: .sfProDisplayRegular(ofSize: 14),
                                                          textColor: UIColor.white,
                                                          alignment: .center),
                                       for: .normal)
    }

    func setupSearchViewController() {
        if let searchViewController = searchViewController {
            addChild(searchViewController)
            searchViewController.view.translatesAutoresizingMaskIntoConstraints = false
            setupSearchConstraints(searchViewController.view, parentView: view)
        }
    }

    func addObservers() {
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

    func updateSearchView() {
        SettingService.main.getSettingFor(key: .Level1ScreenSearchBarDragOffset) { (setting, _, _) in
            if let offset = setting?.longValue {
                self.displaySearchDragOffset = CGFloat(offset)
            }
        }

        SettingService.main.getSettingFor(key: .Level1ScreenDisplaySearchWithDecelerating) { (setting, _, _) in
            self.displaySearchWithDecelerating = setting?.booleanValue ?? false
        }
    }

    func showPreparationPopUpIfNeeded() {
        if didDownSyncEvents,
           didDownSyncPreparations,
           isTopVisibleViewController() {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .needToCheckDeletedEventForPreparation, object: nil)
            }
        }
    }

    func setupSearchConstraints(_ targetView: UIView, parentView: UIView) {
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

    func updateSearchViewControllerConstraintsIfNeeded() {
        if bottomSearchViewConstraint.constant == 0 {
            let currentViewsYPositionInWindow = view.convert(view.frame, to: view.window).minY
            bottomSearchViewConstraint.constant = -currentViewsYPositionInWindow
        }

        if heightSearchViewConstraint.constant != view.frame.height {
            heightSearchViewConstraint.constant = view.frame.height
        }
    }

    func instantiateViewController(with identifier: String) -> UIViewController? {
        return R.storyboard.main().instantiateViewController(withIdentifier: identifier)
    }

    private func refreshCoachButton(alpha: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.coachButton.alpha = alpha
        }
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
        return shouldShowSearch ? nil : super.bottomNavigationLeftBarItems()
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return shouldShowSearch ? nil : super.bottomNavigationRightBarItems()
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
