//
//  MyQotMainWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyQotMainWorker: WorkerTeam {
    func getBodyElements(isTeam: Bool, _ completion: @escaping ([MyX.Item]) -> Void)

    func nextPrep(_ completion: @escaping (String?) -> Void)

    func nextPrepType(_ completion: @escaping (String?) -> Void)

    func getSettingsTitle(_ completion: @escaping (String) -> Void)

    func getCurrentSprintName(_ completion: @escaping (String?) -> Void)

    func getImpactReadinessScore(_ completion: @escaping (Int?) -> Void)

    func toBeVisionDate(_ completion: @escaping (Date?) -> Void)

    func getSubtitles(_ completion: @escaping ([String]) -> Void)
}

extension MyQotMainWorker {

    func getBodyElements(isTeam: Bool, _ completion: @escaping ([MyX.Item]) -> Void) {
//        let items = MyX.Section.items(isTeam).compactMap { (element) -> MyX.Item in
//            return MyX.Item(title: element.title, subtitle: "")
//        }
        completion([])
    }

//    func getTeamItems(_ completion: @escaping (MyX) -> Void) {
//        getTeams { [weak self] (teams) in
//            self?.getTeamInvitations { (invites) in
//                var items = [Team.Item]()
//                if !invites.isEmpty {
//                    items.append(Team.Item(invites: invites))
//                }
//                items.append(contentsOf: teams.compactMap { (team) -> Team.Item in
//                    return Team.Item(title: team.name ?? "",
//                                     teamId: team.qotId ?? "",
//                                     color: team.teamColor ?? "")
//                })
//                completion(MyX(teamHeaderItems: items))
//            }
//        }
//    }

    func nextPrep(_ completion: @escaping (String?) -> Void) {
        UserService.main.getUserPreparations { (preparations, _, _) in
            let dateString = preparations?.last?.eventDate?.eventDateString
            completion(dateString)
        }
    }

    func nextPrepType(_ completion: @escaping (String?) -> Void) {
         UserService.main.getUserPreparations { (preparations, _, _) in
            completion(preparations?.last?.eventType)
        }
    }

    func getSettingsTitle(_ completion: @escaping (String) -> Void) {
        UserService.main.getUserData { (user) in
            completion(String(user?.givenName.first ?? "X"))
        }
    }

    func getCurrentSprintName(_ completion: @escaping (String?) -> Void) {
        UserService.main.getSprints { (sprints, _, _) in
            completion(sprints?.filter { $0.isInProgress == true }.first?.title)
        }
    }

    func getImpactReadinessScore(_ completion: @escaping (Int?) -> Void) {
        MyDataService.main.getDailyCheckInResults(from: nil, to: nil) { (result, _, _) in
            completion(Int(result?.last?.impactReadiness ?? 0.0))
        }
    }

    func toBeVisionDate(_ completion: @escaping (Date?) -> Void) {
        UserService.main.getMyToBeVision {(toBeVision, _, _) in
            completion(toBeVision?.modifiedAt ?? toBeVision?.createdAt)
        }
    }

    func getSubtitles(_ completion: @escaping ([String]) -> Void) {
        ContentService.main.getContentCategory(.myQOT) { (category) in
            let subtitles = category?.contentCollections.at(index: 1)?.contentItems.compactMap { (item) -> String in
                return item.valueText
            } ?? []
            completion(subtitles)
        }
    }
}
