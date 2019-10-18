//
//  PrepareResultsViewController.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol PrepareResultsDelegatge: class {
    func openEditStrategyView()
    func didChangeReminderValue(for type: ReminderType, value isOn: Bool)
    func reloadData()
    func setupBarButtonItems(resultType: ResultType)
    func didUpdateIntentions(_ answerIds: [Int])
    func didUpdateBenefits(_ benefits: String)
}

final class PrepareResultsViewController: BaseWithGroupedTableViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: PrepareResultsInteractorInterface?
    private var rightBarItems: [UIBarButtonItem] = []

    // MARK: - Init
    init(configure: Configurator<PrepareResultsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.chatbot.apply(view)
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Private
private extension PrepareResultsViewController {
    func contentItemCell(format: ContentFormat,
                         title: String?,
                         indexPath: IndexPath) -> PrepareResultsContentTableViewCell {
        let cell: PrepareResultsContentTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(format, title: title, type: interactor?.getType ?? .LEVEL_DAILY)
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        return cell
    }

    func eventCell(title: String?, date: Date, type: String?, indexPath: IndexPath) -> PrepareEventTableViewCell {
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        let dateString = String(format: "%@ | %@", date.eventDateString, type ?? "")
        cell.configure(title: title ?? "", dateString: dateString)
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        cell.selectionStyle = .none
        return cell
    }

    func strategyCell(title: String?, duration: String?, indexPath: IndexPath) -> RelatedStrategyTableViewCell {
        let cell: RelatedStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: title, duration: duration)
        cell.setSelectedColor(.accent, alphaComponent: 0.1)
        return cell
    }

    func reminderCell(title: String,
                      subTitle: String,
                      isOn: Bool,
                      indexPath: IndexPath,
                      type: ReminderType) -> ReminderTableViewCell {
        let cell: ReminderTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: title, subTitle: subTitle, isOn: isOn, type: type)
        cell.delegate = self
        return cell
    }
}

// MARK: - Actions
private extension PrepareResultsViewController {
    @objc func didTapCancel() {
        trackUserEvent(.CANCEL, action: .TAP)
        interactor?.deletePreparation()
        interactor?.didTapDismissView()
    }

    @objc func didTapDismiss() {
        trackUserEvent(.CLOSE, action: .TAP)
        interactor?.didTapDismissView()
    }

    @objc func didTapDone() {
        trackUserEvent(.CLOSE, action: .TAP)
        if interactor?.setReminder == false {
            showAlert()
        } else {
            interactor?.updatePreparation { [weak self] (_) in
                self?.interactor?.didTapDismissView()
            }
        }
    }

    @objc func didTapSave() {
        trackUserEvent(.CONFIRM, action: .TAP)
        if interactor?.setReminder == false {
            showAlert()
        } else {
            interactor?.didClickSaveAndContinue()
            interactor?.presentFeedback()
        }
    }

    func getSelector(_ buttonItem: ButtonItem) -> Selector {
        switch buttonItem {
        case .cancel: return #selector(didTapCancel)
        case .done: return #selector(didTapDone)
        case .save: return #selector(didTapSave)
        }
    }

    func showAlert() {
        let confirm = QOTAlertAction(title: AppTextService.get(AppTextKey.my_qot_my_plans_event_preps_details_alert_title_yes)) { [weak self] (_) in
            self?.interactor?.setReminder = true
            self?.interactor?.updatePreparation { (_) in
                if self?.interactor?.getResultType == .prepareDecisionTree {
                    self?.interactor?.presentFeedback()
                } else {
                    self?.interactor?.didTapDismissView()
                }
            }
        }
        let decline = QOTAlertAction(title: AppTextService.get(AppTextKey.my_qot_my_plans_event_preps_details_alert_title_no)) { [weak self] (_) in
            self?.interactor?.updatePreparation { (_) in
                if self?.interactor?.getResultType == .prepareDecisionTree {
                    self?.interactor?.presentFeedback()
                } else {
                    self?.interactor?.didTapDismissView()
                }
            }
        }
        QOTAlert.show(title: AppTextService.get(AppTextKey.my_qot_my_plans_event_preps_details_alert_title_reminder),
                      message: AppTextService.get(AppTextKey.my_qot_my_plans_event_preps_details_alert_body_reminder),
                      bottomItems: [confirm, decline])
    }
}

// MARK: - PrepareResultsViewControllerInterface
extension PrepareResultsViewController: PrepareResultsViewControllerInterface {
    func reloadView() {
        reloadData()
    }

