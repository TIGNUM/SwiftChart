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
                     headerView: UIView? = nil,
                     topBarDelegate: TopNavigationBarDelegate? = nil,
                     pageDelegate: PageViewControllerDelegate? = nil,
                     backgroundColor: UIColor = .clear,
                     backgroundImage: UIImage? = R.image._1Learn(),
                     titleFont: UIFont = Font.H5SecondaryHeadline,
                     titleSelectedColor: UIColor = .white,
                     titleNormalColor: UIColor = .gray,
                     leftButton: UIBarButtonItem? = nil,
                     rightButton: UIBarButtonItem? = nil) {
        let pageViewController = PageViewController(headerView: headerView,
                                                    backgroundImage: backgroundImage,
                                                    pageDelegate: pageDelegate,
                                                    transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal,
                                                    options: nil)
        pageViewController.setPages(pages)
        pageViewController.setPageIndex(0, animated: false)
        
        self.init(navigationBarClass: TopNavigationBar.self, toolbarClass: nil)
       
        view.backgroundColor = backgroundColor
        viewControllers = [pageViewController]
        
        if let navigationBar = navigationBar as? TopNavigationBar {
            navigationBar.topNavigationBarDelegate = topBarDelegate
            
            if let leftButton = leftButton {
                navigationBar.setLeftButton(leftButton)
            }
            
            if let rightButton = rightButton {
                navigationBar.setRightButton(rightButton)
            }
            
            var pageButtons = [UIButton]()
            pages.forEach { (page: UIViewController) in
                let button = UIButton(type: .custom)
                button.setTitle(page.title?.uppercased(), for: .normal)
                button.setTitleColor(titleSelectedColor, for: .selected)
                button.setTitleColor(titleNormalColor, for: .normal)
                button.titleLabel?.font = titleFont
                button.backgroundColor = .clear
                pageButtons.append(button)
            }
            navigationBar.setMiddleButtons(pageButtons)
        }
    }
    
    func button(at index: Int) -> UIButton? {
        guard
            let stackView = navigationBar.topItem?.titleView as? UIStackView, index < stackView.arrangedSubviews.count,
            let button = stackView.arrangedSubviews[index] as? UIButton else {
                return nil
        }
        return button
    }
}
