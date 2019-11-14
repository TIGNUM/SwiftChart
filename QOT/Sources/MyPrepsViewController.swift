//
//  MyPrepsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyPrepsNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyPrepsNavigationController.classForCoder())
}

protocol MyPrepsViewControllerDelegate: class {
     func confirmDeleteButton(_ sender: Any)
}

final class MyPrepsViewController: BaseViewController, ScreenZLevel2 {

    enum SegmentView: Int {
        case myPreps = 0
        case mindsetShifter
        case recovery
    }

    // MARK: - Properties

    var interactor: MyPrepsInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var noPreparationsView: UIView!
    @IBOutlet private weak var noRecoveriesView: UIView!
    @IBOutlet private weak var noMIndsetShiftersView: UIView!
    private var editPressed: Bool = false

    @IBOutlet weak var noPrepsTitle: UILabel!
    @IBOutlet weak var noPrepsComment: UILabel!
    @IBOutlet weak var noMindsetTitle: UILabel!
    @IBOutlet weak var noMindsetComment: UILabel!
    @IBOutlet weak var noRecoveryTitle: UILabel!
    @IBOutlet weak var noRecoveryComment: UILabel!
    @IBOutlet private weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorView: UIView!

    lazy var cancelButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(cancelButton(_:)))
        ThemableButton.myPlans.apply(button, title: AppTextService.get(AppTextKey.generic_view_button_cancel))
        return button.barButton
    }()

    lazy var deleteButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(removeRows(_:)))
        ThemableButton.myPlans.apply(button, title: AppTextService.get(AppTextKey.generic_view_button_delete))
        return button.barButton
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        editButton.corner(radius: editButton.bounds.size.width/2, borderColor: .accent)
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        setupView()
        updateIndicator()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAllNoDataViews()
        updateIndicator()
        refreshBottomNavigationItems()
        interactor?.fetchItemsAndUpdateView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    // MARK: - Actions

    @IBAction func didChangeSegment(_ sender: Any) {
        tableView.reloadData()
        updateIndicator()
        trackUserEvent(.OPEN, value: segmentedControl.selectedSegmentIndex, valueType: .MY_PLANS_SEGMENT_CHANGE, action: .TAP)
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
            indicatorView.isHidden = !editPressed
            segmentedControl.isHidden = !editPressed
            tableView.setEditing(!editPressed, animated: true)
            tableView.reloadData()
            editPressed = !editPressed
        }
    }

    @IBAction func removeRows(_ sender: Any) {
        guard tableView.indexPathForSelectedRow != nil else { return }
        let cancel = QOTAlertAction(title: AppTextService.get(AppTextKey.generic_view_button_cancel),
                                    target: self,
                                    action: #selector(cancelDeleteTapped(_:)),
                                    handler: nil)
        let remove = QOTAlertAction(title: AppTextService.get(AppTextKey.my_qot_my_plans_alert_delete_button_continue),
                                    target: self,
                                    action: #selector(confirmDeleteTapped(_:)),
                                    handler: nil)
        let title = AppTextService.get(AppTextKey.my_qot_my_plans_alert_delete_title)
        let message = AppTextService.get(AppTextKey.my_qot_my_plans_alert_delete_body)
        QOTAlert.show(title: title, message: message, bottomItems: [cancel, remove])
    }

    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        hideAllNoDataViews()
        updateIndicator()
        showEmptyStateViewIfNeeded(sender)
    }

    @objc func confirmDeleteTapped(_ sender: Any) {
        hideAllNoDataViews()
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

    @objc func cancelDeleteTapped(_ sender: Any) {
        updateControls()
    }
}

// MARK: - Private
private extension MyPrepsViewController {
    func updateControls() {
        refreshBottomNavigationItems()
        segmentedControl.isHidden = false
        tableView.setEditing(false, animated: true)
        tableView.reloadData()
        editPressed = false
    }

