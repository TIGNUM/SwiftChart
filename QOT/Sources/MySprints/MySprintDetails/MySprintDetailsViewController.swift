//
//  MySprintDetailsViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintDetailsViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MySprintDetailsInteractorInterface?
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.alwaysBounceVertical = false
        interactor?.viewDidLoad()

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
        tableHeaderView.widthAnchor.constraint(equalToConstant: tableView.bounds.size.width).isActive = true
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
            self?.interactor?.didDismissAlert()
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
                return UIBarButtonItem(customView: button)
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
        interactor?.didTapItemAction(sender.tag)
    }
}

// MARK: - MySprintDetailsViewControllerInterface

extension MySprintDetailsViewController: MySprintDetailsViewControllerInterface {
    func update() {
        guard let viewModel = interactor?.viewModel else {
            return
        }
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
        interactor?.didTapItemAction(1)
    }

    func trackSprintContinue() {
        trackUserEvent(QDMUserEventTracking.Name.CONTINUE, action: QDMUserEventTracking.Action.TAP)
        interactor?.didTapItemAction(2)
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
        return interactor?.viewModel.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.viewModel.items[indexPath.row] else {
            return UITableViewCell()
        }

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
            cell.setText(item.text)
            cell.setAppearance(appearance)
            return cell
        case .ctaItem(action: let tag):
            let cell: CtaItemDetailsItemCell = tableView.dequeueCell(for: indexPath)
            cell.setButton(tag: tag.rawValue, title: item.text, target: self, selector: #selector(itemActionTapped(_:)))
            return cell
        }
    }
}
