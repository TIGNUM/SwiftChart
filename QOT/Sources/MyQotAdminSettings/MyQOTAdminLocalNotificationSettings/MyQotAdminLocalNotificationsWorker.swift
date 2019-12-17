//
//  MyQotAdminLocalNotificationsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminLocalNotificationsWorker {

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
    // MARK: - Init
    init() { /**/ }
}
