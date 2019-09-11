//
//  BottomNavigationBar.swift
//  LevelNavigationDemo
//
//  Created by Sanggeon Park on 25.06.19.
//  Copyright © 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

class BottomNavigationBar: UINavigationBar {

    override func willMove(toWindow newWindow: UIWindow?) {
        self.autoresizesSubviews = false
        self.translatesAutoresizingMaskIntoConstraints = false
        super.willMove(toWindow: newWindow)
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        self.isTranslucent = true
        backgroundColor = .clear
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        recursiveClipToBounds(false, for: self)
    }

    func recursiveClipToBounds(_ value: Bool, for view: UIView) {
        for subview in view.subviews {
            if let button = subview as? UIButton {
                if let coachButton = button as? CoachButton {
                    coachButton.clipsToBounds = false
                    recursiveClipToBounds(value, for: coachButton)
                }
            } else {
                subview.clipsToBounds = false
                recursiveClipToBounds(value, for: subview)
            }
        }
    }
}
