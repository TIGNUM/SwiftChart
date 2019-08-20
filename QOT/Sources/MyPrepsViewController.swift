//
//  MyPrepsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyPrepsNavigationController.classForCoder())
}

final class MyPrepsViewController: UIViewController, ScreenZLevel2 {

    enum SegmentView: Int {
        case myPreps = 0
        case mindsetShifter
        case recovery
    }

    // MARK: - Properties

    var interactor: MyPrepsInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerTitle: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var noPreparationsView: UIView!
    @IBOutlet private weak var noRecoveriesView: UIView!
    @IBOutlet private weak var noMIndsetShiftersView: UIView!
    @IBOutlet private weak var confirmDeleteView: UIView!
    @IBOutlet private weak var cancelDeleteButton: UIButton!
    private var editPressed: Bool = false
    @IBOutlet private weak var confirmDeleteButton: UIButton!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.isHidden = true
        removeButton.isHidden = true
        tableView.allowsMultipleSelectionDuringEditing = true
        editButton.corner(radius: editButton.bounds.size.width/2, borderColor: .accent)
        confirmDeleteView.isHidden = true
        self.tableView.tableFooterView = UIView()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noPreparationsView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        tableView.reloadData()
        trackPage()
    }

    // MARK: - Actions

    @IBAction func didChangeSegment(_ sender: Any) {
        tableView.reloadData()
    }

    @IBAction func cancelButton(_ sender: Any) {
        refreshBottomNavigationItems()
        editPressed = false
        segmentedControl.isHidden = false
        tableView.setEditing(false, animated: true)
        tableView.reloadData()
    }

    @IBAction func editButton(_ sender: Any) {
        if noPreparationsView.isHidden == true {
            refreshBottomNavigationItems()
            segmentedControl.isHidden = !editPressed
            tableView.setEditing(!editPressed, animated: true)
            tableView.reloadData()
            editPressed = !editPressed
        }
    }

    @IBAction func confirmDeleteButton(_ sender: Any) {
        hideAllViews()
        if let selectedRows = tableView.indexPathsForSelectedRows {
        let sortedArray = selectedRows.sorted { $1.row < $0.row }
            for indexPath in sortedArray {
                interactor?.remove(segmentedControl: segmentedControl.selectedSegmentIndex, at: indexPath)
            }
            showEmptyStateViewIfNeeded(segmentedControl)
        }
        refreshBottomNavigationItems()
        updateControls()
        showEmptyStateViewIfNeeded(segmentedControl)
    }

    @IBAction func cancelDeleteButton(_ sender: Any) {
        updateControls()
    }

    @IBAction func removeRows(_ sender: Any) {
        if tableView.indexPathForSelectedRow != nil {
            confirmDeleteView.isHidden = false
            refreshBottomNavigationItems()
        }
    }

    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        hideAllViews()
        showEmptyStateViewIfNeeded(sender)
    }
}

// MARK: - Private
private extension MyPrepsViewController {
    func updateControls() {
        refreshBottomNavigationItems()
        confirmDeleteView.isHidden = true
        segmentedControl.isHidden = false
        tableView.setEditing(false, animated: true)
        tableView.reloadData()
        editPressed = false
    }

    func showEmptyStateViewIfNeeded(_ sender: UISegmentedControl) {
        updateEditButton(hidden: false)
        switch sender.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            if interactor?.numberOfRowsPreparations(in: 0) == Optional(0) {
                noPreparationsView.isHidden = false
                updateEditButton(hidden: true)
            }
        case SegmentView.mindsetShifter.rawValue:
            if interactor?.numberOfRowsMindsetShifters(in: 0) == Optional(0) {
                noMIndsetShiftersView.isHidden = false
                updateEditButton(hidden: true)
            }
        case SegmentView.recovery.rawValue:
            if interactor?.numberOfRowsRecoveries(in: 0) == Optional(0) {
                noRecoveriesView.isHidden = false
                updateEditButton(hidden: true)
            }
        default:
            return
        }
    }

    func setupTableView() {
        tableView.registerDequeueable(MyPrepsTableViewCell.self)
        tableView.reloadData()
    }

    func updateEditButton(hidden: Bool) {
        editButton.isHidden = hidden
    }

    func hideAllViews() {
        noPreparationsView.isHidden = true
        noRecoveriesView.isHidden = true
        noMIndsetShiftersView.isHidden = true
    }
}

