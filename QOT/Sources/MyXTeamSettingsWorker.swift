//
//  MyXTeamSettingsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamSettingsWorker {

    // MARK: - Properties
    private let contentService: qot_dal.ContentService

    // MARK: - Init
    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    func settings() -> MyXTeamSettingsModel {
        return MyXTeamSettingsModel(contentService: contentService)
    }
}

extension MyXTeamSettingsWorker {

    var teamSettingsText: String {
        return AppTextService.get(.settings_team_settings_title)
    }
}
