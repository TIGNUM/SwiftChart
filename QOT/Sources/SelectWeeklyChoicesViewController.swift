//
//  SelectWeeklyChoicesViewController.swift
//  QOT
//
//  Created by Lee Arromba on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol SelectWeeklyChoicesViewControllerDelegate: class {
    func dismiss(viewController: SelectWeeklyChoicesViewController)
    func dismiss(viewController: SelectWeeklyChoicesViewController, selectedContent: [WeeklyChoice])
    func didTapRow(_ viewController: SelectWeeklyChoicesViewController,
                   contentCollection: ContentCollection,
                   contentCategory: ContentCategory)
}

final class SelectWeeklyChoicesViewController: UIViewController {

    private struct CellReuseIdentifiers {
        static let CollapsableCell = "CollapsableCell"
        static let CollapsableContentCell = "CollapsableContentCell"
    }

    // MARK: - Properties

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableHeaderView: UIView!
    @IBOutlet weak var tableHeaderViewLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    let viewModel: SelectWeeklyChoicesDataModel
    weak var delegate: SelectWeeklyChoicesViewControllerDelegate?

    // MARK: - Init

    init(delegate: SelectWeeklyChoicesViewControllerDelegate,
         viewModel: SelectWeeklyChoicesDataModel,
         backgroundImage: UIImage? = nil) {
        self.delegate = delegate
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Actions

private extension SelectWeeklyChoicesViewController {
    @IBAction func didPressSave() {
        switch viewModel.selectionType {
        case .weeklyChoices: handleWeeklyChoicesSelection()
        case .prepareStrategies: handlePrepareStrategySelection()
        }
    }

    @IBAction func didPressCancel() {
        delegate?.dismiss(viewController: self)
    }

    func handleWeeklyChoicesSelection() {
        _ = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.main.async { [unowned self] in
            self.viewModel.createUsersWeeklyChoices()
        }
        delegate?.dismiss(viewController: self)
    }

    func handlePrepareStrategySelection() {
        delegate?.dismiss(viewController: self, selectedContent: viewModel.selected)
    }
}

// MARK: - Private

private extension SelectWeeklyChoicesViewController {

    func setupView() {
        view.backgroundColor = .sand
        setupTableView()
        setupButtons()
    }

    func setupTableView() {
        tableView.tableHeaderView = tableHeaderView
        var nib = UINib(nibName: CollapsableCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CellReuseIdentifiers.CollapsableCell)
        nib = UINib(nibName: CollapsableContentCell.nibName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: CellReuseIdentifiers.CollapsableContentCell)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 20.0))

        var header = R.string.localized.meSectorMyWhySelectWeeklyChoicesHeader("\(viewModel.maxSelectionCount)")
        if viewModel.selectionType == .prepareStrategies {
            header = "Add or remove strategies from your preparation list."
        }
        tableHeaderViewLabel.text = header
    }

    func setSelected(_ selected: Int) {
        let maxSelectionCount = viewModel.maxSelectionCount
        saveButton.isEnabled = viewModel.selectionType == .prepareStrategies || selected == maxSelectionCount
    }

    func setupButtons() {
        saveButton.corner(radius: 20)
        cancelButton.corner(radius: 20)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.accent.withAlphaComponent(0.4).cgColor
    }

    func navigationTitle(selected: Int) -> String {
        if viewModel.selectionType == .prepareStrategies {
            return R.string.localized.prepareNavigationTitleAddRemoveStrategies("\(selected)", "\(viewModel.maxSelectionCount)")
        }
        return R.string.localized.meSectorMyWhySelectWeeklyChoicesNavigation("\(viewModel.maxSelectionCount)",
            "\(selected)",
            "\(viewModel.maxSelectionCount)").uppercased()

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

// MARK: - UITableViewDelegate

extension SelectWeeklyChoicesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.isParentNode(atIndexPath: indexPath) {
            return 64//viewModel.rowHeight(forIndexPath: indexPath)
        }
        return 95
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isParentNode(atIndexPath: indexPath) {
            let node = viewModel.node(forSection: indexPath.section)
            viewModel.setIsOpen(!node.isOpen, forNodeAtSection: indexPath.section)
            tableView.reloadDataWithAnimation()
        }
        guard
            let contentCollection = viewModel.contentCollection(forIndexPath: indexPath),
            let contentCategory = viewModel.contentCategory(forIndexPath: indexPath) else {
                return
        }
        delegate?.didTapRow(self, contentCollection: contentCollection, contentCategory: contentCategory)
    }
}

// MARK: - UITableViewDataSource

extension SelectWeeklyChoicesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.isParentNode(atIndexPath: indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.CollapsableCell)
                as? CollapsableCell else { return UITableViewCell() } // shouldnt happen...
            let node = viewModel.node(forSection: indexPath.section)
            cell.setTitleText(node.title,
                              selectionCount: viewModel.numberOfItemsSelected(in: indexPath.section),
                              strategyCount: viewModel.numberOfItems(in: indexPath.section))
            cell.delegate = self
            cell.indexPath = indexPath
            cell.isOpen = node.isOpen
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifiers.CollapsableContentCell)
            as? CollapsableContentCell else { return UITableViewCell() } // shouldnt happen...
        let item = viewModel.item(forIndexPath: indexPath)
        cell.setTitleText(item.title, duration: item.displayTime, isSuggestion: item.isDefault)
        cell.delegate = self
        cell.indexPath = indexPath
        cell.isChecked = item.selected
        return cell
    }
}

// MARK: - CollapsableCellDelegate

extension SelectWeeklyChoicesViewController: CollapsableCellDelegate {

    func collapsableCell(_ cell: CollapsableCell, didPressCollapseButtonForIndexPath indexPath: IndexPath) {
        guard let isOpen = cell.isOpen else { return }
        viewModel.setIsOpen(!isOpen, forNodeAtSection: indexPath.section)
        tableView.reloadDataWithAnimation()
    }
}

// MARK: - CollapsableContentCellDelegate

extension SelectWeeklyChoicesViewController: CollapsableContentCellDelegate {

    func collapsableContentCell(_ cell: CollapsableContentCell, didPressCheckButtonForIndexPath indexPath: IndexPath) {
        var item = viewModel.item(forIndexPath: indexPath)
        if !item.selected && viewModel.selectionType == .weeklyChoices {
            guard viewModel.numOfItemsSelected < viewModel.maxSelectionCount else {
                showMaxSelectionCountAlert()
                return
            }
        }
        item.selected = !item.selected
        viewModel.replace(item, atIndexPath: indexPath)
        setSelected(viewModel.numOfItemsSelected)
        tableView.reloadDataWithAnimation()
    }
}
