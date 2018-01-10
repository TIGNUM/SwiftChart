//
//  ScheduledNotificationsTableViewController.swift
//  QOT
//
//  Created by karmic on 10.01.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import UserNotifications

final class ScheduledNotificationsTableViewController: UITableViewController {

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
            self.tableView.reloadData()
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
        let trigger = (notification.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate()
        cell?.configure(title: notification.content.title,
                        subtitle: trigger?.description ?? "nextTriggerDate == nil")

        return cell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let realmProvider = realmProvider else { return }
        let notification = pendingNotifications[indexPath.row]
        let triggerDate = Date().addingTimeInterval(20)
        let localNotificationBuilder = LocalNotificationBuilder(realmProvider: realmProvider)
        localNotificationBuilder.updateNotification(identifier: notification.identifier,
                                                    triggerDate: triggerDate,
                                                    content: notification.content)
        tableView.reloadData()
    }

    func trigger(_ issueDate: Date) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                          from: issueDate)
        return UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                             repeats: false)
    }
}
