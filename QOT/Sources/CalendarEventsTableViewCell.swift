//
//  CalendarEventsTableViewCell.swift
//  QOT
//
//  Created by karmic on 29.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CalendarEventsTableViewCell: UITableViewCell, Dequeueable, PrepareEventSelectionTableViewCellInterface {

    var interactor: PrepareEventSelectionInteractorInterface?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.registerDequeueable(PrepareEventTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func configure(delegate: DecisionTreeQuestionnaireDelegate?, tableViewHeight: CGFloat, question: Question) {
        self.tableViewHeight.constant = tableViewHeight
        qot_dal.CalendarService.main.getCalendarEvents { [weak self] (events) in
            PrepareEventSelectionConfigurator.make(self, delegate: delegate, question: question, events: events ?? [])
            self?.tableView.reloadDataWithAnimation()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension CalendarEventsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        let event = interactor?.event(at: indexPath)
        let dateString = interactor?.dateString(for: event)
        cell.configure(title: event?.title, dateString: dateString)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let event = interactor?.event(at: indexPath) else { return }
        interactor?.didSelect(event)
    }
}
