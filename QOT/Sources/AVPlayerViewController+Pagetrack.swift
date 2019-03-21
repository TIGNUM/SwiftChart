//
//  AVPlayerViewController+Pagetrack.swift
//  QOT
//
//  Created by karmic on 18.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import AVKit

private struct PagePlayVideo {
    static var name = PageName.infoGuide
    static var contentItem: ContentItem?
}

extension AVPlayerViewController {

    var pageType: PageName {
        get {
            return PagePlayVideo.name
        }
        set {
            PagePlayVideo.name = newValue
            objc_setAssociatedObject(self,
                                     &PagePlayVideo.name,
                                     newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var contentItem: ContentItem? {
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

    convenience init(pageName: PageName, contentItem: ContentItem?) {
        self.init()
        self.pageType = pageName
        self.contentItem = contentItem
    }
}
