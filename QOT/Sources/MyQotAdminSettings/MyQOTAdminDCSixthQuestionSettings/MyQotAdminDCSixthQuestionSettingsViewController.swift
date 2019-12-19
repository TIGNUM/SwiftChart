//
//  MyQotAdminDCSixthQuestionSettingsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 16/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyQotAdminDCSixthQuestionSettingsViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?

    var interactor: MyQotAdminDCSixthQuestionSettingsInteractorInterface!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        MyQotAdminDCSixthQuestionSettingsConfigurator.configure(viewController: self)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        MyQotAdminDCSixthQuestionSettingsInteractor.getSixthQuestionPriority { [weak self] (setting) in
            self?.interactor.setCurrentSetting(setting: setting)
            self?.tableView.reloadData()
        }
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
    }
}
    // MARK: - Private
private extension MyQotAdminDCSixthQuestionSettingsViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: interactor.getHeaderTitle(),
                                  subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}
    // MARK: - TableView Delegate and Datasource

extension MyQotAdminDCSixthQuestionSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.getDatasourceCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        let isSelected = interactor.isSelected(at: indexPath.row)
        let checkMark = R.image.registration_checkmark()

        cell.configure(title: interactor.getTitle(for: indexPath.row),
                       subtitle: nil)
        cell.customAccessoryImageView.image = isSelected ? checkMark : nil

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        interactor.selectPriority(at: indexPath.row, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}

// MARK: - MyQotAdminDCSixthQuestionSettingsViewControllerInterface
extension MyQotAdminDCSixthQuestionSettingsViewController: MyQotAdminDCSixthQuestionSettingsViewControllerInterface {
    func setupView() {
        // Do any additional setup after loading the view.
    }
}
