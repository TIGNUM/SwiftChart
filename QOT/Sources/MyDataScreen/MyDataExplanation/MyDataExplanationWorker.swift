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
        return AppTextService.get(AppTextKey.my_qot_my_data_view_title_ir)
    }

    func myDataExplanationSectionTitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_sleep_quality)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_sleep_quantity)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_ten_dl)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_five_drr)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_five_drl)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_five_dir)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_title_ir)
        }
    }

    func myDataExplanationSectionSubtitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_sleep_quality)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_sleep_quantity)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_ten_dl)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_five_drr)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_five_drl)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_five_dir)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_info_subtitle_ir)
        }
    }
}
