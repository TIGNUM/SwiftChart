//
//  SettingsMenuViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 13/04/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

protocol SettingsMenuViewControllerDelegate: class {
    func didTapGeneral(in viewController: SettingsMenuViewController)
    func didTapNotifications(in viewController: SettingsMenuViewController)
    func didTapSecurity(in viewController: SettingsMenuViewController)
}

final class SettingsMenuViewController: UIViewController {

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: SettingsMenuViewModel
    weak var delegate: SettingsMenuViewControllerDelegate?

    init(viewModel: SettingsMenuViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        settingsButtons().forEach { (button: UIButton) in
            view.addSubview(button)
            print(button)
        }
    }

    // TODO: Please remove, just for testing.

    private func settingsButtons() -> [UIButton] {
        let genralButton = UIButton()
        genralButton.setTitle("GENERAL", for: .normal)
        genralButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        genralButton.frame = CGRect(x: 100, y: 100, width: 0, height: 0)
        genralButton.sizeToFit()

        let notificationsButton = UIButton()
        notificationsButton.setTitle("NOTIFICATIONS", for: .normal)
        notificationsButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        notificationsButton.frame = CGRect(x: 100, y: 200, width: 0, height: 0)
        notificationsButton.sizeToFit()

        let securityButton = UIButton()
        securityButton.setTitle("SECURITY", for: .normal)
        securityButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        securityButton.frame = CGRect(x: 100, y: 300, width: 0, height: 0)
        securityButton.sizeToFit()

        return [genralButton, notificationsButton, securityButton]
    }

    func didTapSettingButton(sender: UIButton) {
        switch sender.titleLabel?.text ?? String() {
            case "GENERAL": delegate?.didTapGeneral(in: self)
            case "NOTIFICATIONS": delegate?.didTapSecurity(in: self)
            case "SECURITY": delegate?.didTapNotifications(in: self)
            default: return
        }
    }
}

// MARK: - TopTabBarItem

extension SettingsMenuViewController: TopTabBarItem {

    var topTabBarItem: TopTabBarController.Item {
        return TopTabBarController.Item(controller: self, title: R.string.localized.settingsTitle())
    }
}
