//
//  PrepareTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareEventsViewControllerDelegate: class {
    func didTapClose(in viewController: PrepareEventsViewController)
    func didTapItem(item: PrepareEventsItem, in viewController: PrepareEventsViewController)
}

final class PrepareEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let viewModel: PrepareEventsViewModel
    weak var delegate: PrepareEventsViewControllerDelegate?

    private let estimatedRowHeight: CGFloat = 140.0

    // MARK: - Life Cycle

    init(viewModel: PrepareEventsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let attrString = NSMutableAttributedString(string: "ADD THIS PREPARATION TO")
        attrString.addAttribute(NSKernAttributeName, value: 1, range: NSRange(location: 0, length: "ADD THIS PREPARATION TO".characters.count))
        viewTitleLabel.attributedText = attrString

        tableView.registerDequeueable(PrepareEventsUpcomingTripTableViewCell.self)
        tableView.registerDequeueable(PrepareEventAddNewTripTableViewCell.self)
        tableView.registerDequeueable(PrepareEventSimpleTableViewCell.self)

        let nib = UINib(nibName: String(describing: PrepareEventHeaderTableViewCell.self), bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: PrepareEventHeaderTableViewCell.self))

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
    }

    func closeView(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didTapClose(in: self)
    }
}

extension PrepareEventsViewController {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath)

        switch item {
        case .event(let event):
            let cell: PrepareEventsUpcomingTripTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.prepareAndSetTextAttributes(string: event.title, label: cell.titleLabel, value: 1)
            cell.prepareAndSetTextAttributes(string: event.subtitle, label: cell.dateLabel, value: 2)
            return cell

        case .addEvent:
            let cell: PrepareEventAddNewTripTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.prepareAndSetTextAttributes(string: "Add new trip", label: cell.addNewTripLabel, value: 1)
            return cell

        case .addReminder(let title):
            let cell: PrepareEventSimpleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.prepareAndSetTextAttributes(string: title, label: cell.titleLabel, value: -0.2)
            return cell

        case .saveToPDF(let title):
            let cell: PrepareEventSimpleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.prepareAndSetTextAttributes(string: title, label: cell.titleLabel, value: -0.2)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = viewModel.title(section: section)

        guard let cell: PrepareEventHeaderTableViewCell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: PrepareEventHeaderTableViewCell.self)) as? PrepareEventHeaderTableViewCell
            else {
                fatalError("cannotCast")
        }
        cell.prepareAndSetTextAttributes(string: item, label: cell.headerTitleLabel, value: 1)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

}
