//
//  MyDataSelectionWorker.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyDataSelectionWorker {

    // MARK: - Properties
    private let contentService: qot_dal.ContentService

    // MARK: - Init
    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }
}

extension MyDataSelectionWorker: MyDataSelectionWorkerInterface {
    func myDataSelectionSections() -> MyDataSelectionModel {
        let selectedValues = UserDefault.myDataSelectedItems.object as? [Int]
        return MyDataSelectionModel(myDataSelectionItems: MyDataSelectionModel.sectionValues.map {
            return MyDataSelectionModel.SelectionItem(myDataExplanationSection: $0,
                                                      title: ScreenTitleService.main.myDataExplanationSectionTitles(for: $0),
                                                      selected: selectedValues?.contains(obj: $0.rawValue) ?? false)
        })
    }

    func saveMyDataSelections(_ selections: [MyDataParameter]) {
        let rawSelections = selections.map { (selection) -> Int in
            return selection.rawValue
        }
        UserDefault.myDataSelectedItems.setObject(rawSelections)
    }

    func myDataSelectionHeaderTitle() -> String {
        return ScreenTitleService.main.myDataSelectionTitle() ?? ""
    }

    func myDataSelectionHeaderSubtitle() -> String {
        return ScreenTitleService.main.myDataSelectionSubtitle() ?? ""
    }
}
