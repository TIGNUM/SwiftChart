//
//  SiriShortcutsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class SiriShortcutsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    private var siriShortcutsModel: SiriShortcutsModel
    var interactor: SiriShortcutsInteractorInterface?

     // MARK: - Init

    init(configure: Configurator<SiriShortcutsViewController>, services: Services) {
        siriShortcutsModel = SiriShortcutsModel(services: services)
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent)
        navigationItem.title = R.string.localized.settingsSiriShortcutsTitle()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        tableView.registerDequeueable(SiriShortcutsCell.self)
        setCustomBackButton()
    }
}

 // MARK: - SiriShortcutsViewControllerInterface

extension SiriShortcutsViewController: SiriShortcutsViewControllerInterface {

    func setup(for shortcut: SiriShortcutsModel) {
        view.backgroundColor = .navy
        siriShortcutsModel = shortcut
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SiriShortcutsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siriShortcutsModel.itemCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SiriShortcutsCell = tableView.dequeueCell(for: indexPath)
        let model = siriShortcutsModel.shortcutItem(at: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.configure(title: model.title)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let shortcutTapped = siriShortcutsModel.shortcutItem(at: indexPath)
        interactor?.handleTap(for: shortcutTapped)
    }
}
