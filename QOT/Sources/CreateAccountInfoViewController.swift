//
//  CreateAccountInfoViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 07/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol CreateAccountInfoViewControllerDelegate: class {
    func didTapBack(_ controller: CreateAccountInfoViewController)
    func didTapCreate()
}

class CreateAccountInfoViewController: UIViewController, ScreenZLevel3 {

    // Properties
    weak var delegate: CreateAccountInfoViewControllerDelegate?
    @IBOutlet private weak var textLabel: UILabel!

    lazy var buttonCreate: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(didTapCreate))
        ThemableButton.createAccountInfo.apply(button, title: R.string.localized.onboardingCreateInfoButtonCreateAccount())
        return button.barButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ThemeView.onboarding.apply(view)
        ThemeText.createAccountMessage.apply(R.string.localized.onboardingCreateInfoTextDescription(), to: textLabel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        refreshBottomNavigationItems()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [buttonCreate]
    }
}

// MARK: - Private methods

private extension CreateAccountInfoViewController {
    @IBAction func didTapBack() {
        delegate?.didTapBack(self)
    }

    @objc func didTapCreate() {
        delegate?.didTapCreate()
    }
}
