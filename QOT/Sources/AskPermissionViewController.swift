//
//  AskPermissionViewController.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class AskPermissionViewController: BaseViewController, ScreenZLevel1 {

    // MARK: - Properties
    var interactor: AskPermissionInteractorInterface?
    private var rightBarButtonItems = [UIBarButtonItem]()
    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderview?.addTo(superview: headerView)
        ThemeView.askPermissions.apply(view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: .dark)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        trackPage()
    }

    // MARK: Bottom Navigation
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rightBarButtonItems
    }
}

// MARK: - Private
private extension AskPermissionViewController {
    func cancelButton(_ title: String) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: #selector(didTapCancelButton))
        ThemableButton.askPermissions.apply(button, title: title)
        return button.barButton
    }

    func confirmButton(_ title: String) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: #selector(didTapConfirmButton))
        ThemableButton.askPermissions.apply(button, title: title)
        return button.barButton
    }
}

// MARK: - Actions
private extension AskPermissionViewController {
    @objc func didTapCancelButton() {
        trackUserEvent(.SKIP, valueType: .ASK_PERMISSION_NOTIFICATIONS, action: .TAP)
        interactor?.didTapSkip()
    }

    @objc func didTapConfirmButton() {
        trackUserEvent(.ALLOW, valueType: .ASK_PERMISSION_NOTIFICATIONS, action: .TAP)
        interactor?.didTapConfirm()
    }
}

// MARK: - AskPermissionViewControllerInterface
extension AskPermissionViewController: AskPermissionViewControllerInterface {
    func setupView(_ viewModel: AskPermission.ViewModel) {
        baseHeaderview?.configure(title: viewModel.title, subtitle: viewModel.description)
        ThemeText.askPermissionTitle.apply(viewModel.title, to: baseHeaderview?.titleLabel)
        ThemeText.askPermissionMessage.apply(viewModel.description, to: baseHeaderview?.subtitleTextView)
        headerViewHeightConstraint.constant = baseHeaderview?.calculateHeight(for: self.view.frame.size.width) ?? 0
        imageView.image = interactor?.placeholderImage
        rightBarButtonItems = [confirmButton(viewModel.buttonTitleConfirm ?? " "),
                               cancelButton(viewModel.buttonTitleCancel ?? " ")]
        updateBottomNavigation([], rightBarButtonItems)
    }
}
