//
//  UIView+Layers.swift
//  QOT
//
//  Created by Moucheg Mouradian on 13/06/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIView {
    func maskCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    func corner(radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat = 1) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
    }

    func corner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func circle() {
        corner(radius: frame.height * 0.5)
    }

    func cornerDefault() {
        corner(radius: 20)
    }
}

extension UIView {
    func gradientBackground(top: Bool) {
        guard let image = top ? R.image.topGradient() : R.image.bottomGradient() else { return }
        let imageView = UIImageView(frame: CGRect(x: 0, y: top ? 0 : bounds.height - image.size.height, width: bounds.width, height: image.size.height))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)

        addConstraint(NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: image.size.height))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: top ? .top : .bottom, relatedBy: .equal, toItem: self, attribute: top ? .top : .bottom, multiplier: 1.0, constant: 0.0))
    }

    func takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image != nil {
            return image!
        }
        return UIImage()
    }
}
