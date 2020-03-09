//
//  CalendarEventSelectionViewController.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class CalendarEventSelectionViewController: BaseWithGroupedTableViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: CalendarEventSelectionInteractorInterface!
    private lazy var router: CalendarEventSelectionRouterInterface = CalendarEventSelectionRouter(viewController: self)

    // MARK: - Init
    init(configure: Configurator<CalendarEventSelectionViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension CalendarEventSelectionViewController {

}

// MARK: - Actions
private extension CalendarEventSelectionViewController {

}

// MARK: - CalendarEventSelectionViewControllerInterface
extension CalendarEventSelectionViewController: CalendarEventSelectionViewControllerInterface {
    func setupView() {
        tableView.registerDequeueable(PrepareEventTableViewCell.self)
        tableView.backgroundColor = .accent
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
extension CalendarEventSelectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.rowCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        let event = interactor.event(at: indexPath.row)
        cell.configure(title: event?.title, dateString: event?.dateString)
        return cell
    }
}
