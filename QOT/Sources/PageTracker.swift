//
//  PageTracker.swift
//  QOT
//
//  Created by Lee Arromba on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIViewController {
    func QOT_PageTracker_viewDidAppear(_ animated: Bool) {
        QOT_PageTracker_viewDidAppear(animated)
        if let trackablePage = self as? TrackablePage {
            PageTracker.default.track(trackablePage)
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
   
    static let `default` = PageTracker()
    weak var lastPage: TrackablePage?
    
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
        //log(">>>> WILL TRACK \(page) from \(String(describing: lastPage))")
        EventTracker.default.track(.didShowPage(page, from: lastPage))
        lastPage = page
    }
}
