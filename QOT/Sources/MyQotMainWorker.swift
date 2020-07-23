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

    func getBodyElements( _ completion: @escaping (MyX) -> Void) {
        let items = MyX.Element.allCases.compactMap { (element) -> MyX.Item in
            return MyX.Item(element: element, title: element.title, subtitle: "")
        }
        completion(MyX(items: items))
    }

    func getTeamItems(_ completion: @escaping (MyX) -> Void) {
        getTeams { [weak self] (teams) in
            self?.getTeamInvitations { (invites) in
                var items = [Team.Item]()
                if !invites.isEmpty {
                    items.append(Team.Item(invites: invites))
                }
                items.append(contentsOf: teams.compactMap { (team) -> Team.Item in
                    return Team.Item(title: team.name ?? "",
                                     teamId: team.qotId ?? "",
                                     color: team.teamColor ?? "")
                })
                completion(MyX(teamHeaderItems: items))
            }
        }
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

    func getSettingsTitle(completion: @escaping (String) -> Void) {
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
