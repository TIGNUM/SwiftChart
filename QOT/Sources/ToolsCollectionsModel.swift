//
//  ToolsCollectionsModel.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

struct Tool {

    struct Item {
        let remoteID: Int
        let categoryTitle: String
        let title: String
        let durationString: String
        let imageURL: URL?
        let mediaURL: URL?
        let duration: Double
        let isCollection: Bool
        let numberOfItems: Int
        let type: String
    }
}
