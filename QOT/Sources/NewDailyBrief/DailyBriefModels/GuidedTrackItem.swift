//
//  GuidedTrackItem.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 25/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import DifferenceKit
import qot_dal

struct GuidedTrackItem: Equatable {
    var title: String?
    var image: String?
    var appLink: QDMAppLink?
    var subIdentifier = ""
    var isCompleted: Bool?

    init(title: String?, image: String?, appLink: QDMAppLink, isCompleted: Bool?) {
        self.title = title
        self.image = image
        self.appLink = appLink
        self.isCompleted = isCompleted
    }

    static func == (lhs: GuidedTrackItem, rhs: GuidedTrackItem) -> Bool {
        return lhs.appLink?.appLink == rhs.appLink?.appLink
    }
}