// MARK: - Actions
private extension MyPrepsViewController {
    func setupSegementedControl() {
        segmentedControl.tintColor = .clear
        segmentedControl.backgroundColor = .clear
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.apercuRegular(ofSize: 14),
                                                 NSAttributedStringKey.foregroundColor: UIColor.accent.withAlphaComponent(0.4)],
                                                for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.apercuRegular(ofSize: 14),
                                                 NSAttributedStringKey.foregroundColor: UIColor.sand],
                                                for: .selected)
    }
}

// MARK: - MyPrepsViewControllerInterface
extension MyPrepsViewController: MyPrepsViewControllerInterface {
    func updateView() {
        tableView.reloadData()
        showEmptyStateViewIfNeeded(segmentedControl)
    }

    func setupView() {
        view.backgroundColor = .carbon
        headerTitle.text = R.string.localized.myQotHeaderTitle()
        setupTableView()
        hideAllViews()
        tableView.reloadData()
        setupSegementedControl()
        showEmptyStateViewIfNeeded(segmentedControl)
    }
}

extension MyPrepsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            return interactor?.numberOfRowsPreparations(in: section) ?? 0
        case SegmentView.mindsetShifter.rawValue:
            return interactor?.numberOfRowsMindsetShifters(in: section) ?? 0
        case SegmentView.recovery.rawValue:
            return interactor?.numberOfRowsRecoveries(in: section) ?? 0
        default:
            return 0
        }
    }

    private func tableView(tableView: UITableView,
                           editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.init(rawValue: 3)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPrepsTableViewCell = tableView.dequeueCell(for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.carbon
        cell.selectedBackgroundView = backgroundView
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        cell.backgroundColor = .carbon
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            let item = interactor?.itemPrep(at: indexPath)
            cell.configure(title: item?.title ?? "", subtitle: (item?.date ?? "") + " | " + (item?.eventType ?? ""))
        case SegmentView.mindsetShifter.rawValue:
            let item = interactor?.itemMind(at: indexPath)
            cell.configure(title: item?.title ?? "", subtitle: item?.date ?? "")
        case SegmentView.recovery.rawValue:
            let item = interactor?.itemRec(at: indexPath)
            cell.configure(title: item?.title ?? "", subtitle: item?.date ?? "")
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if let item = interactor?.itemPrep(at: indexPath), tableView.isEditing == false {
                interactor?.presentPreparation(item: item.qdmPrep, viewController: self)
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return
        } else if segmentedControl.selectedSegmentIndex == 2 {
            return
        }
    }
}

extension MyPrepsViewController {

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if confirmDeleteView.isHidden == false {
            return [roundedBarBurtonItem(title: R.string.localized.buttonTitleYesContinue(), action: #selector(confirmDeleteButton(_:))),
                    roundedBarBurtonItem(title: R.string.localized.buttonTitleCancel(), action: #selector(cancelDeleteButton(_:)))]
        } else if editPressed == true {
            return [roundedBarBurtonItem(title: R.string.localized.buttonTitleRemove(), action: #selector(removeRows(_:))),
                    roundedBarBurtonItem(title: R.string.localized.buttonTitleCancel(), action: #selector(cancelButton(_:)))]
        } else { return [] }
    }

    @objc public func roundedBarBurtonItem(title: String, action: Selector) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: action)
        let item = UIBarButtonItem(customView: button)
        item.tintColor = colorMode.tint
        return item
    }
}
