//
//  DailyRemindersViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

protocol DailyRemindersViewControllerDelegate: class {
    func collapseCell(_ cell: NotificationSettingCell, didTapCollapseAt indexPath: IndexPath)
    func collapseSetting(_ cell: SettingCell, didTapCollapseAt indexPath: IndexPath)
}

final class DailyRemindersViewController: UIViewController {

    // MARK: - Properties
    var interactor: DailyRemindersInteractorInterface!
    private lazy var router: DailyRemindersRouterInterface = DailyRemindersRouter(viewController: self)
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Init
    init(configure: Configurator<DailyRemindersViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.generateItems()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        ThemeView.level3.apply(tableView)
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .black)
    }
}

// MARK: - Private
private extension DailyRemindersViewController {

    func setupTableView() {
        tableView.registerDequeueable(NotificationSettingCell.self)
        tableView.registerDequeueable(SettingCell.self)
    }

}

// MARK: - UITableViewDelegate
extension DailyRemindersViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if interactor.isParentNode(atIndexPath: indexPath) == true {
            let node = interactor.node(in: indexPath.section)
            interactor.setIsOpen(!node.isOpen, in: indexPath.section)
            reloadTableView()
        } else {
            let item = interactor.item(at: indexPath)
//            delegate?.didTapRow(self, contentId: item.contentId, contentItemId: item.contentItemId)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if interactor.isParentNode(atIndexPath: indexPath) == true {
            let cell: NotificationSettingCell = tableView.dequeueCell(for: indexPath)
            let node = interactor.node(in: indexPath.section)
            cell.configure(title: node.title, subtitle: node.subtitle, isActive: node.isOpen)
            cell.settingDelegate = self
            cell.indexPath = indexPath
            cell.isOpen = node.isOpen
            return cell
        }
        let cell: SettingCell = tableView.dequeueCell(for: indexPath)
        let item = interactor.item(at: indexPath)
        cell.configure(title: item.title, setting: item.settingValue, isExpanded: item.isExpanded, type: item.settingType)
        cell.indexPath = indexPath
        cell.type = item.settingType
        cell.settingDelegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let isParentNode = interactor.isParentNode(atIndexPath: indexPath) == true
        let isChildExpanded = interactor.isExpandedChild(atIndexPath: indexPath) == true
        return isParentNode ? .ParentNode : isChildExpanded ? .ExpandedSetting : .Setting
    }
}

// MARK: - DailyRemindersViewControllerInterface
extension DailyRemindersViewController: DailyRemindersViewControllerInterface {
    func setupView() {
        ThemeView.level3.apply(view)
        baseHeaderView?.configure(title: interactor?.headerTitle, subtitle: nil)
        setupTableView()
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

extension DailyRemindersViewController: DailyRemindersViewControllerDelegate {

    func collapseCell(_ cell: NotificationSettingCell, didTapCollapseAt indexPath: IndexPath) {
        guard let isOpen = cell.isOpen else { return }
        interactor.setIsOpen(!isOpen, in: indexPath.section)
        tableView.reloadData()
    }

    func collapseSetting(_ cell: SettingCell, didTapCollapseAt indexPath: IndexPath) {
        guard let isExpanded = cell.isExpanded else { return }
        interactor.setIsExpanded(!isExpanded, in: indexPath)
        tableView.reloadData()
    }
}
