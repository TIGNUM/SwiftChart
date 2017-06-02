//
//  PrepareTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol PrepareEventsViewControllerDelegate: class {
    func didTapItem(item: PrepareEventsItem, in viewController: PrepareEventsViewController)
}

final class PrepareEventsViewController: UIViewController {

    // MARK: - Properties

    fileprivate let viewModel: PrepareEventsViewModel
    weak var delegate: PrepareEventsViewControllerDelegate?
    fileprivate let headerFooterIdentifier = String(describing: PrepareEventTableViewHeader.self)

    fileprivate lazy var tableView: UITableView = {
        return UITableView(            
            estimatedRowHeight: 140,
            delegate: self,
            dataSource: self,
            dequeables:
                PrepareEventsUpcomingTripTableViewCell.self,
                PrepareEventAddNewTripTableViewCell.self,
                PrepareEventSimpleTableViewCell.self
        )
    }()

    // MARK: - Init

    init(viewModel: PrepareEventsViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Private

private extension PrepareEventsViewController {

    func setupView() {
        view.addSubview(tableView)
        let nib = UINib(nibName: headerFooterIdentifier, bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerFooterIdentifier)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
    }

    func prepareAndSetTextAttributes(string: String, value: CGFloat) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        attrString.addAttribute(NSKernAttributeName, value: value, range: NSRange(location: 0, length: string.utf16.count))

        return attrString
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PrepareEventsViewController: UITableViewDelegate, UITableViewDataSource {

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
        guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerFooterIdentifier) as? PrepareEventTableViewHeader else {
            fatalError("cannotCast")
        }

        let item = viewModel.title(section: section)
        cell.headerTitleLabel.attributedText = prepareAndSetTextAttributes(string: item, value: 1)

        return cell.contentView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
}
