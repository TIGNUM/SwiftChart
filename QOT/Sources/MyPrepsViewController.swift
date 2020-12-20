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

    enum PrepTypes: Int {
        case criticalEvents = 0
        case everyday
        case total
    }

    // MARK: - Properties

    var interactor: MyPrepsInteractorInterface!
    private lazy var router = MyPrepsRouter(viewController: self)
    weak var delegate: CoachCollectionViewControllerDelegate?
    private lazy var baseHeaderView: QOTBaseHeaderView? = R.nib.qotBaseHeaderView.firstView(owner: self)
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var editButton: RoundedButton!
    @IBOutlet private weak var noPreparationsView: UIView!
    @IBOutlet private weak var noRecoveriesView: UIView!
    @IBOutlet private weak var noMIndsetShiftersView: UIView!
    @IBOutlet private weak var noPrepsTitle: UILabel!
    @IBOutlet private weak var noMindsetTitle: UILabel!
    @IBOutlet private weak var noRecoveryTitle: UILabel!
    @IBOutlet private weak var noPrepsSubtitle: UILabel!
    @IBOutlet private weak var noMindsetSubtitle: UILabel!
    @IBOutlet private weak var noRecoverySubtitle: UILabel!
    @IBOutlet private weak var indicatorWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var indicatorView: UIView!
    private var editPressed: Bool = false
    private var canDelete: Bool = false
    private var viewModel: MyPlansViewModel!
    private var bottomNavigationItems = UINavigationItem()

    lazy var cancelButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(cancelButton(_:)))
        ThemableButton.darkButton.apply(button, title: AppTextService.get(.generic_view_button_cancel))
        return button.barButton
    }()

    lazy var prepareEventButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(addEventPrep))
        ThemableButton.darkButton.apply(button, title: AppTextService.get(.my_qot_my_plans_event_preps_null_state_cta))
        return button.barButton
    }()

    lazy var addMindsetShiftButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(addMindsetShift))
        ThemableButton.darkButton.apply(button, title: AppTextService.get(.my_qot_my_plans_mindset_shifts_null_state_cta))
        return button.barButton
    }()

    lazy var planRecoveryButton: UIBarButtonItem = {
        let button = RoundedButton(title: nil, target: self, action: #selector(addRecovery))
        ThemableButton.darkButton.apply(button, title: AppTextService.get(.my_qot_my_plans_recovery_plans_null_state_cta))
        return button.barButton
    }()

    func getDeleteButton(isEnabled: Bool) -> UIBarButtonItem {
        let button = RoundedButton(title: nil, target: self, action: #selector(removeRows(_:)))
        ThemableButton.darkButton.apply(button, title: AppTextService.get(.generic_view_button_delete))
        button.isEnabled = isEnabled
        return button.barButton
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView?.addTo(superview: headerView)
        ThemeButton.editButton.apply(editButton)
        editButton.imageView?.tintColor = .white
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        updateIndicator()
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideAllNoDataViews()
        updateIndicator()
        interactor.fetchItemsAndUpdateView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        guard editPressed else { return super.bottomNavigationLeftBarItems() }
        return []
    }

    override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return bottomNavigationItems.rightBarButtonItems
    }

    // MARK: - Actions
    @IBAction func didChangeSegment(_ sender: Any) {
        tableView.reloadData()
        updateIndicator()
        trackUserEvent(.OPEN,
                       value: segmentedControl.selectedSegmentIndex,
                       valueType: .MY_PLANS_SEGMENT_CHANGE,
                       action: .TAP)
    }

    @IBAction func cancelButton(_ sender: Any) {
        editButton(sender)
        updateButton()
    }

    @IBAction func editButton(_ sender: Any) {
        editPressed = !editPressed
        if editPressed {
            bottomNavigationItems.rightBarButtonItems = [getDeleteButton(isEnabled: editPressed), cancelButton]
        } else {
            bottomNavigationItems.rightBarButtonItems = nil
        }
        canDelete = false
        let title = editPressed ? viewModel?.titleEditMode : viewModel.title
        baseHeaderView?.fadeTransition(0.5)
        baseHeaderView?.configure(title: title, subtitle: nil)
        refreshBottomNavigationItems()
        editButton.isHidden = editPressed
        indicatorView.isHidden = editPressed
        segmentedControl.isHidden = editPressed
        tableView.setEditing(editPressed, animated: true)
    }

    @IBAction func removeRows(_ sender: Any) {
        guard tableView.indexPathForSelectedRow != nil else { return }
        let cancel = QOTAlertAction(title: AppTextService.get(.generic_view_button_cancel),
                                    target: self,
                                    action: #selector(cancelDeleteTapped(_:)),
                                    handler: nil)
        let remove = QOTAlertAction(title: AppTextService.get(.my_qot_my_plans_alert_delete_button_continue),
                                    target: self,
                                    action: #selector(confirmDeleteTapped(_:)),
                                    handler: nil)
        let title = AppTextService.get(.my_qot_my_plans_alert_delete_title)
        let message = AppTextService.get(.my_qot_my_plans_alert_delete_body)
        QOTAlert.show(title: title, message: message, bottomItems: [cancel, remove])
    }

    @IBAction func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        hideAllNoDataViews()
        updateIndicator()
        showEmptyStateViewIfNeeded(sender)
        updateButton()
    }

    @objc func confirmDeleteTapped(_ sender: Any) {
        hideAllNoDataViews()
        if let selectedRows = tableView.indexPathsForSelectedRows {
            let sortedArray = selectedRows.sorted { $1.row < $0.row }
            for indexPath in sortedArray {
                interactor.remove(segmentedControl: segmentedControl.selectedSegmentIndex, at: indexPath)
            }
            showEmptyStateViewIfNeeded(segmentedControl)
        }
        refreshBottomNavigationItems()
        updateControls()
        showEmptyStateViewIfNeeded(segmentedControl)
        tableView.reloadData()
    }

    @objc func cancelDeleteTapped(_ sender: Any) {
        updateControls()
    }
}

