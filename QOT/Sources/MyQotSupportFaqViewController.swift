//
//  MyQotSupportFaqViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotSupportFaqViewController: UIViewController {

    // MARK: - Properties

    var interactor: MyQotSupportFaqInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

extension MyQotSupportFaqViewController: MyQotSupportFaqViewControllerInterface {
    func setupView() {
        view.backgroundColor = .carbon
        tableView.registerDequeueable(TitleTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        interactor?.faqHeaderText({[weak self] (text) in
            self?.headerLabel.text = text
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotSupportFaqViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.config = TitleTableViewCell.Config(backgroundColor: .carbon, isArrowHidden: true)
        cell.title = interactor?.title(at: indexPath) ?? ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let contentID = interactor?.item(at: indexPath).remoteID else { return }
        let key = interactor?.trackingID(at: indexPath)
        trackUserEvent(.OPEN, value: key, valueType: .CONTENT_ITEM, action: .TAP)
        interactor?.faqHeaderText({[weak self] (text) in
            self?.interactor?.presentContentItemSettings(contentID: contentID, pageName: .faq, pageTitle: text)
        })
    }
}
