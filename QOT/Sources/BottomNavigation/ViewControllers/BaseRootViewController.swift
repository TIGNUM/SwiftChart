//
//  ViewController.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 19.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

protocol ScreenZLevelBottom: UIViewController {}
protocol ScreenZLevel1: ScreenZLevel {}
protocol ScreenZLevel2: ScreenZLevel {}
protocol ScreenZLevel3: ScreenZLevel {}
protocol ScreenZLevelCoach: ScreenZLevel3 {}

final class BaseRootViewController: UIViewController, ScreenZLevelBottom {
    @IBOutlet var bottomNavigationContainer: UIView!

    @IBOutlet weak var bottomNavigationBar: UINavigationBar!
    @IBOutlet weak var naviBackground: UIImageView!
    @IBOutlet weak var dummy: UIView!

    var naviViewLeadingConstraint: NSLayoutConstraint?
    var naviViewWidthConstraint: NSLayoutConstraint?
    var naviViewTopConstraint: NSLayoutConstraint?
    var naviViewBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        baseRootViewController = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleBottomNavigationBar(_:)),
                                               name: .updateBottomNavigation,
                                               object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIApplication.shared.windows.first?.subviews.contains(bottomNavigationContainer) == true {
            bringBottomNavigationBarToFront()
        } else {
            UIApplication.shared.windows.first?.addSubview(bottomNavigationContainer)
            bottomNavigationContainer.translatesAutoresizingMaskIntoConstraints = false
            if let window = bottomNavigationContainer.superview {
                naviViewLeadingConstraint = NSLayoutConstraint(item: bottomNavigationContainer!,
                                                               attribute: NSLayoutConstraint.Attribute.leading,
                                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                                               toItem: window,
                                                               attribute: NSLayoutConstraint.Attribute.leading,
                                                               multiplier: 1,
                                                               constant: 0)
                naviViewTopConstraint?.isActive = true

                naviViewWidthConstraint = NSLayoutConstraint(item: bottomNavigationContainer!,
                                                               attribute: NSLayoutConstraint.Attribute.width,
                                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                                               toItem: nil,
                                                               attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                                               multiplier: 1,
                                                               constant: 50)
                naviViewWidthConstraint?.isActive = true

                naviViewTopConstraint = NSLayoutConstraint(item: bottomNavigationContainer!,
                                                               attribute: NSLayoutConstraint.Attribute.top,
                                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                                               toItem: window,
                                                               attribute: NSLayoutConstraint.Attribute.top,
                                                               multiplier: 1,
                                                               constant: 0)
                naviViewTopConstraint?.isActive = true

                naviViewBottomConstraint = NSLayoutConstraint(item: bottomNavigationContainer!,
                                                               attribute: NSLayoutConstraint.Attribute.bottom,
                                                               relatedBy: NSLayoutConstraint.Relation.equal,
                                                               toItem: window,
                                                               attribute: NSLayoutConstraint.Attribute.bottom,
                                                               multiplier: 1,
                                                               constant: 0)
                naviViewBottomConstraint?.isActive = true
            }
        }
    }

    override func viewDidLayoutSubviews() {
        let frame = dummy.frame
        naviViewLeadingConstraint?.constant = frame.origin.x
        naviViewTopConstraint?.constant = frame.origin.y
        naviViewWidthConstraint?.constant = frame.size.width
        bottomNavigationContainer.superview?.setNeedsUpdateConstraints()
    }
}

// MARK: -
extension BaseRootViewController {
    func setContent(viewController: UIViewController) {
        addChildViewController(viewController)
        view.fill(subview: viewController.view)
    }
}

// MARK: - bottom navigation bar
extension BaseRootViewController {
    @objc func handleBottomNavigationBar(_ notification: Notification) {
        guard let navigationItem = notification.object as? BottomNavigationItem else {
            hideBottomNavigation()
            return
        }

        UIView.animate(withDuration: 0.5) {
            self.naviBackground.tintColor = navigationItem.backgroundColor
        }

        handleNavigationItems(leftItems: navigationItem.leftBarButtonItems,
                              rightItems: navigationItem.rightBarButtonItems)
    }

    func bringBottomNavigationBarToFront(_ completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25) {
            self.bottomNavigationContainer.layer.zPosition = 1
            self.bottomNavigationContainer.superview?.bringSubview(toFront: self.bottomNavigationContainer)
        }
    }

    func handleNavigationItems(leftItems: [UIBarButtonItem]?, rightItems: [UIBarButtonItem]?) {
        let navigationItem = UINavigationItem()
        navigationItem.setLeftBarButtonItems(leftItems, animated: false)
        navigationItem.setRightBarButtonItems(rightItems, animated: false)
        bottomNavigationBar.setItems([navigationItem], animated: true)
        bottomNavigationBar.layoutSubviews()
        if (leftItems?.count ?? 0) == 0 && (rightItems?.count ?? 0) == 0 {
            hideBottomNavigation()
        } else {
            showButtomNavigation()
        }
    }
    func hideBottomNavigation() {
        self.bottomNavigationContainer.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.bottomNavigationContainer.alpha = 0
        }
    }

    func showButtomNavigation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomNavigationContainer.alpha = 1
        }, completion: { (finished) in
            self.bottomNavigationContainer.isUserInteractionEnabled = true
        })
        bringBottomNavigationBarToFront()
    }
}
