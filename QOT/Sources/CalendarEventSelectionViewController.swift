//
//  CalendarEventSelectionViewController.swift
//  QOT
//
//  Created by karmic on 06.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import EventKitUI
import EventKit

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

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return [roundedBarButtonItem(title: "Add new event",//interactor.rightBarItemTitle,
                                     buttonWidth: .AddNewEvent,
                                     action: #selector(addNewEvent))]
    }
}

// MARK: - Private
private extension CalendarEventSelectionViewController {

}

// MARK: - Actions
private extension CalendarEventSelectionViewController {
   @objc func addNewEvent() {
        router.presentEditEventController(interactor.getCalendarIds())
    }
}

// MARK: - CalendarEventSelectionViewControllerInterface
extension CalendarEventSelectionViewController: CalendarEventSelectionViewControllerInterface {
    func setupView() {
        tableView.registerDequeueable(PrepareEventTableViewCell.self)
        view.fill(subview: tableView)
        tableView.backgroundColor = .sand
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = 64
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.didSelectPreparationEvent(at: indexPath.row)
        router.dismiss()
    }
}

// MARK: - EKEventEditViewDelegate
extension CalendarEventSelectionViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController,
                                 didCompleteWith action: EKEventEditViewAction) {
        switch action {
        case .canceled,
             .deleted:
            controller.dismiss(animated: true)
        case .saved:
            DispatchQueue.main.async { [weak self] in
                self?.router.dismiss()
                //                self?.interactor.setCreatedCalendarEvent(controller.event) { [weak self] (success) in65
                //                    controller.dismiss(animated: true) { [weak self] in
                //                        if success {
                //                            self?.router.dismiss()
                //                        } else {
                //                            self?.showAlert(type: .calendarNotSynced)
                //                        }
                //                    }
            }
        }
    }
}
