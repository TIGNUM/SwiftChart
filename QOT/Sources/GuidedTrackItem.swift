//
//  GuidedTrackItem.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 25/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class GuidedTrackItem: NSObject {
    var title: String?
    var image: String?
    var appLink: QDMAppLink?

    init(title: String?, image: String?, appLink: QDMAppLink) {
        super.init()
        self.title = title
        self.image = image
        self.appLink = appLink
    }
}
