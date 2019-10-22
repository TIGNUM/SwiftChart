//
//  PaymentReminderViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class PaymentReminderViewController: BaseViewController, ScreenZLevel3 {
    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    var interactor: PaymentReminderInteractorInterface?
    private var paymentModel: PaymentModel?

    // MARK: - Init

    init(configure: Configurator<PaymentReminderViewController>) {
        super.init(nibName: R.nib.paymentReminderViewController.name, bundle: R.nib.paymentReminderViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        ThemeView.paymentReminder.apply(self.view)
    }

    // MARK: - Private

    private func setupTableView() {
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 150
        tableView.registerDequeueable(PaymentTableViewCell.self)
        tableView.registerDequeueable(PaymentSwitchAccountTableViewCell.self)
        tableView.registerDequeueable(PaymentFooterView.self)
    }

    private func sendEmail() {
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

// MARK: - PaymentReminderViewControllerInterface

extension PaymentReminderViewController: PaymentReminderViewControllerInterface {
    func setupView() {
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
        if let headerView = R.nib.qotBaseHeaderView.firstView(owner: self) {
            ThemeView.baseHeaderView(.light).apply(headerView)
            headerView.configure(title: paymentModel?.headerTitle,
                                  subtitle: paymentModel?.headerSubtitle,
                                  darkMode: false)
            return headerView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = paymentModel?.paymentItems[indexPath.row]
        switch item?.paymentSection {
        case .switchAccount?:
            let cell: PaymentSwitchAccountTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item?.title, buttonTitle: item?.subtitle)
            cell.delegate = self
            return cell
        case .footer?:
            let cell: PaymentFooterView = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item?.title, buttonTitle: item?.subtitle)
            cell.delegate = self
            return cell
        default:
            let cell: PaymentTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item?.title?.uppercased(), subtitle: item?.subtitle)
            return cell
        }
    }
}

// MARK: Cell custom delegates

extension PaymentReminderViewController: PaymentSwitchAccountTableViewCellDelegate, PaymentFooterViewDelegate {
    func didTapSwitchAccountButton() {
        interactor?.didTapSwitchAccounts()
    }

    func didTapContactButton() {
        sendEmail()
    }
}

// MARK: Bottom Navigation

extension PaymentReminderViewController {
    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return interactor?.showCloseButton ?? true ? [dismissNavigationItem()] : nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
