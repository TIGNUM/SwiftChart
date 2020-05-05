//
//  MyQotSupportRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportRouter: BaseRouter, MyQotSupportRouterInterface {
    func handleSelection(for item: MyQotSupportModel.MyQotSupportModelItem, email: String) {
        switch item {
        case .usingQOT: presentUsingQOT()
        case .faq: showFAQScreen(category: .FAQ)
        case .contactSupport: presentMailComposer(recipients: [Defaults.firstLevelSupportEmail],
                                                  subject: "ID: Support")
        case .contactSupportNovartis: break
        case .featureRequest: presentMailComposer(recipients: [Defaults.firstLevelFeatureEmail],
                                                  subject: "ID: Feature")
        case .introduction: presentOnboarding()
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
    func presentUsingQOT() {
        let identifier = R.segue.myQotSupportViewController.myQotSupportDetailsSegueIdentifier.identifier
        viewController?.performSegue(withIdentifier: identifier, sender: ContentCategory.UsingQOT)
    }

    func presentOnboarding() {
        if let controller = R.storyboard.registerIntro().instantiateInitialViewController() as? RegisterIntroViewController {
        let configurator = RegisterIntroConfigurator.make(false)
        configurator(controller)
        viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
