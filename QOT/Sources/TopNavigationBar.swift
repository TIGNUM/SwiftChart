//
//  TopNavigationBar.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol TopNavigationBarDelegate: class {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem)
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int)
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem)
}

class TopNavigationBar: UINavigationBar {
    private let spacing: CGFloat = 15.0
    private let lineHeight: CGFloat = 1.0

    private var middleButtons: [UIButton]?
    private var currentButton: UIButton?
    let indicatorView: UIView // automatically hidden when setMiddleButtons(buttons.count == 1)
    weak var topNavigationBarDelegate: TopNavigationBarDelegate?
    
    override init(frame: CGRect) {
        indicatorView = UIView()
        indicatorView.backgroundColor = .white
        super.init(frame: frame)
        applyDefaultStyle()
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
        middleButtons?.forEach({ (button: UIButton) in
            button.setTitleColor(tintColor, for: .normal)
        })
        topItem?.leftBarButtonItem?.tintColor = tintColor
        topItem?.rightBarButtonItem?.tintColor = tintColor
        indicatorView.backgroundColor = tintColor
        self.backgroundColor = backgroundColor
    }
    
    func setMiddleButtons(_ buttons: [UIButton]) {
        guard let topItem = topItem, buttons.count > 0 else {
            return
        }
        middleButtons = buttons
        
        // @note unfortunately with the nav titleView it seems much easier to calculate with frames
        var width: CGFloat = 0.0
        for (index, button) in buttons.enumerated() {
            button.addTarget(self, action: #selector(middleButtonPressed(_:)), for: .touchUpInside)
            button.sizeToFit()
            button.tag = index
            width += button.bounds.size.width
        }
        
        let view = UIStackView(arrangedSubviews: buttons)
        view.frame = CGRect(
            x: 0.0,
            y: 0.0,
            width: (width + CGFloat(buttons.count) * spacing),
            height: bounds.size.height
        )
        view.backgroundColor = .clear
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = spacing
        view.addSubview(indicatorView)
        topItem.titleView = view
        
        indicatorView.isHidden = (buttons.count == 1)
        currentButton = buttons[0]
    }
    
    func setLeftButton(_ button: UIBarButtonItem) {
        guard let topItem = topItem else {
            return
        }
        button.target = self
        button.action = #selector(leftButtonPressed(_:))
        topItem.leftBarButtonItem = button
    }
    
    func setRightButton(_ button: UIBarButtonItem) {
        guard let topItem = topItem else {
            return
        }
        button.target = self
        button.action = #selector(rightButtonPressed(_:))
        topItem.rightBarButtonItem = button
    }
    
    func setIndicatorToButtonIndex(_ index: Int, animated: Bool = true) {
        guard let middleButtons = middleButtons, index >= 0, index < middleButtons.count else {
            return
        }
        let button = middleButtons[index]
        setIndicatorToButton(button, animated: animated)
    }
    
    func setIndicatorToButton(_ button: UIButton, animated: Bool = true) {
        guard let titleView = topItem?.titleView, titleView.subviews.contains(button) else {
            return
        }
        // @note unfortunately it seems much easier to animate frames in this case
        let newFrame = CGRect(
            x: button.frame.origin.x,
            y: (titleView.bounds.size.height - self.lineHeight),
            width: button.bounds.size.width,
            height: self.lineHeight
        )
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.indicatorView.frame = newFrame
            }
        } else {
            indicatorView.frame = newFrame
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
        guard let total = middleButtons?.count else {
            return
        }
        topNavigationBarDelegate?.topNavigationBar(self, middleButtonPressed: sender, withIndex: sender.tag, ofTotal: total)
        setIndicatorToButton(sender)
        currentButton = sender
    }
}
