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
    private let services: Services
    private lazy var firstInstallTimeStamp: Date? = {
        return UserDefault.firstInstallationTimestamp.object as? Date
    }()

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

// MARK: - functions

    func myQotSections() -> MyQotViewModel {
        let myQotItems =  MyQotSection.allCases.map {
            return MyQotViewModel.Item(myQotSections: $0,
                                   title: services.contentService.myQotSectionTitles(for: $0),
                                   subtitle: "temp")}
        return MyQotViewModel(myQotItems: myQotItems)
    }

    func nextPrep(completion: @escaping (String?) -> Void) {
        userService.getUserPreparations { [weak self] (preparations, initialized, error) in
            let dateString = preparations?.last?.eventDate != nil ? DateFormatter.myPrepsTime.string(from: preparations!.last!.eventDate!) : ""
            completion(dateString)
        }
    }

    func nextPrepType(completion: @escaping (String?) -> Void) {
         userService.getUserPreparations { [weak self] (preparations, initialized, error) in
            let eventType = preparations?.last?.eventType ?? ""
            completion(eventType)
        }
    }

    func toBeVisionDate(completion: @escaping (Date?) -> Void) {
        userService.getMyToBeVision { [weak self] (toBeVision, initialized, error) in
            completion(toBeVision?.modifiedAt ?? toBeVision?.createdAt)
        }
    }
}
