//
//  MyQotAboutUsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAboutUsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    var interactor: MyQotAboutUsInteractorInterface?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .carbon
        setUpTableView()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = .carbon
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    private func setUpTableView() {
        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
    }
}

extension MyQotAboutUsViewController: MyQotAboutUsViewControllerInterface {
    func setupView(with title: String) {
        headerLabel.text = title
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotAboutUsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        interactor?.title(at: indexPath, { (text) in
            cell.configure(title: text)
        })
        interactor?.subtitle(at: indexPath, { (text) in
            cell.configure(subTitle: text, isHidden: true)
        })
        cell.hideArrow = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = interactor?.trackingKeys(at: indexPath)
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        interactor?.handleSelection(for: indexPath)
    }
}
