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
                     titleColor: UIColor = .white,
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
                button.setTitleColor(titleColor, for: .normal)
                button.titleLabel?.font = titleFont
                button.backgroundColor = .clear
                pageButtons.append(button)
            }
            navigationBar.setMiddleButtons(pageButtons)
        }
    }
}

// MARK: - CustomPresentationAnimatorDelegate

extension UINavigationController: CustomPresentationAnimatorDelegate {
    
    func animationsForAnimator(_ animator: CustomPresentationAnimator) -> (() -> Void)? {
        guard let viewController = viewControllers.first as? CustomPresentationAnimatorDelegate else {
            return nil
        }
        return viewController.animationsForAnimator(animator)
    }
}

// MARK: - ZoomPresentationAnimatable

extension UINavigationController: ZoomPresentationAnimatable {

    func startAnimation(presenting: Bool, animationDuration: TimeInterval, openingFrame: CGRect) {
        guard let viewController = viewControllers.first as? ZoomPresentationAnimatable else {
            return
        }
        viewController.startAnimation(presenting: presenting, animationDuration: animationDuration, openingFrame: openingFrame)
    }
}
