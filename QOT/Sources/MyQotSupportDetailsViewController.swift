//
//  MyQotSupportDetailsViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotSupportDetailsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties

    var interactor: MyQotSupportDetailsInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level3.apply(view)
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
    }
}

extension MyQotSupportDetailsViewController: MyQotSupportDetailsViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TitleTableViewCell.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        ThemeText.myQOTSectionHeader.apply(interactor?.headerText, to: headerLabel)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotSupportDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: interactor?.title(at: indexPath) ?? "",
                       bkgdTheme: .level3, titleTheme: .myQOTTitle, arrowHidden: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let contentID = interactor?.item(at: indexPath).remoteID else { return }
        let key = interactor?.trackingID(at: indexPath)
        trackUserEvent(.OPEN, value: key, valueType: .CONTENT_ITEM, action: .TAP)
        interactor?.presentContentItemSettings(contentID: contentID)
    }
}
