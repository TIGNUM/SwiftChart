//
//  DailyBriefRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyBriefRouter {

    // MARK: - Properties

    private let viewController: DailyBriefViewController

    // MARK: - Init

    init(viewController: DailyBriefViewController) {
        self.viewController = viewController
    }
}

// MARK: - DailyBriefRouterInterface

extension DailyBriefRouter: DailyBriefRouterInterface {
    

    func presentWhatsHotArticle(selectedID: Int) {
        if let controller = R.storyboard.main().instantiateViewController(withIdentifier: R.storyboard.main.qotArticleViewController.identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
            viewController.present(controller, animated: true, completion: nil)
        }
    }
}