// MARK: - Private
private extension MyPrepsViewController {

    func updateButton() {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            updateBottomNavigation(super.bottomNavigationLeftBarItems() ?? [], [prepareEventButton])
        case SegmentView.mindsetShifter.rawValue:
            updateBottomNavigation(super.bottomNavigationLeftBarItems() ?? [], [addMindsetShiftButton])
        case SegmentView.recovery.rawValue:
            updateBottomNavigation(super.bottomNavigationLeftBarItems() ?? [], [planRecoveryButton])
        default:
            break
        }
    }

    func updateControls() {
        refreshBottomNavigationItems()
        segmentedControl.isHidden = false
        tableView.setEditing(false, animated: true)
        tableView.reloadData()
        editPressed = false
    }

    @objc func addEventPrep() {
        updateBottomNavigation([], [])
        router.createEventPlan()
    }

    @objc func addMindsetShift() {
        updateBottomNavigation([], [])
        router.createMindsetShifter()
    }

    @objc func addRecovery() {
        updateBottomNavigation([], [])
        router.createRecoveryPlan()
    }

    func showEmptyStateViewIfNeeded(_ sender: UISegmentedControl) {
        updateEditButton(hidden: false)
        tableView.alpha = 1
        updateButton()
        let title = AppTextService.get(.my_qot_my_plans_section_header_title)
        switch sender.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            bottomNavigationItems.rightBarButtonItems = [prepareEventButton]
            refreshBottomNavigationItems()
            if interactor.numberOfRowsPreparations() == 0 {
                baseHeaderView?.configure(title: title, subtitle: nil)
                noPreparationsView.isHidden = false
                tableView.alpha = 0
                updateEditButton(hidden: true)
            }
        case SegmentView.mindsetShifter.rawValue:
            bottomNavigationItems.rightBarButtonItems = [addMindsetShiftButton]
            refreshBottomNavigationItems()
            if interactor.numberOfRowsMindsetShifters() == 0 {
                baseHeaderView?.configure(title: title, subtitle: nil)
                noMIndsetShiftersView.isHidden = false
                updateEditButton(hidden: true)
                tableView.alpha = 0
            }
        case SegmentView.recovery.rawValue:
            bottomNavigationItems.rightBarButtonItems = [planRecoveryButton]
            refreshBottomNavigationItems()
            if interactor.numberOfRowsRecoveries() == 0 {
                baseHeaderView?.configure(title: title, subtitle: nil)
                noRecoveriesView.isHidden = false
                updateEditButton(hidden: true)
                tableView.alpha = 0
            }
        default:
            return
        }
    }

    func updateEditButton(hidden: Bool) {
        editButton.isHidden = hidden
    }

    func hideAllNoDataViews() {
        noPreparationsView.isHidden = true
        noRecoveriesView.isHidden = true
        noMIndsetShiftersView.isHidden = true
    }

    func updateDeleteButtonIfNeeded(_ tableView: UITableView) {
        canDelete = !(tableView.indexPathsForSelectedRows?.isEmpty ?? true)
        refreshBottomNavigationItems()
    }
}

// MARK: - Actions
private extension MyPrepsViewController {
    func setupSegementedControl() {
        ThemeSegment.lightGray.apply(segmentedControl)
    }
}

