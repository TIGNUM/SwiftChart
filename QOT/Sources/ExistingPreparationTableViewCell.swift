//
//  ExistingPreparationTableViewCell.swift
//  QOT
//
//  Created by karmic on 29.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ExistingPreparationTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties
    weak var delegate: DTQuestionnaireViewControllerDelegate?
    private var preparations: [QDMUserPreparation] = []
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.tableFooterView = UIView()
        tableView.registerDequeueable(PrepareEventTableViewCell.self)
    }

    // MARK: Configuration
    func configure(tableViewHeight: CGFloat, preparations: [QDMUserPreparation]) {
        self.tableViewHeight.constant = tableViewHeight
        self.preparations = preparations
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ExistingPreparationTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preparations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        let preparation = preparations.at(index: indexPath.row)
        let title = preparation?.name ?? preparation?.eventType
        cell.configure(title: title, dateString: Prepare.prepareDateString(preparation?.createdAt))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectExistingPreparation(preparations.at(index: indexPath.row))
    }
}
