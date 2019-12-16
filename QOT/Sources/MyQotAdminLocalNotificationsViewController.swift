//
//  MyQotAdminLocalNotificationsViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 13/12/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit
import qot_dal

final class MyQotAdminLocalNotificationsViewController: BaseViewController {
    // MARK: - Properties
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    var datasource: [String: String] = ["qot://daily-brief": "Daily brief",
                                        "qot://daily-brief?bucketName=WEATHER": "Weather",
                                        "qot://daily-brief?bucketName=LATEST_WHATS_HOT": "Whats Hot",
                                        "qot://daily-brief?bucketName=MY_PEAK_PERFORMANCE": "Peak performance",
                                        "qot://daily-brief?bucketName=SPRINT_CHALLENGE": "Sprint Challenge",
                                        "qot://content-item?contentItemId=101440": "pdf",
                                        "qot://content-item?contentItemId=100104": "video",
                                        "qot://content-item?contentItemId=100242": "audio",
                                        "qot://know-feed": "Open know feed screen",
                                        "qot://my-qot": "Open my qot screen",
                                        "qot://coach-mode": "Open coach mode screen",
                                        "qot://my-data": "Open My Data screen",
                                        "qot://create-solve-a-challenge": "Open creating solve a challenge screen",
                                        "qot://plan-a-sprint": "Open creating a sprint screen",
                                        "qot://tools": "Open tools main screen",
                                        "qot://siri-shortcuts": "Open siri setting screen",
                                        "qot://my-preparations": "Open my preparations screen",
                                        "qot://prepare-event": "Open prepare for a event screen",
                                        "qot://preparation": "Open specific preparation with QDMUserPreparation's local id",
                                        "qot://to-be-vision": "Open my to be vision screen",
                                        "qot://my-sprints": "Open my sprints screen",
                                        "qot://my-library": "Open my library screen",
                                        "qot://my-profile": "Open my profile screen",
                                        "qot://account-settings": "Open account settings",
                                        "qot://app-settings": "Open app settings screen",
                                        "qot://synced-calendars": "Open synced calendars setting screen",
                                        "qot://activity-trackers": "Open activity trackers setting screen",
                                        "qot://daily-check-in": "Open daily check in screen",
                                        "qot://latest-whats-hot-article": "Latest whats hot article",
                                        "qot://support": "Open support screen",
                                        "qot://tutorial": "Open tutorial screen",
                                        "qot://faq": "FAQ screen",
                                        "qot://about-tignum": "Open about tignum screen",
                                        "qot://qot-benefits": "Open qot benefits screen",
                                        "qot://about-tignum-detail": "Open about tignum content screen",
                                        "qot://privacy": "Open privacy screen",
                                        "qot://terms-and-conditions": "Open terms and conditions screen",
                                        "qot://content-copyrights": "Open content copyrights screen",
                                        "qot://performance-foundation": "Performance foundation",
                                        "qot://performance-habituation": "Performance habituation",
                                        "qot://performance-recovery": "Performance recovery",
                                        "qot://performance-nutrition": "Performance nutrition",
                                        "qot://performance-movement": "Performance movement",
                                        "qot://performance-mindset": "Performance mindset",
                                        "qot://random-content?contentId=100035": "Random content",
                                        "qot://qrcode-open-0001": "QRCode 1",
                                        "qot://qrcode-open-0002": "QRCode 2",
                                        "qot://qrcode-open-0003": "QRCode 3",
                                        "qot://qrcode-open-0004": "QRCode 4"]

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView)
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ThemeView.level2.apply(UIApplication.shared.statusBarView ?? UIView())
        tableView.reloadData()
    }
}
    // MARK: - Private
private extension MyQotAdminLocalNotificationsViewController {
    func setupTableView() {
        ThemeView.level2.apply(view)
        ThemeView.level2.apply(tableView)
        ThemeView.level2.apply(headerView)
        tableView.registerDequeueable(MyQotProfileOptionsTableViewCell.self)
        ThemeView.level2.apply(self.view)
        baseHeaderView?.configure(title: "LOCAL NOTIFICATION TRIGGER", subtitle: nil)
        headerViewHeightConstraint.constant = baseHeaderView?.calculateHeight(for: headerView.frame.size.width) ?? 0

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView.headerView(with: .level2)
        tableView.reloadData()
    }
}
    // MARK: - TableView Delegate and Datasource

extension MyQotAdminLocalNotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyQotProfileOptionsTableViewCell = tableView.dequeueCell(for: indexPath)
        let titles = [String](datasource.values)
        let subtitles = [String](datasource.keys)
        cell.configure(title: titles[indexPath.row], subtitle: subtitles[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let titles = [String](datasource.values)
        let subtitles = [String](datasource.keys)
        scheduleNotification(title: "TEST DEBUG TRIGGER NOTIFICATION",
                             body: titles[indexPath.row],
                             link: subtitles[indexPath.row]) { [weak self] in
                                DispatchQueue.main.async {
                                    self?.navigationController?.popViewController(animated: true)
                                }
        }
    }

    func scheduleNotification(title: String, body: String, link: String, completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (deliveredNotifications) in
                    for deliveredNotification in deliveredNotifications where deliveredNotification.request.content.link() == link {
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [deliveredNotification.request.identifier])
                    }
                    let triggerDate = Date().addingTimeInterval(10)
                    let type = "DEBUG_TEST:\(triggerDate):\(link)"
                    // if it's valid sprint notification for today
                    let content = UNMutableNotificationContent(title: title,
                                                               body: body,
                                                               soundName: "QotNotification.aiff",
                                                               link: link)
                    let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
                    let identifier = QDMGuideItemNotification.notificationIdentifier(with: type,
                                                                                    date: triggerDate,
                                                                                    link: link)
                    UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)) { (_) in
                        completionHandler()
                    }
                })
            default: break
            }
        }
    }
}