// MARK: - MyPrepsViewControllerInterface
extension MyPrepsViewController: MyPrepsViewControllerInterface {
    func setupView(viewModel: MyPlansViewModel) {
        ThemeView.level3.apply(view)
        ThemeView.level3.apply(headerView)
        baseHeaderView?.configure(title: viewModel.title, subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0
        ThemeText.myQOTPrepTitle.apply(viewModel.myPrepsTitle, to: noPrepsTitle)
        ThemeText.myQOTPrepTitle.apply(viewModel.mindsetShifterTitle, to: noMindsetTitle)
        ThemeText.myQOTPrepTitle.apply(viewModel.recoveryTitle, to: noRecoveryTitle)
        ThemeText.myQOTPrepComment.apply(viewModel.myPrepsBody, to: noPrepsSubtitle)
        ThemeText.myQOTPrepComment.apply(viewModel.mindsetShifterBody, to: noMindsetSubtitle)
        ThemeText.myQOTPrepComment.apply(viewModel.recoveryBody, to: noRecoverySubtitle)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 90
        ThemeView.level3.apply(tableView)
        setupSegementedControl()
        self.viewModel = viewModel
    }

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
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            switch section {
            case PrepTypes.criticalEvents.rawValue:
                return interactor?.criticalPrepItems?.count ?? 0
            case PrepTypes.everyday.rawValue:
                return interactor?.everydayPrepItems?.count ?? 0
            default:
                return 0
            }
        case SegmentView.mindsetShifter.rawValue:
            return interactor.numberOfRowsMindsetShifters()
        case SegmentView.recovery.rawValue:
            return interactor.numberOfRowsRecoveries()
        default:
            return 0
        }
    }

    private func tableView(tableView: UITableView,
                           editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
        guard let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row,
                                                            section: indexPath.section)) as? MyPrepsTableViewCell,
            cell.hasData else { return .none }
        return UITableViewCell.EditingStyle.init(rawValue: 3)!
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            return PrepTypes.total.rawValue
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            switch section {
            case PrepTypes.criticalEvents.rawValue:
                let count = interactor?.numberOfRowsCriticalPreparations()
                let title = AppTextService.get(.my_qot_my_plans_section_header_critical)
                return count ?? 0 > 0 ? MyPlansHeaderView.instantiateFromNib(title: title, theme: .level2) : nil
            case PrepTypes.everyday.rawValue:
                let count = interactor?.numberOfRowsEverydayPreparations()
                let title = AppTextService.get(.my_qot_my_plans_section_header_everyday)
                return count ?? 0 > 0 ? MyPlansHeaderView.instantiateFromNib(title: title, theme: .level2) : nil
            default:
                return nil
            }
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            switch section {
            case PrepTypes.criticalEvents.rawValue:
                return interactor?.numberOfRowsCriticalPreparations() ?? 0 > 0 ? tableView.estimatedSectionHeaderHeight : 0
            case PrepTypes.everyday.rawValue:
                return interactor?.numberOfRowsEverydayPreparations() ?? 0 > 0 ? tableView.estimatedSectionHeaderHeight : 0
            default:
                return 0
            }
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyPrepsTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.subtitleView.isHidden = false
        if editPressed == true {
            cell.setSelectedColor(.accent, alphaComponent: 0.1)
        }
        switch segmentedControl.selectedSegmentIndex {
        case SegmentView.myPreps.rawValue:
            let prepItems = [interactor.criticalPrepItems, interactor.everydayPrepItems]
            let item = prepItems[indexPath.section]?[indexPath.row]
            let subtitle = (item?.date ?? "") + " | " + (item?.eventType ?? "")
            var title = ""
            title = item?.calendarEventTitle.uppercased() ?? ""
            if title.isEmpty {
                title = item?.title.uppercased() ?? ""
                cell.subtitleView.isHidden = true
            }
            cell.configure(title: title, subtitle: subtitle)
        case SegmentView.mindsetShifter.rawValue:
            let item = interactor.itemMind(at: indexPath)
            cell.configure(title: item?.title.uppercased(), subtitle: item?.date)
        case SegmentView.recovery.rawValue:
            let item = interactor.itemRec(at: indexPath)
            cell.configure(title: item?.title.uppercased(), subtitle: item?.date)
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateDeleteButtonIfNeeded(tableView)
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case SegmentView.myPreps.rawValue:
                let prepItems = [interactor.criticalPrepItems, interactor.everydayPrepItems]
                if let item = prepItems[indexPath.section]?[indexPath.row], tableView.isEditing == false {
                    tableView.deselectRow(at: indexPath, animated: true)
                    interactor.presentPreparation(item: item.qdmPrep, viewController: self)
                }
            case SegmentView.mindsetShifter.rawValue:
                if let item = interactor.itemMind(at: indexPath), tableView.isEditing == false {
                    tableView.deselectRow(at: indexPath, animated: true)
                    interactor.presentMindsetShifter(item: item.qdmMind, viewController: self)
                }
            case SegmentView.recovery.rawValue:
                if let item = interactor.itemRec(at: indexPath), tableView.isEditing == false {
                    tableView.deselectRow(at: indexPath, animated: true)
                    interactor.present3DRecovery(item: item.qdmRec, viewController: self)
                }
            default:
                break
            }
            updateIndicator()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateDeleteButtonIfNeeded(tableView)
        }
    }
}

extension MyPrepsViewController {

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
