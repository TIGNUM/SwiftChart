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
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: subview,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: subview,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .width,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: subview,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .height,
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

extension UIView {
    func edges(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
                                     rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
                                     topAnchor.constraint(equalTo: view.topAnchor, constant: top),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)])
    }
}
