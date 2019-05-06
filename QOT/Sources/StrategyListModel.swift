//
//  StrategyListModel.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Strategy {

    struct Item {
        let remoteID: Int
        let categoryTitle: String
        let title: String
        let durationString: String
        let imageURL: URL?
        let mediaURL: URL?
        let duration: Double
    }
}
