//
//  ChoiceViewController.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol ChoiceViewControllerDelegate: class {
    func dismiss(_ viewController: UIViewController)
    func dismiss(_ viewController: UIViewController, selections: [Choice])
    func didTapRow(_ viewController: UIViewController, contentId: Int)
}

final class ChoiceViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableHeaderView: UIView!
    @IBOutlet private weak var tableHeaderViewLabel: UILabel!
    var interactor: ChoiceInteractorInterface?
    weak var delegate: ChoiceViewControllerDelegate?

    // MARK: - Init
    init(configure: Configurator<ChoiceViewController>) {
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Private
private extension ChoiceViewController {
    func setupTableView() {
        tableView.registerDequeueable(CollapsableCell.self)
        tableView.registerDequeueable(CollapsableContentCell.self)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: .Footer))
        tableView.tableHeaderView = tableHeaderView
        tableHeaderViewLabel.text = AppTextService.get(AppTextKey.my_qot_my_plans_view_title)
    }

    func navigationTitle(selected: Int) -> String {
        let max = interactor?.maxSelectionCount ?? 0
        return String(format: AppTextService.get(AppTextKey.prepare_choice_view_title), selected, max)
    }
}

// MARK: - Actions
private extension ChoiceViewController {
    @objc func didTapSave() {
        delegate?.dismiss(self, selections: interactor?.selected ?? [])
    }

    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension ChoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor?.isParentNode(atIndexPath: indexPath) == true ? .ParentNode : .ChildNode
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if interactor?.isParentNode(atIndexPath: indexPath) == true {
            guard let node = interactor?.node(in: indexPath.section) else { return }
            interactor?.setIsOpen(!node.isOpen, in: indexPath.section)
            tableView.reloadDataWithAnimation()
        } else if let readMoreId = interactor?.item(at: indexPath).contentId {
            delegate?.didTapRow(self, contentId: readMoreId)
        }
    }
}

// MARK: - UITableViewDataSource
extension ChoiceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.sectionCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.numberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if interactor?.isParentNode(atIndexPath: indexPath) == true {
            let cell: CollapsableCell = tableView.dequeueCell(for: indexPath)
            let node = interactor?.node(in: indexPath.section)
            cell.setTitleText(node?.title,
                              selectionCount: interactor?.selectedCount(in: indexPath.section) ?? 0,
                              strategyCount: interactor?.numberOfItems(in: indexPath.section) ?? 0)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isOpen = node?.isOpen
            return cell
        }
        let cell: CollapsableContentCell = tableView.dequeueCell(for: indexPath)
        guard let item = interactor?.item(at: indexPath) else { return cell }
        cell.setTitleText(item.title, duration: item.readingTime, isSuggestion: item.isDefault)
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isChecked = item.selected
        return cell
    }
}

// MARK: - ChoiceViewControllerInterface
extension ChoiceViewController: ChoiceViewControllerInterface {
    func setupView() {
        view.backgroundColor = .sand
        setupTableView()
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - CollapsableContentCellDelegate
extension ChoiceViewController: CollapsableContentCellDelegate {
    func collapsableContentCell(_ cell: CollapsableContentCell, didTapCheckAt indexPath: IndexPath) {
        guard var item = interactor?.item(at: indexPath) else { return }
        if item.selected == false && interactor?.choiceType == .CHOICE {
            guard interactor?.selectedCount ?? 0 < interactor?.maxSelectionCount ?? 0 else {
                return
            }
        }
        item.selected = !item.selected
        interactor?.replace(item, at: indexPath)
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - CollapsableCellDelegate
extension ChoiceViewController: CollapsableCellDelegate {
    func collapsableCell(_ cell: CollapsableCell, didTapCollapseAt indexPath: IndexPath) {
        guard let isOpen = cell.isOpen else { return }
        interactor?.setIsOpen(!isOpen, in: indexPath.section)
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - BottomBarNavigation
extension ChoiceViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [saveChangesButtonItem(#selector(didTapSave)), cancelButtonItem(#selector(didTapCancel))]
    }
}
