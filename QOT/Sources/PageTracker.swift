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

final class PageTracker {
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

// MARK: - Swizevil
/**
 @abstract  using this to track all ViewDidAppear events without disturbing / repeating code
 */
private var viewDidAppearSwizzle = ViewDidAppearSwizzle()

private struct ViewDidAppearSwizzle: Swizzle {

    // MARK: - Properties

    let classID: AnyClass
    let originalSelector: Selector
    let newSelector: Selector
    var originalMethod: Method?
    var newMethod: Method?
    var isSwizzled: Bool

    // MARK: - Init

    init() {
        classID = UIViewController.self
        originalSelector = #selector(UIViewController.viewDidAppear(_:))
        newSelector = #selector(UIViewController.QOT_PageTracker_viewDidAppear(_:))
        originalMethod = class_getInstanceMethod(classID, originalSelector)
        newMethod = class_getInstanceMethod(classID, newSelector)
        isSwizzled = false
    }
}

extension UIViewController {

    @objc func QOT_PageTracker_viewDidAppear(_ animated: Bool) {
        QOT_PageTracker_viewDidAppear(animated)
        if let trackablePage = self as? TrackablePage {
            _staticPageTracker?.track(trackablePage)
        }
    }
}
