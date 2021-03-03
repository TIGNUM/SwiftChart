//
//  MyQotAdminLocalNotificationsInteractor.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotAdminLocalNotificationsInteractor {

    // MARK: - Properties
    private lazy var worker = MyQotAdminLocalNotificationsWorker()
    private let presenter: MyQotAdminLocalNotificationsPresenterInterface!

    // MARK: - Init
    init(presenter: MyQotAdminLocalNotificationsPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAdminLocalNotificationsInterface
extension MyQotAdminLocalNotificationsInteractor: MyQotAdminLocalNotificationsInteractorInterface {
    func getHeaderTitle() -> String {
        return "LOCAL NOTIFICATION TRIGGER"
    }

    func getNotificationTitle() -> String {
        return "TEST DEBUG TRIGGER NOTIFICATION"
    }

    func getTitle(at index: Int) -> String {
        let titles = [String](worker.datasource.values)
        return titles[index]
    }

    func getSubtitle(at index: Int) -> String {
        let subtitles = [String](worker.datasource.keys)
        return subtitles[index]
    }

    func getDatasourceCount() -> Int {
        return worker.datasource.count
    }

    func scheduleNotification(title: String,
                              body: String,
                              link: String,
                              completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                UNUserNotificationCenter.current().getDeliveredNotifications(completionHandler: { (deliveredNotifications) in
                    for deliveredNotification in deliveredNotifications where deliveredNotification.request.content.link() == link {
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [deliveredNotification.request.identifier])
                    }
                    let triggerDate = Date().addingTimeInterval(20)
                    // if it's valid sprint notification for today
                    let content = UNMutableNotificationContent(title: title,
                                                               body: body,
                                                               soundName: Notification.soundName,
                                                               link: link)
                    let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
                    let identifier = QDMGuideItemNotification.notificationIdentifier(with: DEBUG_LOCAL_NOTIFICATION_IDENTIFIER,
                                                                                    date: triggerDate,
                                                                                    link: link)
                    UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: identifier,
                                                                                 content: content,
                                                                                 trigger: trigger)) { (_) in
                        completionHandler()
                    }
                })
            default: break
            }
        }
    }
}
