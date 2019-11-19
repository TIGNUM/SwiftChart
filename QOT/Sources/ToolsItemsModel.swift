//
//  ToolsItemsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

struct Tools {
    struct Item {
        let remoteID: Int
        let categoryTitle: String
        let title: String
        let durationString: String
        let imageURL: URL?
        let mediaURL: URL?
        let duration: Double
        let isCollection: Bool
        let contentCollectionId: Int
        let numberOfItems: Int
        let type: String
    }
}
