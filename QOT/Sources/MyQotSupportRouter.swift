//
//  MyQotSupportRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MessageUI
import qot_dal

final class MyQotSupportRouter {

    // MARK: - Properties

    private weak var viewController: MyQotSupportViewController?

    // MARK: - Init

    init(viewController: MyQotSupportViewController) {
        self.viewController = viewController
    }
}

extension MyQotSupportRouter: MyQotSupportRouterInterface {
    func handleSelection(for item: MyQotSupportModel.MyQotSupportModelItem, email: String) {
        guard let viewController = viewController else { return }
        switch item {
        case .usingQOT: presentUsingQOT()
        case .faq: presentFAQ()
        case .contactSupport: UIViewController.presentMailComposer(from: viewController,
                                                                   recipients: [Defaults.firstLevelSupportEmail],
                                                                   subject: "ID: Support")
        case .contactSupportNovartis: break
        case .featureRequest: UIViewController.presentMailComposer(from: viewController,
                                                                   recipients: [Defaults.firstLevelFeatureEmail],
                                                                   subject: "ID: Feature")
        }
    }

    func presentSupportNovartis(header: String?, subHeader: String?) {
        guard let supportNovartisController = R.storyboard.myQot.myQotSupportNovartisViewController() else {
            assertionFailure("Failed to initialize `MyQotSupportNovartisViewController`")
            return
        }
        supportNovartisController.header = header
        supportNovartisController.subTitle = subHeader
        viewController?.pushToStart(childViewController: supportNovartisController)
    }
}

private extension MyQotSupportRouter {
    func presentFAQ() {
        viewController?.performSegue(withIdentifier: R.segue.myQotSupportViewController.myQotSupportDetailsSegueIdentifier, sender: ContentCategory.FAQ)
    }

    func presentUsingQOT() {
        viewController?.performSegue(withIdentifier: R.segue.myQotSupportViewController.myQotSupportDetailsSegueIdentifier, sender: ContentCategory.UsingQOT)
    }
}
