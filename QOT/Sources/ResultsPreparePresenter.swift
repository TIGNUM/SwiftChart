//
//  ResultsPreparePresenter.swift
//  QOT
//
//  Created by karmic on 11.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ResultsPreparePresenter {

    // MARK: - Properties
    private weak var viewController: ResultsPrepareViewControllerInterface?
    private var sections: [Int: ResultsPrepare.Sections] = [:]

    // MARK: - Init
    init(viewController: ResultsPrepareViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - Private
private extension ResultsPreparePresenter {
    func getHeaderItem() -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.header(title: AppTextService.get(.results_prepare_header_title))
    }

    func getCalendarItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        if let title = preparation?.eventTitle, let date = preparation?.eventDate {
            return ResultsPrepare.Sections.calendar(title: title,
                                                    subtitle: date.eventDateString,
                                                    calendarItem: .selected)
        }
        return ResultsPrepare.Sections.calendar(title: AppTextService.get(.results_prepare_connect_calendar_title),
                                                subtitle: AppTextService.get(.results_prepare_connect_calendar_title),
                                                calendarItem: .unselected)
    }

    func getQuestionTitleItem() -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.title(title: AppTextService.get(.results_prepare_critical_questions))
    }

    func getPerceivedItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.perceived(title: AppTextService.get(.results_prepare_perceived),
                                                 preceiveAnswers: preparation?.preceiveAnswers ?? [])
    }

    func getKnowItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.know(title: AppTextService.get(.results_prepare_know),
                                            knowAnswers: preparation?.knowAnswers ?? [])
    }

    func getFeelItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.feel(title: AppTextService.get(.results_prepare_feel),
                                            feelAnswers: preparation?.feelAnswers ?? [])
    }

    func getBenefitsItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.benefits(title: AppTextService.get(.results_prepare_header_benefits),
                                                subtitle: AppTextService.get(.results_prepare_benefits),
                                                benefits: preparation?.benefits ?? "")
    }

    func getStrategyTitleItem() -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.title(title: AppTextService.get(.results_prepare_strategies))
    }

    func getStrategiesItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return ResultsPrepare.Sections.strategies(strategies: preparation?.strategies ?? [])
    }
}

// MARK: - ResultsPrepareInterface
extension ResultsPreparePresenter: ResultsPreparePresenterInterface {
    func createListItems(preparation: QDMUserPreparation?) {
        sections.removeAll()
        sections[0] = getHeaderItem()
        sections[1] = getCalendarItem(preparation: preparation)
        sections[2] = getQuestionTitleItem()
        sections[3] = getPerceivedItem(preparation: preparation)
        sections[4] = getKnowItem(preparation: preparation)
        sections[5] = getFeelItem(preparation: preparation)

        if preparation?.type == .LEVEL_CRITICAL {
            sections[6] = getBenefitsItem(preparation: preparation)
            sections[7] = getStrategyTitleItem()
            sections[8] = getStrategiesItem(preparation: preparation)
        } else {
            sections[6] = getStrategyTitleItem()
            sections[7] = getStrategiesItem(preparation: preparation)
        }

        viewController?.updateView(items: sections)
    }

    func setupView() {
        viewController?.setupView()
    }
}
