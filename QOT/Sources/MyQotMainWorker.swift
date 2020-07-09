//
//  MyQotMainWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotMainWorker: WorkerTeam {

    private lazy var myQot: MyQot = {
        let myQotItems = MyQotSection.allCases.map {
            return MyQot.Item(sections: $0, title: $0.title)}
        return MyQot(items: myQotItems)
    }()

    func getMyQotItem(in section: MyQotSection, subTitle: String = "") -> MyQot.Item {
        var item = myQot.items[section.rawValue]
        item.subtitle = subTitle
        return myQot.items[section.rawValue]
    }

    func nextPrep(completion: @escaping (String?) -> Void) {
        UserService.main.getUserPreparations { (preparations, _, _) in
            let dateString = preparations?.last?.eventDate?.eventDateString
            completion(dateString)
        }
    }

    func nextPrepType(completion: @escaping (String?) -> Void) {
         UserService.main.getUserPreparations { (preparations, _, _) in
            completion(preparations?.last?.eventType)
        }
    }

    func getSettingsTitle(completion: @escaping (String?) -> Void) {
        UserService.main.getUserData { (user) in
            completion(String(user?.givenName.first ?? "X"))
        }
    }

    func getCurrentSprintName(completion: @escaping (String?) -> Void) {
        UserService.main.getSprints { (sprints, _, _) in
            completion(sprints?.filter { $0.isInProgress == true }.first?.title)
        }
    }

    func getImpactReadinessScore(completion: @escaping (Int?) -> Void) {
        MyDataService.main.getDailyCheckInResults(from: nil, to: nil) { (result, _, _) in
            completion(Int(result?.last?.impactReadiness ?? 0.0))
        }
    }

    func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        UserService.main.getMyToBeVision {(toBeVision, _, _) in
            completion(toBeVision?.modifiedAt ?? toBeVision?.createdAt)
        }
    }

    func getSubtitles(completion: @escaping ([String]) -> Void) {
        ContentService.main.getContentCategory(.myQOT) { (category) in
            let subtitles = category?.contentCollections.at(index: 1)?.contentItems.compactMap { (item) -> String in
                return item.valueText
            } ?? []
            completion(subtitles)
        }
    }
}
