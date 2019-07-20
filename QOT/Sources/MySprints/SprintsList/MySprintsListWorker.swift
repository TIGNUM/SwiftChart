//
//  MySprintsListWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MySprintsListWorker {

    // MARK: - Properties
    private let service = qot_dal.UserService.main
    private var storages = [QDMSprint]()

    // MARK: - Init

    init() {

    }

    // FIXME: Translate strings
    // MARK: Texts
    lazy var title: String = {
        return "MY SPRINTS"
    }()

    lazy var editingTitle: String = {
        return "EDIT SPRINTS"
    }()

    lazy var sprintPlanHeader: String = {
        return "SPRINT PLAN"
    }()

    lazy var completeHeader: String = {
       return "COMPLETE"
    }()

    lazy var cancelTitle: String = {
        return "Cancel"
    }()

    lazy var removeTitle: String = {
        return "Remove"
    }()

    lazy var continueTitle: String = {
        return "Yes, continue"
    }()

    lazy var saveTitle: String = {
        return "Done"
    }()

    lazy var removeItemsAlertTitle: String = {
        return "REMOVE SELECTED ITEMS"
    }()

    lazy var removeItemsAlertMessage: NSAttributedString = {
        return NSAttributedString(string:
            "Are you sure you want to remove the selected items from your Sprints?")
    }()

    lazy var emptyContentAlertTitle: String = {
        return "YOUR CREATED SPRINTS WILL APPEAR HERE"
    }()

    lazy var emptyContentAlertMessage: NSAttributedString = {
        return NSAttributedString(string: "In the Coach area, “Plan a Sprint”. Your saved ones will appear here.")
    }()

    lazy var statusActive: String = {
        return "Active"
    }()

    lazy var statusUpcoming: String = {
        return "Upcoming"
    }()

    lazy var statusPaused: String = {
        return "Paused"
    }()

    lazy var statusCompleted: String = {
        return "Completed at"
    }()

    func loadData(_ completion: @escaping (_ initiated: Bool, _ sprints: [QDMSprint]) -> Void) {
        service.getSprints { (sprints, initiated, error) in
            completion(initiated, sprints ?? [])
        }
    }

    func save(sprints: [QDMSprint], _ completion: @escaping ([QDMSprint]?, Error?) -> Void) {
        service.updateSprints(sprints, completion)
    }

    func remove(sprints: [QDMSprint], _ completion: @escaping (Error?) -> Void) {
        service.deleteSprints(sprints, completion)
    }
}
