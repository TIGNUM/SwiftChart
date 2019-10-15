//
//  ShifterResultWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ShifterResultWorker {

    // MARK: - Properties
    private var headerTitle = ""
    private var headerSubTitle = ""
    private var triggerTitle = ""
    private var reactionsTitle = ""
    private var lowToHighTitle = ""
    private var lowTitle = ""
    private var highTitle = ""
    private var visionTitle = ""
    private let mindsetShifter: QDMMindsetShifter?
    private let resultType: ResultType

    // MARK: - Init
    init(_ mindsetShifter: QDMMindsetShifter?, resultType: ResultType) {
        self.mindsetShifter = mindsetShifter
        self.resultType = resultType
        setTitles()
    }
}

// MARK: - Public
extension ShifterResultWorker {
    func getMindsetShifterResultModel() -> MindsetResult {
        let sections = [getHeader, getTrigger, getReactions, getLowToHigh, getVision]
        return MindsetResult(resultType: resultType, sections: sections)
    }

    func deleteMindsetShifter() {
        if let mindsetShifter = mindsetShifter {
            UserService.main.deleteMindsetShifter(mindsetShifter) { (error) in
                if let error = error {
                    log("Error deleteMindsetShifter: \(error.localizedDescription)", level: .error)
                }
            }
        }
    }
}

// MARK: - Private
private extension ShifterResultWorker {
    func setTitles() {
        headerTitle = AppTextService.get(AppTextKey.shifter_result_view_title_header)
        headerSubTitle = AppTextService.get(AppTextKey.shifter_result_view_subtitle_header)
        triggerTitle = AppTextService.get(AppTextKey.shifter_result_view_title_trigger)
        reactionsTitle = AppTextService.get(AppTextKey.shifter_result_view_title_reactions)
        lowToHighTitle = AppTextService.get(AppTextKey.shifter_result_view_title_neg_to_pos)
        lowTitle = AppTextService.get(AppTextKey.shifter_result_view_title_neg_to_pos_low)
        highTitle = AppTextService.get(AppTextKey.shifter_result_view_title_neg_to_pos_high)
        visionTitle = AppTextService.get(AppTextKey.shifter_result_view_title_vision)
    }

    var getHeader: MindsetResult.Section {
        return .header(title: headerTitle, subtitle: headerSubTitle)
    }

    var getTrigger: MindsetResult.Section {
        return .trigger(title: triggerTitle, item: mindsetShifter?.triggerAnswer?.subtitle ?? "")
    }

    var getReactions: MindsetResult.Section {
        return .reactions(title: reactionsTitle,
                          items: mindsetShifter?.reactionsAnswers?.compactMap { $0.subtitle ?? "" } ?? [])
    }

    var getLowToHigh: MindsetResult.Section {
        return .lowToHigh(title: lowToHighTitle,
                          lowTitle: lowTitle,
                          lowItems: mindsetShifter?.lowPerformanceAnswers?.compactMap { $0.subtitle ?? "" } ?? [],
                          highTitle: highTitle,
                          highItems: mindsetShifter?.highPerformanceContentItems.compactMap { $0.valueText } ?? [])
    }

    var getVision: MindsetResult.Section {
        return .vision(title: visionTitle, text: mindsetShifter?.toBeVisionText ?? "")
    }
}
