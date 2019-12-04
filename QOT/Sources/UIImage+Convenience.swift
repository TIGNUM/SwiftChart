//
//  UIImage+Convenience.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 18/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(view: UIView) {

        var renderedImage = UIImage()
        UIGraphicsBeginImageContext(view.frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            view.layer.render(in: currentContext)
            if let image = UIGraphicsGetImageFromCurrentImageContext() { renderedImage = image }
            UIGraphicsEndImageContext()
        }

        guard let cgImage = renderedImage.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage {
    func imageWithAlpha(alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint(), blendMode: .normal, alpha: alpha)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return newImage
    }
}
