//
//  MyQotAdminLocalNotificationsWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminLocalNotificationsWorker {

    var datasource: [String: String] = [
                                        "tignumx://team-invitations": "Open pending Team invitations",
                                        "tignumx://tbv-tracker-poll-opened?teamId=100697": "Open Team Tracker Poll",
                                        "tignumx://tbv-tracker-closed?teamId=100697": "Open Team TBV Trends",
                                        "tignumx://tbv-generator-poll-opened?teamId=100697": "Open Team TBV Generator",
                                        "tignumx://tbv-generator-poll-closed?teamId=100697": "Open TeamTBV",
                                        "tignumx://daily-brief": "Daily brief",
                                        "tignumx://daily-brief?bucketName=WEATHER": "Weather",
                                        "tignumx://daily-brief?bucketName=LATEST_WHATS_HOT": "Whats Hot",
                                        "tignumx://daily-brief?bucketName=MY_PEAK_PERFORMANCE": "Peak performance",
                                        "tignumx://daily-brief?bucketName=SPRINT_CHALLENGE": "Sprint Challenge",
                                        "tignumx://content-item?contentItemId=101440": "pdf",
                                        "tignumx://content-item?contentItemId=100104": "video",
                                        "tignumx://content-item?contentItemId=100242": "audio",
                                        "tignumx://know-feed": "Open know feed screen",
                                        "tignumx://my-qot": "Open my qot screen",
                                        "tignumx://coach-mode": "Open coach mode screen",
                                        "tignumx://my-data": "Open My Data screen",
                                        "tignumx://create-solve-a-challenge": "Open creating solve a challenge screen",
                                        "tignumx://plan-a-sprint": "Open creating a sprint screen",
                                        "tignumx://tools": "Open tools main screen",
                                        "tignumx://siri-shortcuts": "Open siri setting screen",
                                        "tignumx://my-preparations": "Open my preparations screen",
                                        "tignumx://prepare-event": "Open prepare for a event screen",
                                        "tignumx://preparation": "Open specific preparation with QDMUserPreparation's local id",
                                        "tignumx://to-be-vision": "Open my to be vision screen",
                                        "tignumx://my-sprints": "Open my sprints screen",
                                        "tignumx://my-library": "Open my library screen",
                                        "tignumx://my-profile": "Open my profile screen",
                                        "tignumx://account-settings": "Open account settings",
                                        "tignumx://app-settings": "Open app settings screen",
                                        "tignumx://synced-calendars": "Open synced calendars setting screen",
                                        "tignumx://activity-trackers": "Open activity trackers setting screen",
                                        "tignumx://daily-check-in": "Open daily check in screen",
                                        "tignumx://latest-whats-hot-article": "Latest whats hot article",
                                        "tignumx://support": "Open support screen",
                                        "tignumx://tutorial": "Open tutorial screen",
                                        "tignumx://faq": "FAQ screen",
                                        "tignumx://about-tignum": "Open about tignum screen",
                                        "tignumx://qot-benefits": "Open qot benefits screen",
                                        "tignumx://about-tignum-detail": "Open about tignum content screen",
                                        "tignumx://privacy": "Open privacy screen",
                                        "tignumx://terms-and-conditions": "Open terms and conditions screen",
                                        "tignumx://content-copyrights": "Open content copyrights screen",
                                        "tignumx://performance-foundation": "Performance foundation",
                                        "tignumx://performance-habituation": "Performance habituation",
                                        "tignumx://performance-recovery": "Performance recovery",
                                        "tignumx://performance-nutrition": "Performance nutrition",
                                        "tignumx://performance-movement": "Performance movement",
                                        "tignumx://performance-mindset": "Performance mindset",
                                        "tignumx://random-content?contentId=100035": "Random content",
                                        "tignumx://qrcode-open-0001": "QRCode 1",
                                        "tignumx://qrcode-open-0002": "QRCode 2",
                                        "tignumx://qrcode-open-0003": "QRCode 3",
                                        "tignumx://qrcode-open-0004": "QRCode 4"]
    // MARK: - Init
    init() { /* */ }
}
