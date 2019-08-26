//
//  MyQotMainWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotMainWorker {

    // MARK: - Properties

    private let userService = qot_dal.UserService.main
    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    // MARK: - Init

    init() {
    }

// MARK: - functions

    func myQotSections() -> MyQotViewModel {
        let myQotItems =  MyQotSection.allCases.map {
            return MyQotViewModel.Item(myQotSections: $0,
                                   title: ScreenTitleService.main.myQotSectionTitles(for: $0),
                                   subtitle: "temp")}
        return MyQotViewModel(myQotItems: myQotItems)
    }

    func nextPrep(completion: @escaping (String?) -> Void) {
        userService.getUserPreparations {(preparations, initialized, error) in
            let dateString = preparations?.last?.eventDate?.eventDateString
            completion(dateString)
        }
    }

    func nextPrepType(completion: @escaping (String?) -> Void) {
         userService.getUserPreparations {(preparations, initialized, error) in
            let eventType = preparations?.last?.eventType ?? ""
            completion(eventType)
        }
    }

    func getUserName(completion: @escaping (String?) -> Void) {
          qot_dal.UserService.main.getUserData { (user) in
            completion(user?.givenName)
        }
    }

    func getImpactReadinessScore(completion: @escaping(Double?) -> Void) {
        qot_dal.MyDataService.main.getDailyCheckInResults(from: nil, to: nil, {(result, initialized, error) in
            let score = result?.last?.impactReadiness
            completion(score)
        })
    }

    func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        userService.getMyToBeVision {(toBeVision, initialized, error) in
            completion(toBeVision?.modifiedAt ?? toBeVision?.createdAt)
        }
    }

    func getSubtitles(completion: @escaping ([String?]) -> Void) {
        var subtitles: [String?] = []
        qot_dal.ContentService.main.getContentCategory(.myQOT, {(category) in
            category?.contentCollections[1].contentItems.forEach {(items) in
                subtitles.append(items.valueText)
            }
            completion(subtitles)
        })
    }
}