    func showEmptyStateViewIfNeeded(_ sender: UISegmentedControl) {
        updateEditButton(hidden: false)
        tableView.alpha = 1
        switch sender.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            if interactor?.numberOfRowsPreparations(in: 0) == Optional(0) {
                noPreparationsView.isHidden = false
                tableView.alpha = 0
                updateEditButton(hidden: true)
            }
        case SegmentView.mindsetShifter.rawValue:
            if interactor?.numberOfRowsMindsetShifters(in: 0) == Optional(0) {
                noMIndsetShiftersView.isHidden = false
                updateEditButton(hidden: true)
                tableView.alpha = 0
            }
        case SegmentView.recovery.rawValue:
            if interactor?.numberOfRowsRecoveries(in: 0) == Optional(0) {
                noRecoveriesView.isHidden = false
                updateEditButton(hidden: true)
                tableView.alpha = 0
            }
        default:
            return
        }
    }

    func setupView() {
        ThemeView.level3.apply(view)
        ThemeView.level3.apply(headerView)
        baseHeaderView?.configure(title: AppTextService.get(AppTextKey.my_qot_my_plans_section_header_title), subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
        ThemeText.myQOTPrepTitle.apply(AppTextService.get(AppTextKey.my_qot_my_plans_event_preps_null_state_title), to: noPrepsTitle)
        ThemeText.myQOTPrepComment.apply(AppTextService.get(AppTextKey.my_qot_my_preps_event_preps_view_body), to: noPrepsComment)
        ThemeText.myQOTPrepTitle.apply(AppTextService.get(AppTextKey.my_qot_my_plans_mindset_shifts_null_state_title), to: noMindsetTitle)
        ThemeText.myQOTPrepComment.apply(AppTextService.get(AppTextKey.my_qot_my_plans_mindset_shifts_null_state_body), to: noMindsetComment)
        ThemeText.myQOTPrepTitle.apply(AppTextService.get(AppTextKey.my_qot_my_plans_recovery_plans_null_state_title), to: noRecoveryTitle)
        ThemeText.myQOTPrepComment.apply(AppTextService.get(AppTextKey.my_qot_my_plans_recovery_plans_null_state_body), to: noRecoveryComment)

        ThemeView.level3.apply(tableView)
        tableView.registerDequeueable(MyPrepsTableViewCell.self)
        setupSegementedControl()
    }

    func updateEditButton(hidden: Bool) {
        editButton.isHidden = hidden
    }

    func hideAllNoDataViews() {
        noPreparationsView.isHidden = true
        noRecoveriesView.isHidden = true
        noMIndsetShiftersView.isHidden = true
    }
}

// MARK: - Actions
private extension MyPrepsViewController {
    func setupSegementedControl() {
        ThemeSegment.accent.apply(segmentedControl)
    }
}

// MARK: - MyPrepsViewControllerInterface
extension MyPrepsViewController: MyPrepsViewControllerInterface {
    func dataUpdated() {
        hideAllNoDataViews()
        if tableView.alpha == 0 {
            UIView.animate(withDuration: Animation.duration_04) { self.tableView.alpha = 1 }
        }
        tableView.reloadData()
        showEmptyStateViewIfNeeded(segmentedControl)
    }
}

extension MyPrepsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            count = interactor?.numberOfRowsPreparations(in: section) ?? 0
        case SegmentView.mindsetShifter.rawValue:
            count = interactor?.numberOfRowsMindsetShifters(in: section) ?? 0
        case SegmentView.recovery.rawValue:
            count = interactor?.numberOfRowsRecoveries(in: section) ?? 0
        default:
            count = 0
        }
        return count > 0 ? count : 3
    }

    private func tableView(tableView: UITableView,
                           editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        guard let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as? MyPrepsTableViewCell,
            cell.hasData else { return .none }
        return UITableViewCellEditingStyle.init(rawValue: 3)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPrepsTableViewCell = tableView.dequeueCell(for: indexPath)
        if editPressed == true {
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
        }

        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            let item = interactor?.itemPrep(at: indexPath)
            cell.configure(title: item?.title.uppercased(), subtitle: (item?.date ?? "") + " | " + (item?.eventType ?? ""))
        case SegmentView.mindsetShifter.rawValue:
            let item = interactor?.itemMind(at: indexPath)

            cell.configure(title: item?.title, subtitle: item?.date)
        case SegmentView.recovery.rawValue:
            let item = interactor?.itemRec(at: indexPath)
            cell.configure(title: item?.title, subtitle: item?.date)
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if let item = interactor?.itemPrep(at: indexPath), tableView.isEditing == false {
                tableView.deselectRow(at: indexPath, animated: true)
                interactor?.presentPreparation(item: item.qdmPrep, viewController: self)
            }
        } else if segmentedControl.selectedSegmentIndex == 1 {
            if let item = interactor?.itemMind(at: indexPath), tableView.isEditing == false {
                tableView.deselectRow(at: indexPath, animated: true)
                interactor?.presentMindsetShifter(item: item.qdmMind, viewController: self)
            }
        } else if segmentedControl.selectedSegmentIndex == 2 {
            if let item = interactor?.itemRec(at: indexPath), tableView.isEditing == false {
                tableView.deselectRow(at: indexPath, animated: true)
                interactor?.present3DRecovery(item: item.qdmRec, viewController: self)
            }
        }
        updateIndicator()
    }
}

extension MyPrepsViewController {

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        guard editPressed else { return nil }
        return [deleteButton, cancelButton]
    }

    @objc public func roundedBarBurtonItem(title: String, action: Selector) -> UIBarButtonItem {
        let button = RoundedButton(title: title, target: self, action: action)
        let item = button.barButton
        item.tintColor = colorMode.tint
        return item
    }

    func updateIndicator() {
        let location = segmentedControl.underline()
        indicatorViewLeadingConstraint.constant = location.xCentre - location.width / 2
        indicatorWidthConstraint.constant = location.width
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
