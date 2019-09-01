//
//  LocationPermissionViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LocationPermissionViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    var interactor: LocationPermissionInteractorInterface?

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
        return [skipButton, allowButton]
    }
}

// MARK: - Private

private extension LocationPermissionViewController {
}

// MARK: - Actions

private extension LocationPermissionViewController {

    @objc func didTapSkipButton() {
        interactor?.didTapSkip()
    }

    @objc func didTapAllowButton() {
        interactor?.didTapAllow()
    }
}

// MARK: - LocationPermissionViewControllerInterface

extension LocationPermissionViewController: LocationPermissionViewControllerInterface {

    func setupView() {
        ThemeView.onboarding.apply(view)
        ThemeText.locationPermissionTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.locationPermissionMessage.apply(interactor?.descriptionText, to: descriptionLabel)
    }

    func presentDeniedPermissionAlert() {
        let alert = UIAlertController(title: nil, message: interactor?.permissionDeniedMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: interactor?.alertSkipButton, style: .default, handler: { (_) in
            self.interactor?.didTapSkip()
        }))
        alert.addAction(UIAlertAction(title: interactor?.alertSettingsButton, style: .cancel, handler: { (_) in
            self.interactor?.didTapSettings()
        }))
        present(alert, animated: true, completion: nil)
    }
}
