//
//  SupportFAQViewController.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SupportFAQViewController: UIViewController {

    // MARK: - Properties

    var interactor: SupportFAQInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init

    init(configure: Configurator<SupportFAQViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - SupportFAQViewControllerInterface

extension SupportFAQViewController: SupportFAQViewControllerInterface {

    func setupView() {
        tableView.registerDequeueable(SupportFAQTableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = Layout.height_44
        title = R.string.localized.sidebarTitleFAQ()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SupportFAQViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SupportFAQTableViewCell = tableView.dequeueCell(for: indexPath)
        let title = interactor?.title(at: indexPath)
        cell.configure(title: title)
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let contentID = interactor?.item(at: indexPath).remoteID.value else { return }
        AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: contentID,
                                                                      controller: self)
    }
}
