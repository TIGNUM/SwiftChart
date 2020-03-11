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

}

// MARK: - Actions
private extension ResultsPrepareViewController {

}

// MARK: - ResultsPrepareViewControllerInterface
extension ResultsPrepareViewController: ResultsPrepareViewControllerInterface {
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
extension ResultsPrepareViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
