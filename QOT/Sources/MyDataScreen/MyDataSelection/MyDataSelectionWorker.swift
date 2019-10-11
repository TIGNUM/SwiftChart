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
                                                      title: myDataSelectionSectionTitles(for: $0),
                                                      selected: selectedValues?.contains(obj: $0.rawValue) ?? false)
        })
    }

    func myDataSelectionSectionTitles(for myDataSelectionItem: MyDataParameter) -> String? {
        switch myDataSelectionItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_sql_title)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_sqn_title)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_ten_dl_title)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_five_drr_title)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_five_drl_title)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_five_dir_title)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_edit_ir_title)
        }
    }

    func saveMyDataSelections(_ selections: [MyDataParameter]) {
        let rawSelections = selections.map { (selection) -> Int in
            return selection.rawValue
        }
        UserDefault.myDataSelectedItems.setObject(rawSelections)
    }

    func myDataSelectionHeaderTitle() -> String {
        return AppTextService.get(AppTextKey.my_qot_my_data_edit_title)
    }

    func myDataSelectionHeaderSubtitle() -> String {
        return AppTextService.get(AppTextKey.my_qot_my_data_edit_subtitle)
    }
}
