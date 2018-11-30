//
//  PermissionsViewController.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol PermissionsViewControllerDelegate: class {
    func didTapSwitch(at indexPath: IndexPath, settingsCell: PermissionsCell)
}

final class PermissionsViewController: UIViewController {

    var interactor: PermissionsInteractorInterface?
    private var tableView = UITableView()
    private var permissions: [Permission] = []

    // MARK: - Init

    init(configure: Configurator<PermissionsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerDequeueable(PermissionsCell.self)
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: .UIApplicationDidBecomeActive, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        interactor?.updatePermissions()
    }

    func permissionIndexPath(for permission: PermissionsManager.Permission.Identifier) -> IndexPath? {
        guard let row = permissions.index(where: { $0.identifier == permission }) else { return nil }
        return IndexPath(row: row, section: 0)
    }
}

// MARK: - Private

private extension PermissionsViewController {

    @objc func reload() {
        interactor?.updatePermissions()
    }

    func setupView() {
        view.addSubview(tableView)
        setCustomBackButton()
        navigationItem.title = R.string.localized.sidebarTitlePermission().uppercased()
        tableView.backgroundColor = .navy
        tableView.separatorColor = .clear
        tableView.isScrollEnabled = false
        tableView.topAnchor == view.safeTopAnchor + Layout.padding_20
        tableView.bottomAnchor == view.safeBottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        view.layoutIfNeeded()
    }
}

extension PermissionsViewController: PermissionsViewControllerInterface {

    func setup(_ permissions: [Permission]) {
        self.permissions = permissions
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PermissionsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return permissions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PermissionsCell = tableView.dequeueCell(for: indexPath)
        cell.delegate = self
        cell.configure(identifier: permissions[indexPath.row].identifier,
                       isOn: permissions[indexPath.row].activated == .granted ? true : false)
        return cell
    }
}

// MARK: - PermissionsCellDelegate

extension PermissionsViewController: PermissionsCellDelegate {

    func switchDidChange(in permission: PermissionsManager.Permission.Identifier) {
        interactor?.didTapPermission(permission: permission)
    }

    func didCancelSwitch(at indexPath: IndexPath) {
        guard let cell: PermissionsCell = tableView.cellForRow(at: indexPath) as? PermissionsCell else { return }
        cell.backToPreviousState()
    }
}
