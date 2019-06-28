//
//  WhatsHotLatestRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class WhatsHotLatestRouter {

    // MARK: - Properties

    private let viewController: WhatsHotLatestViewController

    // MARK: - Init

    init(viewController: WhatsHotLatestViewController) {
        self.viewController = viewController
    }
}

// MARK: - WhatsHotLatestRouterInterface

extension WhatsHotLatestRouter: WhatsHotLatestRouterInterface {

    func presentWhatsHotArticle(selectedID: Int) {
        if let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: "QOT.ArticleViewController") as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
            viewController.present(controller, animated: true, completion: nil)
        }
    }
}
