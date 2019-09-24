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
    private var buttonTitle = ""
    private var headerTitle = ""
    private var headerSubTitle = ""
    private var triggerTitle = ""
    private var reactionsTitle = ""
    private var lowToHighTitle = ""
    private var lowTitle = ""
    private var highTitle = ""
    private var visionTitle = ""
    private var mindsetResultModel: MindsetResult?
    private let mindsetShifter: QDMMindsetShifter?

    // MARK: - Init
    init(_ mindsetShifter: QDMMindsetShifter?) {
        self.mindsetShifter = mindsetShifter
        setTitles()
    }
}

// MARK: - Public
extension ShifterResultWorker {
    func getMindsetShifterResultModel() -> MindsetResult {
        let sections = [getHeader, getTrigger, getReactions, getLowToHigh, getVision]
        let model = MindsetResult(sections: sections, buttonTitle: buttonTitle)
        mindsetResultModel = model
        return model
    }
}

// MARK: - Private
private extension ShifterResultWorker {
    func setTitles() {
        buttonTitle = ScreenTitleService.main.localizedString(for: .ShifterResultButtonTitle)
        headerSubTitle = ScreenTitleService.main.localizedString(for: .ShifterResultHeaderSubtitle)
        headerTitle = ScreenTitleService.main.localizedString(for: .ShifterResultHeaderTitle)
        highTitle = ScreenTitleService.main.localizedString(for: .ShifterResultHighTitle)
        lowTitle = ScreenTitleService.main.localizedString(for: .ShifterResultLowTitle)
        lowToHighTitle = ScreenTitleService.main.localizedString(for: .ShifterResultLowToHighTitle)
        reactionsTitle = ScreenTitleService.main.localizedString(for: .ShifterResultReactionsTitle)
        triggerTitle = ScreenTitleService.main.localizedString(for: .ShifterResultTriggerTitle)
        visionTitle = ScreenTitleService.main.localizedString(for: .ShifterResultVisionTitle)
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
