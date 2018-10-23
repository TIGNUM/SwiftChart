//
//  UINavigationController+Convenience.swift
//  QOT
//
//  Created by Lee Arromba on 28/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UINavigationController {

    convenience init(withPages pages: [UIViewController],
                     navigationItem: NavigationItem,
                     headerView: UIView? = nil,
                     topBarDelegate: NavigationItemDelegate? = nil,
                     pageDelegate: PageViewControllerDelegate? = nil,
                     backgroundColor: UIColor = .navy,
                     backgroundImage: UIImage? = UIImage(),
                     leftButton: UIBarButtonItem? = nil,
                     rightButton: UIBarButtonItem? = nil,
                     navigationItemStyle: NavigationItem.Style = .dark) {
        self.init(navigationBarClass: UINavigationBar.self, toolbarClass: nil)
        let titles = pages.map { $0.title?.uppercased() ?? "" }
        let style = navigationItemStyle
        navigationItem.configure(leftButton: leftButton, rightButton: rightButton, tabTitles: titles, style: style)
        navigationItem.delegate = topBarDelegate
        let pageViewController = PageViewController(headerView: headerView,
                                                    backgroundImage: backgroundImage,
                                                    pageDelegate: pageDelegate,
                                                    transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal,
                                                    options: nil,
                                                    navigationItem: navigationItem)
        pageViewController.setPages(pages)
        pageViewController.setPageIndex(0, animated: false)
        navigationBar.backgroundColor = backgroundColor
        navigationBar.barTintColor = .navy
        navigationBar.isTranslucent = false
        view.backgroundColor = backgroundColor
        viewControllers = [pageViewController]
    }

    func middleButton(at index: Int) -> UIButton? {
        guard let navItem = navigationBar.topItem as? NavigationItem else { return nil }
        return navItem.middleButton(index: index)
    }
}
