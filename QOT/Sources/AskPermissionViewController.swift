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
    var interactor: AskPermissionInteractorInterface!
    private lazy var router = AskPermissionRouter(viewController: self, delegate: delegate)
    private var rightBarButtonItems = [UIBarButtonItem]()
    private var leftBarButtonItems = [UIBarButtonItem]()
    private var baseHeaderView: QOTBaseHeaderView?
    weak var delegate: AskPermissionDelegate?
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
        interactor.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
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
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return leftBarButtonItems
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rightBarButtonItems
    }
}

// MARK: - Private
private extension AskPermissionViewController {
    func cancelButton(_ title: String) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: #selector(didTapCancelButton))
        ThemableButton.darkButton.apply(button, title: title)
        return button.barButton
    }

    func confirmButton(_ title: String) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: #selector(didTapConfirmButton))
        ThemableButton.darkButton.apply(button, title: title)
        return button.barButton
    }

    func setupBottomNavigation(_ viewModel: AskPermission.ViewModel) {
        rightBarButtonItems = [confirmButton(viewModel.buttonTitleConfirm ?? " ")]

        switch interactor.getPermissionType {
        case .calendar,
             .calendarOpenSettings: leftBarButtonItems = [dismissNavigationItem(action: #selector(didTapCancelButton))]
        default: rightBarButtonItems.append(cancelButton(viewModel.buttonTitleCancel ?? String.empty))
        }

        updateBottomNavigation(leftBarButtonItems, rightBarButtonItems)
    }
}

// MARK: - Actions
private extension AskPermissionViewController {
    @objc func didTapCancelButton() {
        trackUserEvent(.SKIP, valueType: .ASK_PERMISSION_NOTIFICATIONS, action: .TAP)
        router.didTapDismiss(interactor.getPermissionType)
    }

    @objc func didTapConfirmButton() {
        trackUserEvent(.ALLOW, valueType: .ASK_PERMISSION_NOTIFICATIONS, action: .TAP)
        router.didTapConfirm(interactor.getPermissionType)
    }
}

// MARK: - AskPermissionViewControllerInterface
extension AskPermissionViewController: AskPermissionViewControllerInterface {
    func setupView(_ viewModel: AskPermission.ViewModel) {
        baseHeaderView?.configure(title: viewModel.title, subtitle: viewModel.description)
        ThemeText.askPermissionTitle.apply(viewModel.title, to: baseHeaderView?.titleLabel)
        ThemeText.askPermissionMessage.apply(viewModel.description, to: baseHeaderView?.subtitleTextView)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.view.frame.size.width) ?? .zero
        imageView.image = interactor.placeholderImage
        setupBottomNavigation(viewModel)
    }
}
