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
    private var items: [ResultsPrepare.Items] = []

    // MARK: - Init
    init(viewController: ResultsPrepareViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - Private
private extension ResultsPreparePresenter {
    func getHeaderItem() -> ResultsPrepare.Items {
        return ResultsPrepare.Items.header(title: AppTextService.get(.results_prepare_header_title))
    }

    func getCalendarItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Items {
        if let title = preparation?.eventTitle, let date = preparation?.eventDate {
            return ResultsPrepare.Items.calendar(title: title,
                                                 subtitle: date.eventDateString,
                                                 calendarItem: .selected)
        }
        return ResultsPrepare.Items.calendar(title: AppTextService.get(.results_prepare_connect_calendar_title),
                                             subtitle: AppTextService.get(.results_prepare_connect_calendar_title),
                                             calendarItem: .unselected)
    }

    func getQuestionItem() -> ResultsPrepare.Items {
        return ResultsPrepare.Items.question(title: AppTextService.get(.results_prepare_critical_questions))
    }

    func getPerceivedItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Items {
        return ResultsPrepare.Items.perceived(title: AppTextService.get(.results_prepare_perceived),
                                              preceiveAnswers: preparation?.preceiveAnswers ?? [])
    }

    func getKnowItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Items {
        return ResultsPrepare.Items.know(title: AppTextService.get(.results_prepare_know),
                                         knowAnswers: preparation?.knowAnswers ?? [])
    }

    func getFeelItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Items {
        return ResultsPrepare.Items.feel(title: AppTextService.get(.results_prepare_feel),
                                         feelAnswers: preparation?.feelAnswers ?? [])
    }

    func getBenefitsItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Items {
        return ResultsPrepare.Items.benefits(title: AppTextService.get(.results_prepare_header_benefits),
                                             subtitle: AppTextService.get(.results_prepare_benefits),
                                             benefits: preparation?.benefits ?? "")
    }

    func getStrategiesItem(preparation: QDMUserPreparation?) -> ResultsPrepare.Items {
        return ResultsPrepare.Items.strategies(title: AppTextService.get(.results_prepare_strategies),
                                               strategies: preparation?.strategies ?? [])
     }
}

// MARK: - ResultsPrepareInterface
extension ResultsPreparePresenter: ResultsPreparePresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func createItems(preparation: QDMUserPreparation?) {
        items.removeAll()
        items.append(getHeaderItem())
        items.append(getCalendarItem(preparation: preparation))
        items.append(getQuestionItem())
        items.append(getPerceivedItem(preparation: preparation))
        items.append(getKnowItem(preparation: preparation))
        items.append(getFeelItem(preparation: preparation))
        items.append(getBenefitsItem(preparation: preparation))
        items.append(getStrategiesItem(preparation: preparation))
    }

    func updateView() {

    }
}
