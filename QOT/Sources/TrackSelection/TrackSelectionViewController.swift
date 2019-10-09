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

    @IBOutlet private weak var titleSuperviewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dashView: UIView!
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
            dashView.isHidden = true
            titleSuperviewTopConstraint.priority = .defaultHigh
        }
        ThemeText.trackSelectionTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.trackSelectionMessage.apply(interactor?.descriptionText, to: descriptionLabel)
    }
}
