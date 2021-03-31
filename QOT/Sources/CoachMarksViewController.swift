//
//  CoachMarksViewController.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CoachMarksViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    var interactor: CoachMarksInteractorInterface?
    var router: CoachMarksRouterInterface?
    private var viewModels: [CoachMark.ViewModel]?
    private let pageIndicator = MyToBeVisionPageComponentView()
    @IBOutlet private weak var buttonBack: RoundedButton!
    @IBOutlet private weak var buttonContinue: RoundedButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageIndicatorView: UIView!

    private var askedNotificationPermissions: Bool = false

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if !askedNotificationPermissions {
            interactor?.askNotificationPermissions {
                self.askedNotificationPermissions = true
                self.interactor?.viewDidLoad()
                self.collectionView.reloadData()
            }
        } else {
            self.interactor?.viewDidLoad()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if askedNotificationPermissions {
            trackPage()
        }
    }

    @objc override func refreshBottomNavigationItems() {
        if askedNotificationPermissions {
            super.refreshBottomNavigationItems()
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension CoachMarksViewController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

// MARK: - Private
private extension CoachMarksViewController {
    func setupButtons(_ hideBackButton: Bool, _ rightButtonTitle: String?) {
        buttonBack.isHidden = hideBackButton
        buttonContinue.isHidden = false
        ThemableButton.darkButton.apply(buttonContinue, title: rightButtonTitle)
    }

    func viewModel(at indexPath: IndexPath) -> CoachMark.ViewModel? {
        let index = indexPath.item
        if let models = viewModels, index < models.count {
            return models[index]
        }
        return nil
    }
}

// MARK: - Actions
private extension CoachMarksViewController {
    @IBAction func didTapBack() {
        let indexPath = collectionView.currentIndexPath
        if indexPath.item != .zero {
            let model = viewModel(at: indexPath)
            trackUserEvent(.PREVIOUS, stringValue: model?.mediaName, valueType: .VIDEO, action: .TAP)

            let previousIndexPath = IndexPath(item: (indexPath.item - 1), section: .zero)
            collectionView.scrollToItem(at: previousIndexPath, at: .centeredHorizontally, animated: true)
        }
    }

    @IBAction func didTapContinue() {
        let indexPath = collectionView.currentIndexPath
        if indexPath.item == ((viewModels?.count ?? -1) - 1) {
            interactor?.saveCoachMarksViewed()
            router?.navigateToTrack()
        } else {
            let model = viewModel(at: indexPath)
            trackUserEvent(.NEXT, stringValue: model?.mediaName, valueType: .VIDEO, action: .TAP)

            let nextIndexPath = IndexPath(item: (indexPath.item + 1), section: .zero)
            collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - CoachMarksViewControllerInterface
extension CoachMarksViewController: CoachMarksViewControllerInterface {
    func setupView() {
        NewThemeView.dark.apply(view)
        NewThemeView.dark.apply(collectionView)
        ThemeButton.whiteRounded.apply(buttonBack)
        buttonBack.isHidden = true
        collectionView.registerDequeueable(CoachMarkCollectionViewCell.self)
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageColor = ThemeView.coachMarkPageIndicator.color
        pageIndicator.pageCount = CoachMark.Step.allCases.count
        pageIndicator.currentPageIndex = .zero
    }

    func updateView(_ viewModels: [CoachMark.ViewModel]) {
        self.viewModels = viewModels
        collectionView.reloadData()
        trackPage()
        setupButtons(true, viewModels.first?.rightButtonTitle ?? .empty)
        updatePageIndicator()
    }

    func updatePageIndicator() {
        pageIndicator.currentPageIndex = collectionView.currentPageIndex
    }
}

extension CoachMarksViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return askedNotificationPermissions ? (viewModels?.count ?? .zero) : .zero
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = collectionView.currentPageIndex
        if currentIndex != pageIndicator.currentPageIndex {
            updatePageIndicator()
            let model = viewModel(at: IndexPath(item: currentIndex, section: .zero))
            setupButtons(currentIndex == .zero, model?.rightButtonTitle ?? .empty)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CoachMarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        if let model = viewModel(at: indexPath) {
            cell.configure(mediaName: model.mediaName, title: model.title ?? .empty, subtitle: model.subtitle ?? .empty)
        } else {
            cell.configure(mediaName: .empty, title: .empty, subtitle: .empty)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
