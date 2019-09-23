//
//  MyQotSupportViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import MessageUI
import qot_dal

final class MyQotSupportViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties

    @IBOutlet private weak var headerLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    var interactor: MyQotSupportInteractorInterface?

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let myQotSupportFaq  = segue.destination as? MyQotSupportFaqViewController else {
            return
        }
        MyQotSupportFaqConfigurator.configure(viewController: myQotSupportFaq)
    }
}

extension MyQotSupportViewController: MyQotSupportViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
        ThemeText.myQOTSectionHeader.apply((interactor?.supportText ?? "").uppercased(), to: headerLabel)
        setUpTableView()
    }

    func setUpTableView() {
        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(TitleSubtitleTableViewCell.self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyQotSupportViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.itemCount() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TitleSubtitleTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: interactor?.title(at: indexPath) ?? "", themeCell: .level3)
        cell.configure(subTitle: interactor?.subtitle(at: indexPath) ?? "")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = interactor?.trackingKeys(at: indexPath)
        trackUserEvent(.OPEN, valueType: key, action: .TAP)
        interactor?.handleSelection(for: indexPath)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension MyQotSupportViewController {

    override func mailComposeController(_ controller: MFMailComposeViewController,
                                        didFinishWith result: MFMailComposeResult,
                                        error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        if let error = error {
            showAlert(type: .message(error.localizedDescription))
            log("Failed to open mail with error: \(error.localizedDescription))", level: .error)
        }
    }
}
