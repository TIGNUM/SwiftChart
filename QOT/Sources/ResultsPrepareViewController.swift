//
//  ResultsPrepareViewController.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPrepareViewController: BaseWithGroupedTableViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: ResultsPrepareInteractorInterface!
    weak var delegate: CalendarEventSelectionDelegate?
    var resultType = ResultType.prepareMyPlans
    private lazy var router: ResultsPrepareRouterInterface = ResultsPrepareRouter(viewController: self,
                                                                                  delegate: delegate,
                                                                                  resultType: resultType)
    private var sections: [Int: ResultsPrepare.Sections] = [:]
    private var rightBarItems: [UIBarButtonItem] = []

    // MARK: - Init
    init(configure: Configurator<ResultsPrepareViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.chatbot.apply(view)
        interactor.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Bottom Navigation
extension ResultsPrepareViewController {
    @objc override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rightBarItems
    }
}

// MARK: - Private
private extension ResultsPrepareViewController {
    func registerTableViewCells() {
        tableView.registerDequeueable(RelatedStrategyTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareAddEventTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareBenefitsTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareEditableTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareEventTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareTitleTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareQuestionTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareQuestionDailyTableViewCell.self)
        tableView.registerDequeueable(ResultsPrepareHeaderTableViewCell.self)
    }

    func getQuestionCell(title: String,
                         answers: [QDMAnswer],
                         indexPath: IndexPath) -> ResultsPrepareQuestionTableViewCell {
        if answers.isEmpty {
            let cell: ResultsPrepareQuestionDailyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title)
            return cell
        }
        let cell: ResultsPrepareQuestionTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: title,
                       firstItem: answers.at(index: 0)?.subtitle,
                       secondItem: answers.at(index: 1)?.subtitle,
                       thirdItem: answers.at(index: 2)?.subtitle)
        return cell
    }

    func presentEditView(key: Prepare.Key) {
        interactor.getDTViewModel(key: key) { [weak self] (viewModel, question) in
            self?.removeBottomNavigation()
            self?.router.presentDTEditView(viewModel, question: question, delegate: self)
        }
    }

    func getSelector(_ buttonItem: ButtonItem) -> Selector {
         switch buttonItem {
         case .cancel: return #selector(didTapCancel)
         case .done: return #selector(didTapDone)
         case .save: return #selector(didTapSave)
         }
     }
}

// MARK: - Actions
private extension ResultsPrepareViewController {
    @objc func didTapCancel() {
        trackUserEvent(.CANCEL, action: .TAP)
        interactor.deletePreparation()
        router.didTapDismiss()
    }

    @objc func didTapDismiss() {
        trackUserEvent(.CLOSE, action: .TAP)
        router.didTapDismiss()
    }

    @objc func didTapDone() {
        trackUserEvent(.CLOSE, action: .TAP)
        interactor.updatePreparation { [weak self] (_) in
            self?.router.didTapDismiss()
        }
    }

    @objc func didTapSave() {
        trackUserEvent(.CONFIRM, action: .TAP)
        interactor.didClickSaveAndContinue()
        router.presentPlans()
    }
}

// MARK: - ResultsPrepareViewControllerInterface
extension ResultsPrepareViewController: ResultsPrepareViewControllerInterface {
    func setupBarButtonItems() {
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
        refreshBottomNavigationItems()
        interactor.updateIntentions(answerIds)
    }

    func didUpdateBenefits(_ benefits: String) {
        refreshBottomNavigationItems()
        interactor.updateBenefits(benefits)
    }

    func updateView(items: [Int: ResultsPrepare.Sections]) {
        self.sections = items
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        refreshBottomNavigationItems()
    }

    func setupView() {
        registerTableViewCells()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.fill(subview: tableView)
        tableView.contentInset.top = 84
        tableView.contentInset.bottom = 40
        tableView.estimatedSectionHeaderHeight = 100
        setupBarButtonItems()
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ResultsPrepareViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount(in: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = sections[indexPath.section] else { fatalError("Invalid section") }
        switch section {
        case .benefits(let title, let subtitle, let benefits):
            let cell: ResultsPrepareBenefitsTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, subtitle: subtitle, benefits: benefits)
            return cell

        case .calendar(let title, let subtitle):
            let cell: ResultsPrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, subtitle: subtitle)
            return cell

        case .calendarConnect(let title, let subtitle):
            let cell: ResultsPrepareAddEventTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, subtitle: subtitle)
            return cell

        case .header(let title):
            let cell: ResultsPrepareHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title)
            return cell

        case .know(let title, let answers),
             .feel(let title, let answers),
             .perceived(let title, let answers):
            return getQuestionCell(title: title, answers: answers, indexPath: indexPath)

        case .title(let title),
             .strategyTitle(let title):
            let cell: ResultsPrepareTitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, hideEditIcon: interactor.hideEditIcon(title: title))
            return cell

        case .strategies(let strategies):
            let strategy = strategies.at(index: indexPath.row)
            let cell: RelatedStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: strategy?.title, duration: strategy?.durationString)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow(at: indexPath)
        guard let section = sections[indexPath.section] else { return }

        switch section {
        case .calendar:
            interactor.updatePreparationEvent(event: nil)
        case .calendarConnect:
            router.didSelectConnectToCalendar()
        case .benefits:
            presentEditView(key: .benefits)
        case .feel:
            presentEditView(key: .feel)
        case .know:
            presentEditView(key: .know)
        case .perceived:
            presentEditView(key: .perceived)
        case .strategyTitle:
            let ids = interactor.getStrategyIds()
            router.presentEditStrategyView(ids.relatedId, ids.selectedIds, delegate: self)
        case .strategies(let strategies):
            if let contentId = strategies.at(index: indexPath.row)?.remoteID {
                router.didSelectStrategy(contentId)
            }
        default: return
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow(at: indexPath)
    }
}

// MARK: - ChoiceViewControllerDelegate
extension ResultsPrepareViewController: ChoiceViewControllerDelegate {
    func dismiss(_ viewController: UIViewController, selections: [Choice]) {
        let selectedIds = selections.compactMap { $0.contentId }
        viewController.dismiss(animated: true) { [weak self] in
            self?.interactor.updateStrategies(selectedIds)
        }
    }

    func didTapRow(_ viewController: UIViewController, contentId: Int) {
        router.didSelectStrategy(contentId)
    }
}