    func registerTableViewCell(_ type: QDMUserPreparation.Level) {
        switch type {
        case .LEVEL_DAILY,
             .LEVEL_CRITICAL:
            tableView.registerDequeueable(PrepareResultsContentTableViewCell.self)
            tableView.registerDequeueable(PrepareEventTableViewCell.self)
            tableView.registerDequeueable(RelatedStrategyTableViewCell.self)
            tableView.registerDequeueable(ReminderTableViewCell.self)
        case .LEVEL_ON_THE_GO:
            tableView.registerDequeueable(PrepareResultsContentTableViewCell.self)
        default: return
        }
    }

    func setupView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        self.view.fill(subview: tableView)
        tableView.contentInset.top = 84
        tableView.contentInset.bottom = 40
        tableView.estimatedSectionHeaderHeight = 100
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PrepareResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.sectionCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowCount(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.item(at: indexPath) else { return UITableViewCell() }
        switch item {
        case .contentItem(let format, let title):
            return contentItemCell(format: format,
                                   title: title,
                                   indexPath: indexPath)
        case .eventItem(let title, let date, let type):
            return eventCell(title: title, date: date, type: type, indexPath: indexPath)
        case .strategy(let title, let readingTime, _):
            return strategyCell(title: title, duration: readingTime, indexPath: indexPath)
        case .reminder(let title, let subTitle, let isOn, let type):
            return reminderCell(title: title, subTitle: subTitle, isOn: isOn, indexPath: indexPath, type: type)
        case .intentionContentItem(let format, let title, _):
            return contentItemCell(format: format,
                                   title: title,
                                   indexPath: indexPath)
        case .intentionItem(let title):
            return contentItemCell(format: .listitem,
                                   title: title,
                                   indexPath: indexPath)
        case .benefitContentItem(let format, let title, _, _):
            return contentItemCell(format: format,
                                   title: title,
                                   indexPath: indexPath)
        case .benefitItem(let benefits):
            return contentItemCell(format: .listitem,
                                   title: benefits,
                                   indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
        guard let item = interactor?.item(at: indexPath) else { return }
        switch item {
        case .strategy(_, _, let readMoreID):
            interactor?.presentRelatedArticle(readMoreID: readMoreID)
        case .intentionContentItem(_, _, let key):
            removeBottomNavigation()
            interactor?.presentEditIntentions(key)
        case .benefitContentItem(_, _, let benefits, _):
            removeBottomNavigation()
            interactor?.presentEditBenefits(benefits: benefits)
        case .contentItem(let format, _):
            if interactor?.getType == .LEVEL_CRITICAL && format.hasEditImage(.LEVEL_CRITICAL) {
                removeBottomNavigation()
                interactor?.presentEditStrategyView()
            }
        default:
            return
        }
    }
}

extension PrepareResultsViewController: PrepareResultsDelegatge {
    func setupBarButtonItems(resultType: ResultType) {
        rightBarItems.removeAll()
        resultType.buttonItems.forEach { (buttonItem) in
            rightBarItems.append(roundedBarButtonItem(title: buttonItem.title,
                                                      buttonWidth: buttonItem.width,
                                                      action: getSelector(buttonItem),
                                                      backgroundColor: buttonItem.backgroundColor,
                                                      borderColor: buttonItem.borderColor))
        }
        updateBottomNavigation([], rightBarItems)
    }

    func didUpdateIntentions(_ answerIds: [Int]) {
        interactor?.updateIntentions(answerIds)
        refreshBottomNavigationItems()
    }

    func didUpdateBenefits(_ benefits: String) {
        refreshBottomNavigationItems()
        interactor?.updateBenefits(benefits)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func didChangeReminderValue(for type: ReminderType, value isOn: Bool) {
        switch type {
        case .reminder:
            interactor?.setReminder = isOn
        default: break
        }
        refreshBottomNavigationItems()
    }

    func openEditStrategyView() {
        interactor?.presentEditStrategyView()
        refreshBottomNavigationItems()
    }

    func dismissResultView() {
        interactor?.didTapDismissView()
    }
}

// MARK: - ChoiceViewControllerDelegate
extension PrepareResultsViewController: ChoiceViewControllerDelegate {
    func dismiss(_ viewController: UIViewController, selections: [Choice]) {
        let selectedIds = selections.compactMap { $0.contentId }
        viewController.dismiss(animated: true) { [weak self] in
            self?.interactor?.updateStrategies(selectedIds: selectedIds)
        }
    }

    func didTapRow(_ viewController: UIViewController, contentId: Int) {
        interactor?.presentRelatedArticle(readMoreID: contentId)
    }

    func dismiss(_ viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Bottom Navigation
extension PrepareResultsViewController {
    @objc override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if interactor?.getType == .LEVEL_ON_THE_GO {
            return [doneButtonItem(#selector(didTapDismiss))]
        }
        return rightBarItems
    }
}
