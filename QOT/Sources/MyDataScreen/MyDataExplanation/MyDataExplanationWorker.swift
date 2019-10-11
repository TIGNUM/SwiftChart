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
                                                          title: self.myDataExplanationSectionTitles(for: $0),
                                                          subtitle: self.myDataExplanationSectionSubtitles(for: $0))
        })
    }

    func myDataExplanationHeaderTitle() -> String {
        return AppTextService.get(AppTextKey.my_qot_my_data_view_ir_title)
    }

    func myDataExplanationSectionTitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_sql_title)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_sqn_title)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_ten_dl_title)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_five_drr_title)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_five_drl_title)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_five_dir_title)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_ir_title)
        }
    }

    func myDataExplanationSectionSubtitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_sql_subtitle)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_sqn_subtitle)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_ten_dl_subtitle)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_five_drr_subtitle)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_five_drl_subtitle)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_five_dir_subtitle)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_ir_subtitle)
        }
    }
}
