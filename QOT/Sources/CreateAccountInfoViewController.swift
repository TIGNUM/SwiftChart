//
//  CreateAccountInfoViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 07/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol CreateAccountInfoViewControllerDelegate: class {
    func didTapBack(_ controller: CreateAccountInfoViewController)
    func didTapCreate()
}

class CreateAccountInfoViewController: BaseViewController, ScreenZLevel1 {

    // Properties
    weak var delegate: CreateAccountInfoViewControllerDelegate?
    @IBOutlet private weak var textLabel: UILabel!

    lazy var buttonCreate: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(didTapCreate))
        ThemableButton.createAccountInfo.apply(button, title: AppTextService.get(AppTextKey.onboarding_sign_up_create_account_section_footer_button_create_account))
        return button.barButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ThemeView.onboarding.apply(view)
        ThemeText.createAccountMessage.apply(AppTextService.get(AppTextKey.onboarding_sign_up_create_account_section_header_body_description), to: textLabel)
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
        trackUserEvent(.PREVIOUS, action: .TAP)
        delegate?.didTapBack(self)
    }

    @objc func didTapCreate() {
        trackUserEvent(.CREATE_ACCOUNT, action: .TAP)
        delegate?.didTapCreate()
    }
}
