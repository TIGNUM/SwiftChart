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

    func getToBeVisionSubtitle(_ completion: @escaping (String?) -> Void)
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

    func getToBeVisionSubtitle(_ completion: @escaping (String?) -> Void) {
        UserService.main.getMyToBeVision { (toBeVision, _, _) in
            let date = toBeVision?.modifiedAt ?? toBeVision?.createdAt
            let since = Int(self.timeElapsed(date: date).rounded())
            let key: AppTextKey = since >= 3 ? .my_qot_section_my_tbv_subtitle_more_than : .my_qot_section_my_tbv_subtitle_less_than_3_months
            let subTitle = AppTextService.get(key)
            completion(subTitle)
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
}

//    func getBodyElements(isTeam: Bool, _ completion: @escaping ([MyX.Item]) -> Void) {
//        let items = MyX.Section.items(isTeam).compactMap { (element) -> MyX.Item in
//            return MyX.Item(title: element.title, subtitle: "")
//        }
//        completion([])
//    }

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

//    func getItem(at indexPath: IndexPath) -> MyX.Item? {
//        return MyX.Item.items(selectdTeamId != nil).at(index: indexPath.row)
//    }
//
//
//    func getSettingsTitle(_ completion: @escaping (String) -> Void) {
//        UserService.main.getUserData { (user) in
//            completion(String(user?.givenName.first ?? "X"))
//        }
//    }
//
//    func getCurrentSprintName(_ completion: @escaping (String?) -> Void) {
//        UserService.main.getSprints { (sprints, _, _) in
//            completion(sprints?.filter { $0.isInProgress == true }.first?.title)
//        }
//    }
//
//    func getImpactReadinessScore(_ completion: @escaping (Int?) -> Void) {
//        MyDataService.main.getDailyCheckInResults(from: nil, to: nil) { (result, _, _) in
//            completion(Int(result?.last?.impactReadiness ?? 0.0))
//        }
//    }
//
//    func toBeVisionDate(_ completion: @escaping (Date?) -> Void) {
//        UserService.main.getMyToBeVision {(toBeVision, _, _) in
//            completion(toBeVision?.modifiedAt ?? toBeVision?.createdAt)
//        }
//    }
//
//    func getSubtitles(_ completion: @escaping ([String]) -> Void) {
//        ContentService.main.getContentCategory(.myQOT) { (category) in
//            let subtitles = category?.contentCollections.at(index: 1)?.contentItems.compactMap { (item) -> String in
//                return item.valueText
//            } ?? []
//            completion(subtitles)
//        }
//    }
//
//
//    func createMyData(irScore: Int?) -> MyX.Item {
//        let subtitle = String(irScore ?? 0) + AppTextService.get(.my_qot_section_my_data_subtitle)
//        return getItem(in: .data, subTitle: subtitle)
//    }
//
//    func createToBeVision(date: Date?) -> MyX.Item {
//        guard date != nil else {
//            return getItem(in: .toBeVision)
//        }
//        let since = Int(timeElapsed(date: date).rounded())
//        let key: AppTextKey = since >= 3 ? .my_qot_section_my_tbv_subtitle_more_than : .my_qot_section_my_tbv_subtitle_less_than_3_months
//        return getItem(in: .toBeVision, subTitle: AppTextService.get(key))
//    }
//
//    func createPreps(dateString: String?, eventType: String?) -> MyX.Item {
//        var subtitle = ""
//        if let dateString = dateString, let eventType = eventType {
//            subtitle = dateString + " " + eventType
//        }
//        return getItem(in: .preps, subTitle: subtitle)
//    }
//
//        private func getPersonalParams() {
//            var readinessScore = 0
//            var visionDate: Date?
//            var nextPrepDateString: String?
//            var nextPrepType: String?
//            var currentSprintName: String?
//
//            let dispatchGroup = DispatchGroup()
//            dispatchGroup.enter()
//            getImpactReadinessScore { (score) in
//                readinessScore = score ?? 0
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            toBeVisionDate { (date) in
//                visionDate = date
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            nextPrep { (dateString) in
//                nextPrepDateString = dateString
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            nextPrepType { (eventType) in
//                nextPrepType = eventType
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.enter()
//            getCurrentSprintName { (sprintName) in
//                currentSprintName = sprintName
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.notify(queue: .main) { in
//                var bodyItems: [MyX.Item] = []
//                let teamCreateSubtitle = AppTextService.get(.my_x_team_create_description)
//
//                if let teamItem = getItem(in: .teamCreate, subTitle: teamCreateSubtitle),
//                    let libraryItem = getItem(in: .library),
//                    let prepItem = createPreps(dateString: nextPrepDateString, eventType: nextPrepType),
//                    let sprintItem = getItem(in: .sprints, subTitle: currentSprintName ?? ""),
//                    let dataItem = createMyData(irScore: readinessScore),
//                    let visionItem = createToBeVision(date: visionDate) {
//
//                    bodyItems.append(teamItem)
//                      bodyItems.append(libraryItem)
//                      bodyItems.append(prepItem)
//                      bodyItems.append(sprintItem)
//                      bodyItems.append(dataItem)
//                      bodyItems.append(visionItem)
//
//                      let sections: ArraySectionMyX = [ArraySection(model: .body, elements: bodyItems)]
//                      sections.append(ArraySection(model: .teamHeader, elements: []))
//                      sections.append(ArraySection(model: .body, elements: bodyItems))
//                      let changeSet = StagedChangeset(source: strongSelf.arraySectionMyX, target: sections)
//                      presenter.updateView(changeSet)
//                      presenter.reload()
//                }
//            }
//        }
//}
