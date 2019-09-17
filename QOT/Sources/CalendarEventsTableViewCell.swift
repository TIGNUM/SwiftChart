//
//  CalendarEventsTableViewCell.swift
//  QOT
//
//  Created by karmic on 29.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CalendarEventsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: DTQuestionnaireViewControllerDelegate?
    private var events: [DTViewModel.Event] = []
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.tableFooterView = UIView()
        tableView.registerDequeueable(PrepareEventTableViewCell.self)
    }

    // MARK: Configuration
    func configure(tableViewHeight: CGFloat, events: [DTViewModel.Event]) {
        self.tableViewHeight.constant = tableViewHeight
        self.events = events
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CalendarEventsTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        let event = events.at(index: indexPath.row)
        cell.configure(title: event?.title, dateString: event?.dateString)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectPreparationEvent(events.at(index: indexPath.row))
    }
}
