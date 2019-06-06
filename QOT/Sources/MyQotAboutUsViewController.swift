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
    @IBOutlet private weak var bottomNavigationView: BottomNavigationBarView!

    var interactor: MyQotAboutUsInteractorInterface?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = .carbon
        bottomNavigationView.delegate = self
        headerLabel.text = title
        setUpTableView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotAboutUsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.config = TitleSubtitleTableViewCell.Config()
        let title =  interactor?.title(at: indexPath) ?? ""
        let subtitle = interactor?.subtitle(at: indexPath) ?? ""
        cell.configure(title: title, subTitle: subtitle)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = interactor?.trackingKeys(at: indexPath)
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        interactor?.handleSelection(for: indexPath)
    }
}

extension MyQotAboutUsViewController: BottomNavigationBarViewProtocol {
    func willNavigateBack() {
        trackUserEvent(.CLOSE, action: .TAP)
        navigationController?.popViewController(animated: true)
    }
}
