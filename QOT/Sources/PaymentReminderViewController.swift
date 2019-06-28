//
//  PaymentReminderViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class PaymentReminderViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
//    @IBOutlet private weak var switchAccountButton: UIButton!
    private var paymentModel: PaymentModel?
    @IBOutlet private weak var signInLabel: UILabel!
    @IBOutlet private weak var switchAccountsButton: UIButton!
    private enum CellType: Int, CaseIterable {
        case header = 0
        case sections
    }
    @IBOutlet private weak var contactButton: UIButton!
    var interactor: PaymentReminderInteractorInterface?
    @IBAction func switchAccounts(_ sender: Any) {
         interactor?.didTapSwitchAccounts()
    }

    // MARK: - Init

    init(configure: Configurator<PaymentReminderViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contactButton.corner(radius: 20)
        interactor?.viewDidLoad()
    }

    @IBAction func didTapContact(_ sender: Any) {
        sendEmail()
    }

    @IBAction func didClose(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

extension PaymentReminderViewController {

    func setupButtons() {
        switchAccountsButton.isHidden = interactor?.showSwitchAccountButton == false
        signInLabel.isHidden = interactor?.showSwitchAccountButton == false
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@qot.io"])
            mail.setMessageBody("<p>About my Qot Membership</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            print("not sending email")
        }
    }

    override func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Actions

private extension PaymentReminderViewController {
//    @IBAction func close() {
//        interactor?.didTapMinimiseButton()
//    }

    @IBAction func switchAccount() {
        interactor?.didTapSwitchAccounts()
    }

    func setupTableView() {
        tableView.registerDequeueable(PaymentTableViewCell.self)
    }
}

// MARK: - PaymentReminderViewControllerInterface

extension PaymentReminderViewController: PaymentReminderViewControllerInterface {
    func setupView() {
//        setupButtons()
        setupTableView()
    }

    func setup(for paymentSection: PaymentModel) {
        paymentModel = paymentSection
    }
}

extension PaymentReminderViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentModel?.paymentItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellType = CellType.allCases[section]
        switch cellType {
        case .header:
            return PaymentHeaderView.instantiateFromNib(title: paymentModel?.headerTitle ?? "",
                                                           subtitle: paymentModel?.headerSubtitle ?? "")
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PaymentTableViewCell = tableView.dequeueCell(for: indexPath)
        let item = paymentModel?.paymentItems[indexPath.row]
        cell.configure(title: item?.title ?? "", subtitle: item?.subtitle ?? "")
        cell.backgroundColor = .sand
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
