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
    private lazy var router: ResultsPrepareRouterInterface = ResultsPrepareRouter(viewController: self)
    private var sections: [Int: ResultsPrepare.Sections] = [:]

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
        tableView.registerDequeueable(ResultsPrepareHeaderTableViewCell.self)
    }
}

// MARK: - Actions
private extension ResultsPrepareViewController {

}

// MARK: - ResultsPrepareViewControllerInterface
extension ResultsPrepareViewController: ResultsPrepareViewControllerInterface {
    func updateView(items: [Int: ResultsPrepare.Sections]) {
        self.sections = items
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func setupView() {
        registerTableViewCells()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        view.fill(subview: tableView)
        tableView.contentInset.top = 84
        tableView.contentInset.bottom = 40
        tableView.estimatedSectionHeaderHeight = 100
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

        case .calendar(let title, let subtitle, let calendarItem):
            switch calendarItem {
            case .selected:
                let cell: ResultsPrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(title: title, subtitle: subtitle)
                return cell
            case .unselected:
                let cell: ResultsPrepareAddEventTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.configure(title: title, subtitle: subtitle)
                return cell
            }

        case .feel(let title, let answers):
            let cell: ResultsPrepareQuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           firstItem: answers.at(index: 0)?.subtitle,
                           secondItem: answers.at(index: 1)?.subtitle,
                           thirdItem: answers.at(index: 2)?.subtitle)
            return cell

        case .header(let title):
            let cell: ResultsPrepareHeaderTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title)
            return cell

        case .know(let title, let answers):
            let cell: ResultsPrepareQuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           firstItem: answers.at(index: 0)?.subtitle,
                           secondItem: answers.at(index: 1)?.subtitle,
                           thirdItem: answers.at(index: 2)?.subtitle)
            return cell

        case .perceived(let title, let answers):
            let cell: ResultsPrepareQuestionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title,
                           firstItem: answers.at(index: 0)?.subtitle,
                           secondItem: answers.at(index: 1)?.subtitle,
                           thirdItem: answers.at(index: 2)?.subtitle)
            return cell

        case .title(let title):
            let cell: ResultsPrepareTitleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title)
            return cell

        case .strategies(let strategies):
            let strategy = strategies.at(index: indexPath.row)
            let cell: RelatedStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: strategy?.title, duration: strategy?.durationString)
            return cell
        }
    }
}
