//
//  AVPlayerViewController+Pagetrack.swift
//  QOT
//
//  Created by karmic on 18.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import AVKit
import qot_dal

private struct PagePlayVideo {
    static var contentItem: QDMContentItem?
}

extension AVPlayerViewController {
    var contentItem: QDMContentItem? {
        get {
            return PagePlayVideo.contentItem
        }
        set {
            PagePlayVideo.contentItem = newValue
            objc_setAssociatedObject(self,
                                     &PagePlayVideo.contentItem,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    convenience init(contentItem: QDMContentItem?) {
        self.init()
        self.contentItem = contentItem
    }
}
