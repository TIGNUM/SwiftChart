//
//  ArticleRouter.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ArticleRouter: BaseRouter, ArticleRouterInterface {
    func didTapLink(_ url: URL) {
        if url.scheme == "mailto" && UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url)
        } else {
            do {
                viewController?.present(try WebViewController(url), animated: true, completion: nil)
            } catch {
                log("Failed to open url. Error: \(error)", level: .error)
                viewController?.showAlert(type: .message(error.localizedDescription))
            }
        }
    }
}
