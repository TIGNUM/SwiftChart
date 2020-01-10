//
//  SearchRouter.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SearchRouter: BaseRouter, SearchRouterInterface {
    func handleSelection(searchResult: Search.Result) {
        if let contentItemID = searchResult.contentItemID,
            let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemID)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
        } else if let contentCollectionID = searchResult.contentID {
            presentContent(contentCollectionID)
        }
    }
}
