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

    func getToBeVisionSubtitle(team: QDMTeam?, _ completion: @escaping (String?) -> Void)

    func getToBeVisionData(item: MyX.Item,
                           teamItem: Team.Item?, _ completion: @escaping (String, QDMTeamToBeVisionPoll?) -> Void)
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

    func getToBeVisionSubtitle(team: QDMTeam?, _ completion: @escaping (String?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var subtitle: String?

        if let team = team {
            dispatchGroup.enter()
            getTeamToBeVision(for: team) { (qdmTeamTBV) in
                if qdmTeamTBV == nil && !team.thisUserIsOwner {
                    subtitle = AppTextService.get(.my_x_team_tbv_not_created)
                } else {
                    subtitle = self.makeToBeVisionSubtitle(teamToBeVision: qdmTeamTBV)
                }
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            getCurrentTeamToBeVisionPoll(for: team) { (poll) in
                if let poll = poll {
                    let days = Date().daysTo(poll.endDate)
                    subtitle = self.getTeamTBVPollRemainingDays(days).string
                }
                dispatchGroup.leave()
            }
        } else {
            dispatchGroup.enter()
            UserService.main.getMyToBeVision { (toBeVision, _, _) in
                subtitle = self.makeToBeVisionSubtitle(toBeVision: toBeVision)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(subtitle)
        }
    }

    func getTeamLibrarySubtitleAndCount(team: QDMTeam?, _ completion: @escaping (String?, Int) -> Void) {
        guard let team = team else {
            DispatchQueue.main.async { completion(nil, 0) }
            return
        }
        TeamService.main.teamNewsFeeds(for: team, type: .STORAGE_ADDED, onlyUnread: true) { (feeds, _, _) in
            guard let feeds = feeds, feeds.count > 0 else {
                DispatchQueue.main.async { completion(nil, 0) }
                return
            }
            let latestDay = feeds.compactMap({ $0.createdAt }).sorted().last ?? Date()
            let daysCount = abs(latestDay.daysTo())
            var daysString: String
            switch daysCount {
            case 0:
                daysString = AppTextService.get(.my_qot_section_team_library_subtitle_added_today)
            case 1:
                daysString = AppTextService.get(.my_qot_section_team_library_subtitle_added_yesterday)
            default:
                daysString = AppTextService.get(.my_qot_section_team_library_subtitle_added_days_ago)
            }
            daysString = daysString.replacingOccurrences(of: "${DAYS}", with: "\(daysCount)")
            var countString: String
            switch feeds.count {
            case 1:
                countString = AppTextService.get(.my_qot_section_team_library_subtitle_single_item)
            default:
                countString = AppTextService.get(.my_qot_section_team_library_subtitle_multiple_items)
            }
            countString = countString.replacingOccurrences(of: "${ITEM_COUNT}", with: "\(feeds.count)")
            completion("\(countString)\n\(daysString)", feeds.count)
        }
    }

    func getToBeVisionData(item: MyX.Item,
                           teamItem: Team.Item?, _ completion: @escaping (String, QDMTeamToBeVisionPoll?) -> Void) {
        guard let team = teamItem?.qdmTeam, team.name != nil else {
            completion("", nil)
            return
        }

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        var tmpHasOwnerEmptyTeamTBV = true
        hasOwnerEmptyTeamTBV(for: team) { (isEmpty) in
            tmpHasOwnerEmptyTeamTBV = isEmpty
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        var tmpPoll: QDMTeamToBeVisionPoll?
        getCurrentTeamToBeVisionPoll(for: team) { (poll) in
            tmpPoll = poll
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            if tmpPoll != nil {
                completion(item.title(isTeam: true, isPollInProgress: true), tmpPoll)
            } else if tmpHasOwnerEmptyTeamTBV == true {
                completion(AppTextService.get(.myx_team_tbv_empty_subtitle_vision), tmpPoll)
            } else {
                completion(item.title(isTeam: true, isPollInProgress: false), tmpPoll)
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

    func makeToBeVisionSubtitle(toBeVision: QDMToBeVision? = nil,
                                teamToBeVision: QDMTeamToBeVision? = nil) -> String? {
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

    func hasOwnerEmptyTeamTBV(for team: QDMTeam?, _ completion: @escaping (Bool) -> Void) {
        if team?.thisUserIsOwner == true, let team = team {
            getTeamToBeVision(for: team) { (teamVision) in
                completion(teamVision == nil)
            }
        } else {
            completion(false)
        }
    }
}
