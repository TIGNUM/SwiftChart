//
//  MyDataExplanationWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyDataExplanationWorker {

    // MARK: - Properties
    private let contentService: qot_dal.ContentService

    // MARK: - Init
    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }
}

extension MyDataExplanationWorker: MyDataExplanationWorkerInterface {
    func myDataExplanationSections() -> MyDataExplanationModel {
        return MyDataExplanationModel(myDataExplanationItems: MyDataParameter.allCases.map {
            return MyDataExplanationModel.ExplanationItem(myDataExplanationSection: $0,
                                                          title: ScreenTitleService.main.myDataExplanationSectionTitles(for: $0),
                                                          subtitle: ScreenTitleService.main.myDataExplanationSectionSubtitles(for: $0))
        })
    }

    func myDataExplanationHeaderTitle() -> String {
        return ScreenTitleService.main.myDataSectionTitle(for: .dailyImpact) ?? ""
    }
}
