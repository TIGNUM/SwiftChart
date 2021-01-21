//
//  MyVisionEditDetailsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionEditDetailsWorker {

    var visionPlaceholderDescription: String?
    var teamVisionPlaceHolderDescription: String?
    let isFromNullState: Bool
    let contentService: qot_dal.ContentService
    let originalTitle: String
    let originalVision: String
    let team: QDMTeam?
    private var myToBeVision: QDMToBeVision?
    private var teamToBeVision: QDMTeamToBeVision?
    private let widgetDataManager: ExtensionsDataManager

    init(title: String, vision: String, widgetManager: ExtensionsDataManager, contentService: qot_dal.ContentService, isFromNullState: Bool = false, team: QDMTeam?) {
        self.team = team
        originalTitle = title
        self.contentService = contentService
        originalVision = vision
        widgetDataManager = widgetManager
        self.isFromNullState = isFromNullState
        getMyToBeVision()
        getVisionDescription()
        getTeamToBeVision(for: team)
        getTeamVisionDescription()
    }

    var firstTimeUser: Bool {
        return myToBeVision == nil
    }

    var myVision: QDMToBeVision? {
        return myToBeVision
    }

    var teamVision: QDMTeamToBeVision? {
        return teamToBeVision
    }

    func getMyToBeVision() {
        UserService.main.getMyToBeVision({ [weak self] (vision, _, _) in
            self?.myToBeVision = vision
        })
    }

    func getTeamToBeVision(for team: QDMTeam?) {
        guard let team = team else { return }
        TeamService.main.getTeamToBevision(for: team, {[weak self] (teamVision, _, _) in
            self?.teamToBeVision = teamVision
        })
    }

    func updateMyToBeVision(_ toBeVision: QDMToBeVision, _ completion: @escaping (Error?) -> Void) {
        qot_dal.UserService.main.updateMyToBeVision(toBeVision) { error in
            self.updateWidget()
            completion(error)
        }
    }

    func updateTeamToBeVision(_ newVision: QDMTeamToBeVision, completion: @escaping ( Error?) -> Void) {
        TeamService.main.updateTeamToBevision(vision: newVision) { [weak self] _, error  in
            self?.getTeamToBeVision(for: self?.team)
            completion(error)
        }
    }

    func formatPlaceholder(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .lightGrey)
    }

    func format(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProDisplayLight(ofSize: 34) ,
                                  lineSpacing: 3,
                                  textColor: .white)
    }

    func formatPlaceholder(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .lightGrey)
    }

    func format(vision: String) -> NSAttributedString? {
        return NSAttributedString(string: vision,
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 10.0,
                                  textColor: .white)
    }

    func updateWidget() {
        widgetDataManager.update(.toBeVision)
    }

    private func getVisionDescription() {
        visionPlaceholderDescription = AppTextService.get(.my_qot_my_tbv_empty_subtitle_vision)
    }

    private func getTeamVisionDescription() {
        teamVisionPlaceHolderDescription = AppTextService.get(.myx_team_tbv_empty_subtitle_vision)
    }
}
