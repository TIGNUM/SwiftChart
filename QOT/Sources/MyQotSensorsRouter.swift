//
//  MyQotSensorsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import SafariServices

final class MyQotSensorsRouter {

    // MARK: - Properties
    private weak var viewController: MyQotSensorsViewController?

    // MARK: - Init
    init(viewController: MyQotSensorsViewController) {
        self.viewController = viewController
    }
}

extension MyQotSensorsRouter: MyQotSensorsRouterInterface {
    func startOuraAuth(requestURL: URL, config: QDMOuraRingConfig) {
        let safariVC = SFSafariViewController(url: requestURL)
        viewController?.present(safariVC, animated: true, completion: nil)
        viewController?.ouraRingAuthConfiguration = config
    }
}
