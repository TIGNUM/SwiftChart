//
//  UIImage+Convenience.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 18/05/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

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
