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
    private var viewModel: CoachMark.ViewModel?
    private let pageIndicator = MyToBeVisionPageComponentView()
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    @IBOutlet private weak var buttonBack: RoundedButton!
    @IBOutlet private weak var buttonContinue: RoundedButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageIndicatorView: UIView!

    private var askedNotificationPermissions: Bool = false

    private var getCurrentPage: Int {
        return viewModel?.page ?? 0
    }

    private var getMediaName: String {
        return viewModel?.mediaName ?? ""
    }

    private var getTitle: String {
        return viewModel?.title ?? ""
    }

    private var getSubtitle: String {
        return viewModel?.subtitle ?? ""
    }

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

// MARK: - Private
private extension CoachMarksViewController {
    func setupButtons(_ hideBackButton: Bool, _ rightButtonTitle: String?) {
        buttonBack.isHidden = hideBackButton
        buttonContinue.isHidden = false
        ThemableButton.continueButton.apply(buttonContinue, title: rightButtonTitle)
    }
}

// MARK: - Actions
private extension CoachMarksViewController {
    @IBAction func didTapBack() {
        trackUserEvent(.PREVIOUS, stringValue: viewModel?.mediaName, valueType: .VIDEO, action: .TAP)
        interactor?.loadPreviousStep(page: getCurrentPage)
    }

    @IBAction func didTapContinue() {
        if viewModel?.isLastPage == true {
            interactor?.saveCoachMarksViewed()
            router?.navigateToTrack()
        } else {
            trackUserEvent(.NEXT, stringValue: viewModel?.mediaName, valueType: .VIDEO, action: .TAP)
            interactor?.loadNextStep(page: getCurrentPage)
        }
    }
}

// MARK: - CoachMarksViewControllerInterface
extension CoachMarksViewController: CoachMarksViewControllerInterface {
    func setupView() {
        ThemeButton.accent40.apply(buttonBack)
        buttonBack.isHidden = true
        collectionView.registerDequeueable(CoachMarkCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorView?.addSubview(pageIndicator)
        pageIndicator.addConstraints(to: pageIndicatorView)
        pageIndicator.pageColor = ThemeView.coachMarkPageIndicator.color
        pageIndicator.pageCount = CoachMark.Step.allCases.count
        pageIndicator.currentPageIndex = 0
    }

    func updateView(_ viewModel: CoachMark.ViewModel) {
        trackPage()
        self.viewModel = viewModel
        setupButtons(viewModel.hideBackButton, viewModel.rightButtonTitle)
        let toIndexPath = IndexPath(item: getCurrentPage, section: 0)
        pageIndicator.currentPageIndex = getCurrentPage
        collectionView.scrollToItem(at: toIndexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadItems(at: [toIndexPath])
    }
}

extension CoachMarksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return askedNotificationPermissions ? CoachMark.Step.allCases.count : 0
    }

    func scrollViewWillBeginDragging(_ scroll: UIScrollView) {
        let translation = scroll.panGestureRecognizer.translation(in: scroll.superview)
        if translation.x < 0 {
            if viewModel?.isLastPage == true {
                interactor?.saveCoachMarksViewed()
            } else {
                trackUserEvent(.NEXT, stringValue: viewModel?.mediaName, valueType: .VIDEO, action: .TAP)
                interactor?.loadNextStep(page: getCurrentPage)
            }
        } else {
            trackUserEvent(.PREVIOUS, stringValue: viewModel?.mediaName, valueType: .VIDEO, action: .TAP)
            interactor?.loadPreviousStep(page: getCurrentPage)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        currentIndexPath = indexPath
        let cell: CoachMarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(mediaName: getMediaName, title: getTitle, subtitle: getSubtitle)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
