//
//  MySprintDetailsViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintDetailsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MySprintDetailsInteractorInterface!
    private lazy var router: MySprintDetailsRouterInterface = MySprintDetailsRouter(viewController: self)
    private let tableHeaderView = MySprintDetailsHeaderView.instantiateFromNib()
    @IBOutlet private weak var tableView: UITableView!

    private var infoAlertView: InfoAlertView?
    private var bottomNavigationItems = UINavigationItem()

    // MARK: - Init

    init(configure: Configurator<MySprintDetailsViewController>) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.alwaysBounceVertical = false
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.updateViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.leftBarButtonItems
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.rightBarButtonItems
    }
}

// MARK: - Private

private extension MySprintDetailsViewController {
    private func updateHeader(for tableView: UITableView, with viewModel: MySprintDetailsViewModel) {
        tableHeaderView.set(title: viewModel.title, description: viewModel.description, progress: viewModel.progress)
        tableView.tableHeaderView = tableHeaderView
        NSLayoutConstraint.init(item: tableHeaderView,
                                attribute: .width,
                                relatedBy: .equal,
                                toItem: tableView,
                                attribute: .width,
                                multiplier: 1.0,
                                constant: 0).isActive = true
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
    }

    private func showInfoAlert(_ model: MySprintsInfoAlertViewModel?) {
        guard let model = model else {
            infoAlertView?.dismiss()
            infoAlertView = nil
            return
        }

        if infoAlertView == nil {
            infoAlertView = InfoAlertView()
            infoAlertView?.present(on: self.view)
        }
        infoAlertView?.style = model.style
        infoAlertView?.set(icon: model.icon, title: model.title, attributedText: model.message)
        infoAlertView?.bottomInset = BottomNavigationContainer.height
        infoAlertView?.setBackgroundColor(model.transparent ? .carbon80 : self.view.backgroundColor)
        infoAlertView?.onDismiss = { [weak self] in
            self?.interactor.didDismissAlert()
        }
    }

    private func updateBottomButtons(with viewModel: MySprintDetailsViewModel) {
        bottomNavigationItems.leftBarButtonItems = viewModel.showDismissButton ? [dismissNavigationItem()] : []

        if let buttons = viewModel.rightButtons {
            bottomNavigationItems.rightBarButtonItems = buttons.map {
                let button = RoundedButton(title: $0.title, target: $0.target, action: $0.action)
                if let icon = $0.icon {
                    button.setImage(icon, for: .normal)
                    button.setTitle(" \($0.title)", for: .normal)
                }
                ThemeButton.carbonButton.apply(button)
                return button.barButton
            }
        } else {
            bottomNavigationItems.rightBarButtonItems = []
        }
        refreshBottomNavigationItems()
    }
}

// MARK: - Actions

private extension MySprintDetailsViewController {
    @objc private func itemActionTapped(_ sender: UIButton) {
        guard
            let action = MySprintDetailsItem.Action(rawValue: sender.tag),
            let sprint = interactor.sprint else {
                return
        }

        NotificationCenter.default.post(name: .updateBottomNavigation,
                                        object: BottomNavigationItem(leftBarButtonItems: [],
                                                                     rightBarButtonItems: [],
                                                                     backgroundColor: .clear),
                                        userInfo: nil)
        switch action {
        case .captureTakeaways:
            router.presentTakeawayCapture(for: sprint)
        case .benefits,
             .highlights,
             .strategies:
            router.presentNoteEditing(for: sprint, action: action)
        }
    }
}

// MARK: - MySprintDetailsViewControllerInterface

extension MySprintDetailsViewController: MySprintDetailsViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
    }

    func update() {
        let viewModel = interactor.viewModel
        // Header
        updateHeader(for: tableView, with: viewModel)
        // Alert
        showInfoAlert(viewModel.infoViewModel)
        // Bottom buttons
        updateBottomButtons(with: viewModel)
        tableView.reloadData()
    }

    func trackSprintPause() {
        trackUserEvent(QDMUserEventTracking.Name.PAUSE, action: QDMUserEventTracking.Action.TAP)
    }

    func trackSprintContinue() {
        trackUserEvent(QDMUserEventTracking.Name.CONTINUE, action: QDMUserEventTracking.Action.TAP)
    }

    func trackSprintStart() {
        trackUserEvent(QDMUserEventTracking.Name.START, action: QDMUserEventTracking.Action.TAP)
    }

    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem]) {
        QOTAlert.show(title: title, message: message, bottomItems: buttons)
    }
}

// MARK: - UITableView datasource

extension MySprintDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = interactor.viewModel.items[indexPath.row]
        switch item.type {
        case .header(action: let tag):
            let cell: HeaderDetailsItemCell = tableView.dequeueCell(for: indexPath)
            cell.setText(item.text)
            if let tag = tag {
                cell.setButton(tag: tag.rawValue, target: self, selector: #selector(itemActionTapped(_:)))
            }
            return cell
        case .listItem(appearance: let appearance):
            let cell: ListItemDetailsItemCell = tableView.dequeueCell(for: indexPath)
            cell.setText(text: item.text, appearance: appearance)
            return cell
        case .ctaItem(action: let tag):
            let cell: CtaItemDetailsItemCell = tableView.dequeueCell(for: indexPath)
            cell.setButton(tag: tag.rawValue, title: item.text, target: self, selector: #selector(itemActionTapped(_:)))
            return cell
        }
    }
}
