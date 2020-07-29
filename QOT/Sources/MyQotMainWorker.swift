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
    func getPreparationSubtitle(_ completion: @escaping (String?) -> Void)

    func getSettingsTitle(_ completion: @escaping (String) -> Void)

    func getCurrentSprintName(_ completion: @escaping (String?) -> Void)

    func getMyDataSubtitle(_ completion: @escaping (String?) -> Void)

    func getToBeVisionSubtitle(teamId: String?, _ completion: @escaping (String?) -> Void)
}

extension MyQotMainWorker {
    func getSettingsTitle(_ completion: @escaping (String) -> Void) {
        UserService.main.getUserData { (user) in
            completion(String(user?.givenName.first ?? "X"))
        }
    }

    func getPreparationSubtitle(_ completion: @escaping (String?) -> Void) {
        UserService.main.getUserPreparations { (preparations, _, _) in
            let dateString = preparations?.last?.eventDate?.eventDateString ?? ""
            let eventType = preparations?.last?.eventType ?? ""
            let subtitle = dateString + " " + eventType
            completion(subtitle)
        }
    }

    func getCurrentSprintName(_ completion: @escaping (String?) -> Void) {
        UserService.main.getSprints { (sprints, _, _) in
            completion(sprints?.filter { $0.isInProgress == true }.first?.title)
        }
    }

    func getMyDataSubtitle(_ completion: @escaping (String?) -> Void) {
        MyDataService.main.getDailyCheckInResults(from: nil, to: nil) { (result, _, _) in
            let score = Int(result?.last?.impactReadiness ?? 0.0)
            let subtitle = String(score) + AppTextService.get(.my_qot_section_my_data_subtitle)
            completion(subtitle)
        }
    }

    func getToBeVisionSubtitle(teamId: String?, _ completion: @escaping (String?) -> Void) {
        getSelectedTeam(teamId: teamId) { (team) in
            if let team = team {
                self.getTeamToBeVision(for: team) { (teamToBeVision) in
                    if teamToBeVision == nil && !team.thisUserIsOwner {
                        completion(AppTextService.get(.my_x_team_tbv_not_created))
                    } else {
                        completion(self.makeToBeVisionSubtitle(teamToBeVision: teamToBeVision))
                    }
                }
            } else {
                UserService.main.getMyToBeVision { (toBeVision, _, _) in
                    completion(self.makeToBeVisionSubtitle(toBeVision: toBeVision))
                }
            }
        }
    }
}

private extension MyQotMainWorker {
    func timeElapsed(date: Date?) -> Double {
        if let monthSince = date?.months(to: Date()), monthSince > 1 {
            return Double(monthSince)
        }
        return 0
    }

    func makeToBeVisionSubtitle(toBeVision: QDMToBeVision? = nil, teamToBeVision: QDMTeamToBeVision? = nil) -> String? {
        guard teamToBeVision != nil || toBeVision != nil else { return nil }

        var date: Date?
        if toBeVision != nil {
            date = toBeVision?.modifiedAt ?? toBeVision?.createdAt
        }
        if teamToBeVision != nil {
            date = teamToBeVision?.modifiedAt ?? teamToBeVision?.createdAt
        }

        let since = Int(self.timeElapsed(date: date).rounded())
        let key: AppTextKey = since >= 3 ? .my_qot_section_my_tbv_subtitle_more_than : .my_qot_section_my_tbv_subtitle_less_than_3_months
        let subTitle = AppTextService.get(key)
        return subTitle
    }
}
