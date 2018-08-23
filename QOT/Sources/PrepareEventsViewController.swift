//
//  PrepareTripsViewController.swift
//  QOT
//
//  Created by karmic on 28/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import EventKit

protocol PrepareEventsViewControllerDelegate: class {
    func didTapClose(viewController: PrepareEventsViewController)
    func didTapEvent(event: CalendarEvent, viewController: PrepareEventsViewController)
    func didTapSavePrepToDevice(viewController: PrepareEventsViewController)
    func didTapAddNewTrip(viewController: PrepareEventsViewController)
}

final class PrepareEventsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var viewTitleLabel: UILabel!
    @IBOutlet private weak var upcomingEventsTitleLabel: UILabel!
    @IBOutlet private weak var eventsTableView: UITableView!
    @IBOutlet private weak var yourDeviceTitleLabel: UILabel!
    @IBOutlet private weak var savePreparationButton: UIButton!
    weak var delegate: PrepareEventsViewControllerDelegate?
    private let viewModel: PrepareEventsViewModel

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
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.rowHeight = UITableViewAutomaticDimension
        eventsTableView.estimatedRowHeight = 65
        eventsTableView.registerDequeueable(PrepareEventsUpcomingTripTableViewCell.self)
        eventsTableView.registerDequeueable(PrepareEventTableViewFooterView.self)
        setupUI()
    }

    @IBAction func didTapClose(_ sender: Any) {
        delegate?.didTapClose(viewController: self)
    }

    @IBAction func didTapSavePreparation(_ sender: Any) {
        delegate?.didTapSavePrepToDevice(viewController: self)
    }

    // MARK: - Private

    private func setupUI() {
        var upcomingEventTitle = R.string.localized.preparePrepareEventsUpcomingEvents()
        if self.viewModel.availableCalendarCount == 0 && self.viewModel.eventCount > 0 {
            upcomingEventTitle = R.string.localized.preparePrepareEventsUpcomingEventsNoSynchronisableCalendars()
        } else if self.viewModel.availableCalendarCount > 0 && self.viewModel.eventCount == 0 {
            upcomingEventTitle = R.string.localized.preparePrepareEventsNoUpcomingEventsSynchronisableCalendar()
        } else if self.viewModel.availableCalendarCount == 0 && self.viewModel.eventCount == 0 {
            upcomingEventTitle = R.string.localized.preparePrepareEventsNoSynchronisableCalendars()
        }
        upcomingEventsTitleLabel.addCharactersSpacing(spacing: 2, text: upcomingEventTitle, uppercased: true)
        yourDeviceTitleLabel.addCharactersSpacing(spacing: 2, text: R.string.localized.preparePrepareEventsYourDevice(), uppercased: true)
        viewTitleLabel.addCharactersSpacing(spacing: 1, text: R.string.localized.preparePrepareEventsAddPreparation(), uppercased: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PrepareEventsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.eventCount
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareEventsUpcomingTripTableViewCell = tableView.dequeueCell(for: indexPath)
        let event = viewModel.event(index: indexPath.row)
        cell.setup(event: event)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: PrepareEventTableViewFooterView = tableView.dequeueHeaderFooter()

        let footerTitle = self.viewModel.availableCalendarCount > 0 ?
            R.string.localized.preparePrepareEventsAddNewEvent() : R.string.localized.preparePrepareEventsSyncCalendarEvents()
        footer.setup(title: footerTitle, delegate: self)
        return footer
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        delegate?.didTapEvent(event: viewModel.event(index: indexPath.row), viewController: self)
    }
}

// MARK: - PrepareEventTableViewFooterViewDelegate

extension PrepareEventsViewController: PrepareEventTableViewFooterViewDelegate {

    func didTapAddNewTrip() {
        if self.viewModel.availableCalendarCount > 0 {
            delegate?.didTapAddNewTrip(viewController: self)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                AppDelegate.current.appCoordinator.navigateToCalendarSettings(AppCoordinator.Router.Destination(preferences: .calendarSync))
            })
        }
    }
}
