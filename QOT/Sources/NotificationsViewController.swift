//
//  ScheduledNotificationsTableViewController.swift
//  QOT
//
//  Created by karmic on 10.01.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import UserNotifications
import Anchorage

final class NotificationsViewController: UITableViewController {

    private var pendingNotifications: [UNNotificationRequest] = []
    var realmProvider: RealmProvider?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .black
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getPendingNotifications()
    }

    private func getPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [unowned self] (requests) in
            self.pendingNotifications = requests
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingNotifications.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduledNotificationTableViewCell_ID",
                                                 for: indexPath) as? ScheduledNotificationTableViewCell
        let notification = pendingNotifications[indexPath.row]
        let displayDate = notification.nextTriggerDate().map { String(describing: $0) } ?? "No Date"
        cell?.configure(title: notification.content.title, subtitle: displayDate)

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let componants: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let triggerComponants = Calendar.current.dateComponents(componants, from: Date().addingTimeInterval(20))
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponants, repeats: false)

        let existingNotification = pendingNotifications[indexPath.row]
        let newNotification = UNNotificationRequest(identifier: existingNotification.identifier,
                                                    content: existingNotification.content,
                                                    trigger: trigger)
        UNUserNotificationCenter.current().add(newNotification) { (error) in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }

    func trigger(_ issueDate: Date) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: issueDate)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                             repeats: false)
    }
}
