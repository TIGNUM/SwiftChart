//
//  UIView+Autolayout.swift
//  QOT
//
//  Created by Sanggeon Park on 27.08.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

extension UIView {
    func fill(subview: UIView) {
        if subview.superview != self {
            self.addSubview(subview)
        }

        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: subview,
                           attribute: NSLayoutAttribute.centerX,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self,
                           attribute: NSLayoutAttribute.centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: subview,
                           attribute: NSLayoutAttribute.centerY,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self,
                           attribute: NSLayoutAttribute.centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: subview,
                           attribute: NSLayoutAttribute.width,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self,
                           attribute: NSLayoutAttribute.width,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: subview,
                           attribute: NSLayoutAttribute.height,
                           relatedBy: NSLayoutRelation.equal,
                           toItem: self,
                           attribute: NSLayoutAttribute.height,
                           multiplier: 1,
                           constant: 0).isActive = true
    }

    func addConstraints(to superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}
