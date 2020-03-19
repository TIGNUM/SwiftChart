//
//  DTPrepareStartPresenter.swift
//  QOT
//
//  Created by karmic on 19.03.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPrepareStartPresenter {

    // MARK: - Properties
    private weak var viewController: DTPrepareStartViewControllerInterface?
    private lazy var viewModel: DTPrepareStartViewModel = {
        return DTPrepareStartViewModel(header: AppTextService.get(.chatbot_prepare_start_header),
                                       intentionTitle: AppTextService.get(.chatbot_prepare_start_intentionTitle),
                                       intentions: AppTextService.get(.chatbot_prepare_start_intentions),
                                       strategyTitle: AppTextService.get(.chatbot_prepare_start_strategyTitle),
                                       strategies: AppTextService.get(.chatbot_prepare_start_strategies),
                                       selectionTitle: AppTextService.get(.chatbot_prepare_start_selectionTitle),
                                       buttonCritical: AppTextService.get(.chatbot_prepare_start_critical_button),
                                       buttonDaily: AppTextService.get(.chatbot_prepare_start_daily_button))
    }()

    // MARK: - Initin
    init(viewController: DTPrepareStartViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - DTPrepareStartInterface
extension DTPrepareStartPresenter: DTPrepareStartPresenterInterface {
    func setupView() {
        viewController?.setupView(viewModel: viewModel)
    }
}
