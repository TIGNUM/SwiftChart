//
//  ChoiceViewController.swift
//  QOT
//
//  Created by karmic on 21.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

protocol ChoiceViewControllerDelegate: class {
    func dismiss(_ viewController: UIViewController)
    func dismiss(_ viewController: UIViewController, selections: [Choice])
    func didTapRow(_ viewController: UIViewController, contentId: Int)
}

final class ChoiceViewController: UIViewController {

    // MARK: - Properties

    private struct CellReuseIdentifiers {
        static let CollapsableCell = "CollapsableCell"
        static let CollapsableContentCell = "CollapsableContentCell"
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableHeaderView: UIView!
    @IBOutlet private weak var tableHeaderViewLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
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
}

// MARK: - Private

private extension ChoiceViewController {
    func setupTableView() {
        tableView.tableHeaderView = tableHeaderView
        var nib = UINib(nibName: CollapsableCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CellReuseIdentifiers.CollapsableCell)
        nib = UINib(nibName: CollapsableContentCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CellReuseIdentifiers.CollapsableContentCell)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
        tableHeaderViewLabel.text = R.string.localized.choiceViewHeaderEditPrepare()
    }

    func setupButtons() {
        saveButton.cornerDefault()
        cancelButton.cornerDefault()
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.accent.withAlphaComponent(0.4).cgColor
    }

    func navigationTitle(selected: Int) -> String {
        return R.string.localized.prepareNavigationTitleAddRemoveStrategies("\(selected)", "\(interactor?.maxSelectionCount ?? 0)")
    }

    func showMaxSelectionCountAlert() {
        let alert = UIAlertController(
            title: R.string.localized.meSectorMyWhySelectWeeklyChoicesMaxChoiceAlertTitle(),
            message: R.string.localized.meSectorMyWhySelectWeeklyChoicesMaxChoiceAlertMessage(),
            preferredStyle: .alert)
        alert.addAction (
            UIAlertAction(
                title: R.string.localized.meSectorMyWhySelectWeeklyChoicesMaxChoiceAlertButton(),
                style: .default,
                handler: nil)
        )
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Actions

private extension ChoiceViewController {
    @IBAction func didPressSave() {
        delegate?.dismiss(self, selections: interactor?.selected ?? [])
    }

    @IBAction func didPressCancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension ChoiceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor?.isParentNode(atIndexPath: indexPath) == true ? 64 : 95
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.CollapsableCell)
                as? CollapsableCell else { preconditionFailure("CollapsableCell is nil") }
            let node = interactor?.node(in: indexPath.section)
            cell.setTitleText(node?.title,
                              selectionCount: interactor?.selectedCount(in: indexPath.section) ?? 0,
                              strategyCount: interactor?.numberOfItems(in: indexPath.section) ?? 0)
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isOpen = node?.isOpen
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.CollapsableContentCell)
            as? CollapsableContentCell else { preconditionFailure("CollapsableContentCell is nil") }
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
        setupButtons()
    }

    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - CollapsableContentCellDelegate

extension ChoiceViewController: CollapsableContentCellDelegate {
    func setSelected(_ selected: Int) {
        let maxSelectionCount = interactor?.maxSelectionCount
        saveButton.isEnabled = interactor?.choiceType == .CHOICE || selected == maxSelectionCount
    }

    func collapsableContentCell(_ cell: CollapsableContentCell, didPressCheckButtonForIndexPath indexPath: IndexPath) {
        guard var item = interactor?.item(at: indexPath) else { return }
        if item.selected == false && interactor?.choiceType == .CHOICE {
            guard interactor?.selectedCount ?? 0 < interactor?.maxSelectionCount ?? 0 else {
                showMaxSelectionCountAlert()
                return
            }
        }
        item.selected = !item.selected
        interactor?.replace(item, at: indexPath)
        setSelected(interactor?.selectedCount ?? 0)
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - CollapsableCellDelegate

extension ChoiceViewController: CollapsableCellDelegate {
    func collapsableCell(_ cell: CollapsableCell, didPressCollapseButtonForIndexPath indexPath: IndexPath) {
        guard let isOpen = cell.isOpen else { return }
        interactor?.setIsOpen(!isOpen, in: indexPath.section)
        tableView.reloadDataWithAnimation()
    }
}
