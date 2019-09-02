//
//  ScreenTitleService+Ext.swift
//  QOT
//
//  Created by Sanggeon Park on 19.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

// MARK: - Search Suggestions

extension ScreenTitleService {

    func searchSuggestionsHeader() -> String {
        return localizedString(for: Tags.searchSuggestionHeader)
    }

    func searchSuggestions() -> [String] {
        var suggestions: [String] = []
        for tag in Tags.allCases where tag.rawValue.contains("search_suggestion") {
            suggestions.append(localizedString(for: tag))
        }
        return suggestions
    }
}

// MARK: - Tools

extension ScreenTitleService {

    func toolSectionTitles(for toolItem: ToolSection) -> String? {
        switch toolItem {
        case .mindset:
            return localizedString(for: .toolsMindsetSectionTitle)
        case .nutrition:
            return localizedString(for: .toolsNutritionSectionTitle)
        case .movement:
            return localizedString(for: .toolsMovementSectionTitle)
        case .recovery:
            return localizedString(for: .toolsRecoverySectionTitle)
        case .habituation:
            return localizedString(for: .toolsHabituationSectionTitle)
        }
    }

    func toolsHeaderTitle() -> String? {
        return localizedString(for: .toolsHeaderTitle)
    }

    func toolsHeaderSubtitle() -> String? {
        return localizedString(for: .toolsHeaderSubtitle)
    }
}

// MARK: - Coach

extension ScreenTitleService {

    func coachSectionTitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return localizedString(for: .coachSearchSectionTitle)
        case .tools:
            return localizedString(for: .coachApplyToolsSectionTitle)
        case .sprint:
            return localizedString(for: .coachPlanSprintSectionTitle)
        case .event:
            return localizedString(for: .coachPrepareEventSectionTitle)
        case .challenge:
            return localizedString(for: .coachSolveChallengeSectionTitle)
        }
    }

    func coachSectionSubtitles(for coachItem: CoachSection) -> String? {
        switch coachItem {
        case .search:
            return localizedString(for: .coachSearchSectionSubtitle)
        case .tools:
            return localizedString(for: .coachApplyToolsSectionSubtitle)
        case .sprint:
            return localizedString(for: .coachPlanSprintSectionSubtitle)
        case .event:
            return localizedString(for: .coachPrepareEventSectionSubtitle)
        case .challenge:
            return localizedString(for: .coachSolveChallengeSectionSubtitle)
        }
    }

    func coachHeaderTitle() -> String? {
        return localizedString(for: .coachHeaderTitle)
    }

    func coachHeaderSubtitle() -> String? {
        return localizedString(for: .coachHeaderSubtitle)
    }
}

// MARK: - Payment

extension ScreenTitleService {

    func paymentSectionTitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return localizedString(for: .paymentPrepareSectionTitle)
        case .impact:
            return localizedString(for: .paymentImpactSectionTitle)
        case .grow:
            return localizedString(for: .paymentGrowSectionTitle)
        case .data:
            return localizedString(for: .paymentDataSectionTitle)
        }
    }

    func paymentSectionSubtitles(for paymentItem: PaymentSection) -> String? {
        switch paymentItem {
        case .prepared:
            return localizedString(for: .paymentPrepareSectionSubtitle)
        case .impact:
            return localizedString(for: .paymentImpactSectionSubtitle)
        case .grow:
            return localizedString(for: .paymentGrowSectionSubtitle)
        case .data:
            return localizedString(for: .paymentDataSectionSubtitle)
        }
    }

    func paymentHeaderTitle() -> String? {
        return localizedString(for: .paymentHeaderTitle)
    }

    func paymentHeaderSubtitle() -> String? {
        return localizedString(for: .paymentHeaderSubtitle)
    }
}

// MARK: - My Qot

extension ScreenTitleService {

    func myQotSectionTitles(for myQotItem: MyQotSection) -> String? {
        switch myQotItem {
        case .profile:
            return localizedString(for: .myQotProfileSectionTitle)
        case .library:
            return localizedString(for: .myQotLibrarySectionTitle)
        case .preps:
            return localizedString(for: .myQotPrepsSectionTitle)
        case .sprints:
            return localizedString(for: .myQotSprintsSectionTitle)
        case .data:
            return localizedString(for: .myQotDataSectionTitle)
        case .toBeVision:
            return localizedString(for: .myQotToBeVisionSectionTitle)
        }
    }
}

// MARK: - To Be Vision Tooling

extension ScreenTitleService {

