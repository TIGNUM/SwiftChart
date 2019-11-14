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
        return AppTextService.get(AppTextKey.my_qot_my_data_section_impact_readiness_title)
    }

    func myDataExplanationSectionTitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_sleep_quality_title)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_sleep_quantity_title)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_ten_day_load_title)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_recovery_title)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_load_title)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_ir_title)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_ir_title)
        }
    }

    func myDataExplanationSectionSubtitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_sleep_quality_subtitle)
        case .SQN:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_sleep_quantity_subtitle)
        case .tenDL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_ten_day_load_subtitle)
        case .fiveDRR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_recovery_subtitle)
        case .fiveDRL:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_load_subtitle)
        case .fiveDIR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_five_day_ir_subtitle)
        case .IR:
            return AppTextService.get(AppTextKey.my_qot_my_data_ir_explanation_section_ir_subtitle)
        }
    }
}
