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

        let attrString = NSMutableAttributedString(string: R.string.localized.preparePrepareEventsAddPreparation())
        attrString.addAttribute(NSKernAttributeName, value: 1, range: NSRange(location: 0, length: R.string.localized.preparePrepareEventsAddPreparation().utf16.count))
        viewTitleLabel.attributedText = attrString

        tableView.registerDequeueable(PrepareEventsUpcomingTripTableViewCell.self)
        tableView.registerDequeueable(PrepareEventAddNewTripTableViewCell.self)
        tableView.registerDequeueable(PrepareEventSimpleTableViewCell.self)

        let nib = UINib(nibName: String(describing: PrepareEventTableViewHeader.self), bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: PrepareEventTableViewHeader.self))

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
    }

    func prepareAndSetTextAttributes(string: String, value: CGFloat) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: value, range: NSRange(location: 0, length: string.utf16.count))
        return attrString
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
            cell.titleLabel.attributedText = prepareAndSetTextAttributes(string: event.title, value: 1)
            cell.dateLabel.attributedText = prepareAndSetTextAttributes(string: event.subtitle, value: 2)
            return cell

        case .addEvent:
            let cell: PrepareEventAddNewTripTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.addNewTripLabel.attributedText = prepareAndSetTextAttributes(string: R.string.localized.preparePrepareEventsAddNewTrip(), value: 1)
            return cell

        case .addReminder(let title):
            let cell: PrepareEventSimpleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.attributedText = prepareAndSetTextAttributes(string: title, value: -0.2)
            return cell

        case .saveToPDF(let title):
            let cell: PrepareEventSimpleTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.titleLabel.attributedText = prepareAndSetTextAttributes(string: title, value: -0.2)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let item = viewModel.title(section: section)

        guard let cell: PrepareEventTableViewHeader = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: PrepareEventTableViewHeader.self)) as? PrepareEventTableViewHeader
            else {
                fatalError("cannotCast")
        }
        cell.headerTitleLabel.attributedText = prepareAndSetTextAttributes(string: item, value: 1)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

}
