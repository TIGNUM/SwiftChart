//
//  PageTracker.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

// @note using this to avoid singleton pattern
private weak var _staticPageTracker: PageTracker?

extension UIViewController {
    func QOT_PageTracker_viewDidAppear(_ animated: Bool) {
        QOT_PageTracker_viewDidAppear(animated)
        if let trackablePage = self as? TrackablePage {
            _staticPageTracker?.track(trackablePage)
        }
    }
}

private struct ViewDidAppearSwizzle: Swizzle {
    let classID: AnyClass = UIViewController.self
    let originalSelector: Selector = #selector(UIViewController.viewDidAppear(_:))
    let newSelector: Selector = #selector(UIViewController.QOT_PageTracker_viewDidAppear(_:))
    let originalMethod: Method
    let newMethod: Method
    var isSwizzled: Bool = false
    
    init() {
        originalMethod = class_getInstanceMethod(classID, originalSelector)
        newMethod = class_getInstanceMethod(classID, newSelector)
    }
}

class PageTracker {
    private var viewDidAppearSwizzle = ViewDidAppearSwizzle()
    private let eventTracker: EventTracker
    
    weak var lastPage: TrackablePage?
    
    init(eventTracker: EventTracker) {
        self.eventTracker = eventTracker
    }
    
    class func setStaticTracker(pageTracker: PageTracker) {
        _staticPageTracker = pageTracker
    }
    
    func start() {
        if !viewDidAppearSwizzle.isSwizzled {
            viewDidAppearSwizzle.swizzle()
        }
    }
    
    func stop() {
        if viewDidAppearSwizzle.isSwizzled {
            viewDidAppearSwizzle.swizzle()
        }
    }
    
    func track(_ page: TrackablePage) {
        eventTracker.track(.didShowPage(page, from: lastPage))
        lastPage = page
    }
}
