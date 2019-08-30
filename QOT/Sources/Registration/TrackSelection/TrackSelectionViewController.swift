//
//  TrackSelectionViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class TrackSelectionViewController: UIViewController, ScreenZLevel1 {

    // MARK: - Properties

    @IBOutlet private weak var titleSuperviewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dashView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var interactor: TrackSelectionInteractorInterface?

    lazy var fastTrackButton: UIBarButtonItem = {
        let button = RoundedButton(title: interactor?.fastTrackButton ?? "",
                                   target: self,
                                   action: #selector(didTapFastTrackButton))
        return UIBarButtonItem(customView: button)
    }()

    lazy var guidedTrackButton: UIBarButtonItem = {
        let button = RoundedButton(title: interactor?.guidedTrackButton ?? "",
                                   target: self,
                                   action: #selector(didTapGuidedTrackButton))
        return UIBarButtonItem(customView: button)
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
        interactor?.didTapFastTrack()
    }

    @objc func didTapGuidedTrackButton() {
        interactor?.didTapGuidedTrack()
    }
}

// MARK: - TrackSelectionViewControllerInterface

extension TrackSelectionViewController: TrackSelectionViewControllerInterface {

    func setupView() {
        if let type = interactor?.type, case .registration = type {
            dashView.isHidden = true
            titleSuperviewTopConstraint.priority = .defaultHigh
        }
        titleLabel.text = interactor?.title
        descriptionLabel.text = interactor?.descriptionText
    }
}
