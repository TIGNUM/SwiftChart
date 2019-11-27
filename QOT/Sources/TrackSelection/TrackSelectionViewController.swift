//
//  TrackSelectionViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class TrackSelectionViewController: BaseViewController, ScreenZLevel1 {

    // MARK: - Properties

    @IBOutlet private weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    private var askedNotificationPermissions: Bool = false

    var interactor: TrackSelectionInteractorInterface?

    lazy var fastTrackButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(didTapFastTrackButton))
        ThemableButton.trackSelection.apply(button, title: interactor?.fastTrackButton ?? "")
        return button.barButton
    }()

    lazy var guidedTrackButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(didTapGuidedTrackButton))
        ThemableButton.trackSelection.apply(button, title: interactor?.guidedTrackButton ?? "")
        return button.barButton
    }()

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !askedNotificationPermissions {
            interactor?.askNotificationPermissions()
            askedNotificationPermissions = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        refreshBottomNavigationItems()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [fastTrackButton]
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [guidedTrackButton]
    }
}

// MARK: - Private

private extension TrackSelectionViewController {
}

// MARK: - Actions

private extension TrackSelectionViewController {
    @objc func didTapFastTrackButton() {
        trackUserEvent(.FAST_TRACK, action: .TAP)
        interactor?.didTapFastTrack()
    }

    @objc func didTapGuidedTrackButton() {
        trackUserEvent(.GUIDE_TRACK, action: .TAP)
        interactor?.didTapGuidedTrack()
    }
}

// MARK: - TrackSelectionViewControllerInterface

extension TrackSelectionViewController: TrackSelectionViewControllerInterface {

    func setupView() {
        ThemeView.onboarding.apply(view)

        if let type = interactor?.type, case .registration = type {
            baseHeaderView?.lineView.isHidden = true
        }
        baseHeaderView?.configure(title: interactor?.title, subtitle: interactor?.descriptionText)
        ThemeText.trackSelectionTitle.apply(interactor?.title, to: baseHeaderView?.titleLabel)
        ThemeText.trackSelectionMessage.apply(interactor?.descriptionText, to: baseHeaderView?.subtitleTextView)
        headerViewHeightConstraint.constant = (baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0) * 2
    }
}
