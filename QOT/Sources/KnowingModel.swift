//
//  KnowingModel.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Knowing {

    enum Sections: CaseIterable {
        case strategies
        case whatsHot
    }

    struct WhatsHotItem: Equatable {
        let title: String
        let body: String
        let image: URL?
        let remoteID: Int
        let author: String
        let publishDate: Date?
        let timeToRead: String?
    }

    struct StrategyItem: Equatable {
        let title: String
        let remoteID: Int
        let viewedCount: Int
        let itemCount: Int
        let sortOrder: Int
    }
}
