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
    func didTapClose(in viewController: SettingsMenuViewController)
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
    }
}

