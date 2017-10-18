//
//  TopNavigationBar.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import Anchorage

protocol TopNavigationBarDelegate: class {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem)

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int)
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem)
}

final class TopNavigationBar: UINavigationBar {

    private let spacing: CGFloat = 15.0
    private let lineHeight: CGFloat = 1.0
    private var middleButtons: [UIButton]?
    private var currentButton: UIButton?
    private var whatsHotBadgeCenter: CGPoint = .zero
    private var indicatorViewWidthConstraint: NSLayoutConstraint!
    private var indicatorViewLeftConstraint: NSLayoutConstraint!
    let indicatorView: UIView // automatically hidden when setMiddleButtons(buttons.count == 1)
    weak var topNavigationBarDelegate: TopNavigationBarDelegate?
    
    override init(frame: CGRect) {
        indicatorView = UIView()
        indicatorView.backgroundColor = .white

        super.init(frame: frame)
        
        applyDefaultStyle()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserDefaultsDidChangeNotification), name: UserDefaults.didChangeNotification, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let currentButton = currentButton else {
            return
        }
        setIndicatorToButton(currentButton, animated: false)
    }
    
    func setStyle(tintColor: UIColor, backgroundColor: UIColor) {
        middleButtons?.forEach { (button: UIButton) in
            button.setTitleColor(tintColor, for: .normal)
        }

        topItem?.leftBarButtonItem?.tintColor = tintColor
        topItem?.rightBarButtonItem?.tintColor = tintColor
        indicatorView.backgroundColor = tintColor
        self.backgroundColor = backgroundColor
    }
    
    func setMiddleButtons(_ buttons: [UIButton]) {
        guard let topItem = topItem, buttons.count > 0 else {
            return
        }
        let firstButton = buttons[0]
        middleButtons = buttons
        currentButton = firstButton
        for (index, button) in buttons.enumerated() {
            button.addTarget(self, action: #selector(middleButtonPressed(_:)), for: .touchUpInside)
            button.sizeToFit()
            button.tag = index
        }
        
        let view = UIStackView(arrangedSubviews: buttons)
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = spacing
        view.addSubview(indicatorView)
        topItem.titleView = view

        indicatorView.bottomAnchor == view.bottomAnchor - lineHeight
        indicatorView.heightAnchor == lineHeight
        indicatorViewWidthConstraint = indicatorView.widthAnchor == firstButton.bounds.width
        indicatorViewLeftConstraint = indicatorView.leftAnchor == firstButton.leftAnchor
        indicatorView.isHidden = (buttons.count == 1)
    }
    
    func setLeftButton(_ button: UIBarButtonItem) {
        guard let topItem = topItem else { return }

        button.target = self
        button.action = #selector(leftButtonPressed(_:))
        topItem.leftBarButtonItem = button
    }
    
    func setRightButton(_ button: UIBarButtonItem) {
        guard let topItem = topItem else { return }

        button.target = self
        button.action = #selector(rightButtonPressed(_:))
        topItem.rightBarButtonItem = button
    }

    @objc func handleUserDefaultsDidChangeNotification() {
        DispatchQueue.main.async { [weak self] in
            self?.addWhatsHotBadgeIfNeeded()
        }
    }

    func addWhatsHotBadgeIfNeeded() {
        if UserDefault.newWhatsHotArticle.boolValue == true && middleButtons?.last?.titleLabel?.text == R.string.localized.topTabBarItemTitleLearnWhatsHot().uppercased(),
            let buttonFrame = middleButtons?.first?.frame {
                let centerX = (frame.width * 0.5) + buttonFrame.width
                whatsHotBadgeCenter = CGPoint(x: centerX, y: 12)
                drawCapRoundCircle(center: whatsHotBadgeCenter, radius: 3, value: 3, lineWidth: 3, strokeColor: .cherryRed)
        }
    }

    private func removeWhatsHotBadgeIfNeeded() {
        if UserDefault.newWhatsHotArticle.boolValue == true && middleButtons?.last?.titleLabel?.text == R.string.localized.topTabBarItemTitleLearnWhatsHot().uppercased() {
            layer.sublayers?.forEach { (layer) in
                if let shapeLayer = layer as? CAShapeLayer {
                    if shapeLayer.lineCap == kCALineCapRound && shapeLayer.path?.contains(whatsHotBadgeCenter) == true {
                        shapeLayer.removeFromSuperlayer()
                        UserDefault.newWhatsHotArticle.setBoolValue(value: false)
                    }
                }
            }
        }
    }
    
    func setIndicatorToButtonIndex(_ index: Int, animated: Bool = true) {
        guard let middleButtons = middleButtons, index >= 0, index < middleButtons.count else { return }

        setIndicatorToButton(middleButtons[index], animated: animated)
    }
    
    func setIndicatorToButton(_ button: UIButton, animated: Bool = true) {
        guard let titleView = topItem?.titleView, titleView.subviews.contains(button) else {
            return
        }
        indicatorViewWidthConstraint.constant = button.bounds.width
        indicatorViewLeftConstraint.constant = button.frame.origin.x
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - private
    
    @objc private func leftButtonPressed(_ sender: UIBarButtonItem) {
        topNavigationBarDelegate?.topNavigationBar(self, leftButtonPressed: sender)
    }
    
    @objc private func rightButtonPressed(_ sender: UIBarButtonItem) {
        topNavigationBarDelegate?.topNavigationBar(self, rightButtonPressed: sender)
    }
    
    @objc private func middleButtonPressed(_ sender: UIButton) {
        guard let total = middleButtons?.count else { return }
        topNavigationBarDelegate?.topNavigationBar(self, middleButtonPressed: sender, withIndex: sender.tag, ofTotal: total)
        setIndicatorToButton(sender)
        currentButton = sender
        removeWhatsHotBadgeIfNeeded()
    }
}
