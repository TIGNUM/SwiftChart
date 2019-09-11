//
//  NotificationPermissionViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class NotificationPermissionViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    var interactor: NotificationPermissionInteractorInterface?

    lazy var skipButton: UIBarButtonItem = {
        let button = RoundedButton(title: interactor?.skipButton ?? "", target: self, action: #selector(didTapSkipButton))
        return UIBarButtonItem(customView: button)
    }()

    lazy var allowButton: UIBarButtonItem = {
        let button = RoundedButton(title: interactor?.allowButton ?? "", target: self, action: #selector(didTapAllowButton))
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
        bottomConstraint.constant = BottomNavigationContainer.height - 30
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [fixedSpace(22), allowButton, fixedSpace(24), skipButton]
    }
}

// MARK: - Private

private extension NotificationPermissionViewController {

    func fixedSpace(_ width: CGFloat) -> UIBarButtonItem {
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = width
        return space
    }
}

// MARK: - Actions

private extension NotificationPermissionViewController {

    @objc func didTapSkipButton() {
        interactor?.didTapSkip()
    }

    @objc func didTapAllowButton() {
        interactor?.didTapAllow()
    }
}

// MARK: - LocationPermissionViewControllerInterface

extension NotificationPermissionViewController: NotificationPermissionViewControllerInterface {

    func setupView() {
        ThemeView.onboarding.apply(view)
        ThemeText.locationPermissionTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.locationPermissionMessage.apply(interactor?.descriptionText, to: descriptionLabel)
    }

    func presentDeniedPermissionAlert() {
        let alert = UIAlertController(title: nil, message: interactor?.permissionDeniedMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: interactor?.alertSkipButton, style: .default, handler: { [weak self] (_) in
            self?.interactor?.didTapSkip()
        }))
        alert.addAction(UIAlertAction(title: interactor?.alertSettingsButton, style: .cancel, handler: { [weak self] (_) in
            self?.interactor?.didTapSettings()
        }))
        present(alert, animated: true, completion: nil)
    }
}
