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
                                       title: myQOTTitle(for: $0),
                                   subtitle: "",
                                   showSubtitleInRed: false)}
        return MyQotViewModel(myQotItems: myQotItems)
    }

    func myQOTTitle(for section: MyQotSection) -> String {
        return myQotSectionTitles(for: section)
    }

    func myQotSectionTitles(for myQotItem: MyQotSection) -> String {
        switch myQotItem {
        case .profile:
            return AppTextService.get(AppTextKey.my_qot_my_library_my_profile_view_my_profile_title)
        case .library:
            return AppTextService.get(AppTextKey.my_qot_my_library_my_library_view_my_library_title)
        case .preps:
            return AppTextService.get(AppTextKey.my_qot_my_library_my_plans_view_my_plans_title)
        case .sprints:
            return AppTextService.get(AppTextKey.my_qot_my_library_my_sprints_view_my_sprints_title)
        case .data:
            return AppTextService.get(AppTextKey.my_qot_my_library_my_data_view_my_data_title)
        case .toBeVision:
            return AppTextService.get(AppTextKey.my_qot_my_library_my_tbv_view_my_tbv_title)
        }
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

    func getCurrentSprintName(completion: @escaping (String?) -> Void) {
        qot_dal.UserService.main.getSprints {(sprints, initialized, error) in
            let sprint = sprints?.filter { $0.isInProgress == true }.first
            completion(sprint?.title)
        }
    }

    func getImpactReadinessScore(completion: @escaping(Int?) -> Void) {
        qot_dal.MyDataService.main.getDailyCheckInResults(from: nil, to: nil, {(result, initialized, error) in
            let score = Int(result?.last?.impactReadiness ?? 0.0)
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