    func toBeVisionToolingHeadlinePlaceholder() -> String? {
        return localizedString(for: .toBeVisionToolingHeadlinePlaceholder)
    }

    func toBeVisionHeadlinePlaceholder() -> String? {
        return localizedString(for: .toBeVisionHeadlinePlaceholder)
    }

    func toBeVisionMessagePlaceholder() -> String? {
        return localizedString(for: .toBeVisionMessagePlaceholder)
    }

    func visionGeneratorAlertModelNotSaved() -> VisionGeneratorAlertModel? {
        let title = localizedString(for: .tbvGeneratorAlertNotSavedTitle)
        let message = localizedString(for: .tbvGeneratorAlertNotSavedMessage)
        let buttonTitleCancel = localizedString(for: .tbvGeneratorAlertNotSavedButtonTitleCancel)
        let buttonTitleDefault = localizedString(for: .tbvGeneratorAlertNotSavedButtonTitleDefault)
        let buttonTitleDestructive = localizedString(for: .tbvGeneratorAlertNotSavedButtonTitleDestructive)
        return VisionGeneratorAlertModel(title: title,
                                         message: message,
                                         buttonTitleCancel: buttonTitleCancel,
                                         buttonTitleDefault: buttonTitleDefault,
                                         buttonTitleDestructive: buttonTitleDestructive)
    }
}

// MARK: - My Data

extension ScreenTitleService {

    func myDataSectionTitles(for myDataItem: MyDataSection) -> String? {
        switch myDataItem {
        case .dailyImpact:
            return localizedString(for: .myDataDailyImpactSectionTitle)
        case .heatMap:
            return localizedString(for: .myDataHeatmapSectionTitle)
        }
    }

    func myDataSectionSubtitles(for myDataItem: MyDataSection) -> String? {
        switch myDataItem {
        case .dailyImpact:
            return localizedString(for: .myDataDailyImpactSectionSubtitle)
        case .heatMap:
            return localizedString(for: .myDataHeatmapSectionSubtitle)
        }
    }

    func myDataGraphNoDataTitle() -> String? {
        return localizedString(for: .myDataNoDataGraphTitle)
    }

    func myDataGraphIrAverageTitle() -> String? {
        return localizedString(for: .myDataGraphIRAverageTitle)
    }

    func myDataHeatMapLegendHighTitle() -> String? {
        return localizedString(for: .myDataHeatMapLegendHighTitle)
    }

    func myDataHeatMapLegendLowTitle() -> String? {
        return localizedString(for: .myDataHeatMapLegendLowTitle)
    }
}

extension ScreenTitleService {

    func myDataExplanationSectionTitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return localizedString(for: .myDataExplanationSQLSectionTitle)
        case .SQN:
            return localizedString(for: .myDataExplanationSQNSectionTitle)
        case .tenDL:
            return localizedString(for: .myDataExplanationTenDLSectionTitle)
        case .fiveDRR:
            return localizedString(for: .myDataExplanationFiveDRRSectionTitle)
        case .fiveDRL:
            return localizedString(for: .myDataExplanationFiveDRLSectionTitle)
        case .fiveDIR:
            return localizedString(for: .myDataExplanationFiveDIRSectionTitle)
        case .IR:
            return localizedString(for: .myDataExplanationIRSectionTitle)
        }
    }

    func myDataExplanationSectionSubtitles(for myDataExplanationItem: MyDataParameter) -> String? {
        switch myDataExplanationItem {
        case .SQL:
            return localizedString(for: .myDataExplanationSQLSectionSubtitle)
        case .SQN:
            return localizedString(for: .myDataExplanationSQNSectionSubtitle)
        case .tenDL:
            return localizedString(for: .myDataExplanationTenDLSectionSubtitle)
        case .fiveDRR:
            return localizedString(for: .myDataExplanationFiveDRRSectionSubtitle)
        case .fiveDRL:
            return localizedString(for: .myDataExplanationFiveDRLSectionSubtitle)
        case .fiveDIR:
            return localizedString(for: .myDataExplanationFiveDIRSectionSubtitle)
        case .IR:
            return localizedString(for: .myDataExplanationIRSectionSubtitle)
        }
    }
}

extension ScreenTitleService {

    func myDataSelectionTitle() -> String? {
        return localizedString(for: .myDataDailyImpactSectionTitle)
    }

    func myDataSelectionSubtitle() -> String? {
        return localizedString(for: .myDataDailyImpactSectionTitle)
    }
}
