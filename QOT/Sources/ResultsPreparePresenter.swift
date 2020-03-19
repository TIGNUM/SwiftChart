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
    var strategyCount = 0

    // MARK: - Init
    init(viewController: ResultsPrepareViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - Private
private extension ResultsPreparePresenter {
    func getHeaderItem(_ preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        let appText = AppTextService.get(.results_prepare_header_title)
        let title = appText.replacingOccurrences(of: "[TYPE OF PREPARATION]", with: preparation?.eventType ?? "")
        return ResultsPrepare.Sections.header(title: title.uppercased())
    }

    func getCalendarItem(_ preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        if preparation?.eventExternalUniqueIdentifierId != nil,
            let title = preparation?.eventTitle,
            let date = preparation?.eventDate?.eventDateString,
            let type = preparation?.eventType {
                return .calendar(title: title, subtitle: date + " | " + type)
        }
        return .calendarConnect(title: AppTextService.get(.results_prepare_connect_calendar_title),
                                subtitle: AppTextService.get(.results_prepare_connect_calendar_subtitle))
    }

    func getQuestionTitleItem() -> ResultsPrepare.Sections {
        return .title(title: AppTextService.get(.results_prepare_critical_questions))
    }

    func getPerceivedItem(_ preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return .perceived(title: AppTextService.get(.results_prepare_perceived),
                                                 preceiveAnswers: preparation?.preceiveAnswers ?? [])
    }

    func getKnowItem(_ preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return .know(title: AppTextService.get(.results_prepare_know),
                                            knowAnswers: preparation?.knowAnswers ?? [])
    }

    func getFeelItem(_ preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return .feel(title: AppTextService.get(.results_prepare_feel),
                                            feelAnswers: preparation?.feelAnswers ?? [])
    }

    func getBenefitsItem(_ preparation: QDMUserPreparation?) -> ResultsPrepare.Sections {
        return .benefits(title: AppTextService.get(.results_prepare_header_benefits),
                         subtitle: AppTextService.get(.results_prepare_benefits),
                         benefits: preparation?.benefits ?? "")
    }

    func getStrategyTitleItem() -> ResultsPrepare.Sections {
        return .strategyTitle(title: AppTextService.get(.results_prepare_strategies))
    }

    func getStrategyItems(_ preparation: QDMUserPreparation?,
                           _ completion: @escaping (ResultsPrepare.Sections) -> Void) {
        if preparation?.strategyIds.isEmpty == true,
            let relatedStrategyId = preparation?.relatedStrategyId {
            strategyIDsDefault(relatedStrategyId) { [weak self] (strategies) in
                self?.strategyCount = strategies?.count ?? 0
                completion(.strategies(strategies: strategies ?? []))
            }
        } else {
            completion(.strategies(strategies: preparation?.strategies ?? []))
        }
    }

    func strategyIDsDefault(_ relatedStrategyID: Int?, _ completion: @escaping (([QDMContentCollection]?) -> Void)) {
        if let relatedStrategyID = relatedStrategyID {
            ContentService.main.getContentCollectionById(relatedStrategyID) { content in
                let relatedIds = content?.relatedContentIDsPrepareDefault ?? []
                ContentService.main.getContentCollectionsByIds(relatedIds, completion)
            }
        } else {
            completion([])
        }
    }
}

// MARK: - ResultsPrepareInterface
extension ResultsPreparePresenter: ResultsPreparePresenterInterface {
    var getStrategyCount: Int {
        return strategyCount
    }

    func createListItems(preparation: QDMUserPreparation?) {
        sections.removeAll()
        sections[0] = getHeaderItem(preparation)
        sections[1] = getCalendarItem(preparation)
        sections[2] = getQuestionTitleItem()
        sections[3] = getPerceivedItem(preparation)
        sections[4] = getKnowItem(preparation)
        sections[5] = getFeelItem(preparation)

        if preparation?.type == .LEVEL_CRITICAL {
            sections[6] = getBenefitsItem(preparation)
            sections[7] = getStrategyTitleItem()
            getStrategyItems(preparation) { [weak self] (strategySections) in
                guard let strongSelf = self else { return }
                strongSelf.sections[8] = strategySections
                strongSelf.viewController?.updateView(items: strongSelf.sections)
            }
        } else {
            sections[6] = getStrategyTitleItem()
            getStrategyItems(preparation) { [weak self] (strategySections) in
                guard let strongSelf = self else { return }
                strongSelf.sections[7] = strategySections
                strongSelf.viewController?.updateView(items: strongSelf.sections)
            }
        }
    }

    func setupView() {
        viewController?.setupView()
    }
}
