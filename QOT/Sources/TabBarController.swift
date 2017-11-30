//
//  TabBarController.swift
//  QOT
//
//  Created by Lee Arromba on 17/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol TabBarControllerDelegate: class {
    
    func tabBarController(_ tabBarController: TabBarController, didSelect viewController: UIViewController, at index: Int)
}

final class TabBarController: UITabBarController {
    
    struct Config {
        var tabBarBackgroundColor: UIColor
        var tabBarBackgroundImage: UIImage?
        var tabBarShadowImage: UIImage?
        var useIndicatorView: Bool
        var indicatorViewHeight: CGFloat
        var indicatorViewColor: UIColor
        var indicatorViewSidePadding: CGFloat
        var readFlagPadding: CGFloat
        
        static var `default` = Config(
            tabBarBackgroundColor: .clear,
            tabBarBackgroundImage: UIImage(),
            tabBarShadowImage: UIImage(),
            useIndicatorView: true,
            indicatorViewHeight: 1.0,
            indicatorViewColor: .white,
            indicatorViewSidePadding: 20.0,
            readFlagPadding: 2.0
        )
    }
    
    weak var tabBarControllerDelegate: TabBarControllerDelegate?
    private var indicatorView: UIView?
    private var indicatorViewLeftConstraint: NSLayoutConstraint?
    private var indicatorViewWidthConstraint: NSLayoutConstraint?
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apply(config)
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if config.useIndicatorView {
            if indicatorView == nil {
                setupIndicatorView()
            }
            setIndicatorViewToButtonIndex(selectedIndex, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFlagFrames() // unfortunately we can't manage any auto-layout constraints in UITabBar (iOS forbids it by crashing), so we resort to frame based positioning. This means we must relayout any unread flags (the dots) when viewDidLayoutSubviews() is called
    }
    
    func frameForButton(at index: Int) -> CGRect? {
        guard let items = tabBar.items, index >= items.startIndex, index < items.endIndex else {
            assertionFailure("index \(index) out of bounds")
            return nil
        }
        let buttonWidth = (items.count == 0) ? tabBar.bounds.width : (tabBar.bounds.width / CGFloat(items.count))
        return CGRect(
            x: (index == 0) ? 0 : buttonWidth * CGFloat(index),
            y: tabBar.frame.origin.y,
            width: buttonWidth,
            height: tabBar.frame.height
        )
    }
    
    func setIndicatorViewToButtonIndex(_ index: Int, animated: Bool) {
        guard let indicatorView = indicatorView else { return }
        guard let items = tabBar.items, index >= items.startIndex, index < items.endIndex else {
            indicatorView.backgroundColor = .clear
            return
        }
        tabBar.bringSubview(toFront: indicatorView)
        tabBar.layoutIfNeeded()

        let textWidth = items[selectedIndex].textWidth + config.indicatorViewSidePadding
        let x = (tabBar.buttonWidth * CGFloat(selectedIndex)) + (tabBar.buttonWidth / 2.0) - (textWidth / 2.0)
        let animations: () -> Void = {
            self.indicatorViewWidthConstraint?.constant = textWidth
            self.indicatorViewLeftConstraint?.constant = x
            self.tabBar.layoutIfNeeded()
        }
        if animated {
            UIView.animate(withDuration: Layout.TabBarView.animationDuration, delay: 0, options: .curveEaseInOut, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func mark(isRead: Bool, at index: Int) {
        guard let items = tabBar.items, index >= items.startIndex, index < items.endIndex, let item = items[index] as? TabBarItem else {
            assertionFailure("index \(index) out of bounds")
            return
        }
        item.isRead = isRead
        updateFlags()
    }
    
    func updateFlags() {
        guard let items = tabBar.items as? [TabBarItem] else { return }
        items.forEach { (item: TabBarItem) in
            if item.isRead == true {
                item.readFlag?.removeFromSuperview()
                item.readFlag = nil
            } else if item.readFlag == nil {
                item.readFlag = tabBar.addBadge(origin: .zero)
            }
        }
        updateFlagFrames()
    }
    
    // MARK: - private
    
    private func setupIndicatorView() {
        guard let items = tabBar.items, selectedIndex >= items.startIndex, selectedIndex < items.endIndex else { return }
        let indicatorView = UIView()
        indicatorView.backgroundColor = config.indicatorViewColor
        tabBar.addSubview(indicatorView)
        
        let height: CGFloat = config.indicatorViewHeight
        indicatorView.bottomAnchor == tabBar.safeBottomAnchor - height
        indicatorView.heightAnchor == height
        indicatorViewWidthConstraint = indicatorView.widthAnchor == 0
        indicatorViewLeftConstraint = indicatorView.leftAnchor == tabBar.leftAnchor
        self.indicatorView = indicatorView
    }
    
    private func apply(_ config: Config) {
        tabBar.backgroundColor = config.tabBarBackgroundColor
        tabBar.backgroundImage = config.tabBarBackgroundImage
        tabBar.shadowImage = config.tabBarShadowImage
    }
    
    private func updateFlagFrames() {
        guard let items = tabBar.items as? [TabBarItem] else { return }
        for (index, item) in items.enumerated() {
            guard let flag = item.readFlag else { return }
            flag.frame = CGRect(origin: CGPoint(
                x: ((tabBar.buttonWidth * CGFloat(index)) +
                    (tabBar.buttonWidth - item.textWidth) +
                    config.readFlagPadding),
                y: -config.readFlagPadding
            ), size: flag.bounds.size)
        }
    }
}

// MARK: - UITabBarDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.index(of: viewController), index != NSNotFound else {
            assertionFailure("index not found")
            return
        }
        tabBarControllerDelegate?.tabBarController(self, didSelect: viewController, at: index)
        if config.useIndicatorView {
            setIndicatorViewToButtonIndex(index, animated: true)
        }
    }
}

// MARK: - UITabBarItem

private extension UITabBarItem {
    
    var textWidth: CGFloat {
        guard let title = title as NSString?, let attributes = titleTextAttributes(for: .normal) else {
            return 0.0
        }
        let convertedAttributes = Dictionary(uniqueKeysWithValues:
            attributes.lazy.map { (NSAttributedStringKey($0.key), $0.value) }
        )
        return title.size(withAttributes: convertedAttributes).width
    }
}

// MARK: - UITabBar

private extension UITabBar {
    
    var buttonWidth: CGFloat {
        guard let items = items else { return 0.0 }
        return (items.count == 0) ? bounds.width : (bounds.width / CGFloat(items.count))
    }
}
