//
//  ExtensionsDataManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 13/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum ExtensionDataType {
    case toBeVision
    case upcomingEvent
    case all
}

final class ExtensionsDataManager {

    // MARK: - Init

    init() {
    }

    // MARK: - Update cases

    func update(_ dataType: ExtensionDataType) {
        switch dataType {
        case .toBeVision:
            updateToBeVision()
        case .upcomingEvent:
            updateUpcomingEvents()
        case .all:
            updateAll()
        }
    }

    static func didUserLogIn(_ isLogedIn: Bool) {
        ExtensionUserDefaults.setIsUserSignedIn(value: isLogedIn)
        if UserDefault.myDataSelectedItems.object as? [Int] == nil {
            let standardPreselectedValues: [MyDataParameter] = [.fiveDIR, .fiveDRR]
            let rawValues = standardPreselectedValues.map{$0.rawValue}
            UserDefault.myDataSelectedItems.setObject(rawValues)
        }
    }
}

// MARK: - Private

private extension ExtensionsDataManager {

    func updateToBeVision() {
        qot_dal.UserService.main.getMyToBeVision {(vision, status, error) in
            let sharedVision = ExtensionModel.ToBeVision(headline: vision?.headline,
                                                         text: vision?.text,
                                                         imageURL: vision?.profileImageResource?.url())
            ExtensionUserDefaults.set(sharedVision, for: .toBeVision)
        }
    }

    func updateUpcomingEvents() {
        qot_dal.UserService.main.getUserPreparations { (preparations, initiated, error) in
            guard let preparations = preparations, error == nil else {
                return
            }

            let events = preparations.filter { $0.eventDate != nil && $0.eventDate?.isPast() == false }
                .sorted { $0.eventDate ?? Date() < $1.eventDate ?? Date() }
                .map { preparation in
                    return ExtensionModel.UpcomingEvent(localID: preparation.qotId!,
                                                        eventName: preparation.eventTitle!,
                                                        startDate: preparation.eventDate ?? Date(),
                                                        endDate: Date(),
                                                        numberOfTasks: 0,
                                                        tasksCompleted: 0) }
            ExtensionUserDefaults.set(events, for: .upcomingEvents)

        }
    }

    func updateAll() {
        updateToBeVision()
        updateUpcomingEvents()
    }
}
