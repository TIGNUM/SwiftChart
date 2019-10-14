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

    func searchSuggestions() -> [String] {
        var suggestions: [String] = []
        for tag in Tags.allCases where tag.rawValue.contains("search_suggestion") {
            suggestions.append(localizedString(for: tag))
        }
        return suggestions
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
}

// MARK: - My Data

extension ScreenTitleService {

    func myDataSectionTitle(for myDataItem: MyDataSection) -> String? {
        switch myDataItem {
        case .dailyImpact:
            return localizedString(for: .myDataDailyImpactSectionTitle)
        case .heatMap:
            return localizedString(for: .myDataHeatmapSectionTitle)
        }
    }

    func myDataSectionSubtitle(for myDataItem: MyDataSection) -> String? {
        switch myDataItem {
        case .dailyImpact:
            return localizedString(for: .myDataDailyImpactSectionSubtitle)
        case .heatMap:
            return localizedString(for: .myDataHeatmapSectionSubtitle)
        }
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
        return localizedString(for: .myDataDailyImpactSectionSubtitle)
    }
}
