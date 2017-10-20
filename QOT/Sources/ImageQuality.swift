//
//  ImageQuality.swift
//  QOT
//
//  Created by Lee Arromba on 19/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum ImageQuality {
    case high
    case medium
    case low
    
    var compressionRatio: CGFloat {
        switch self {
        case .high: return 1.0
        case .medium: return 0.5
        case .low: return 0.1
        }
    }
}

enum ImageSize {
    case large
    case medium
    case small
    
    var scaleFactor: CGFloat {
        switch self {
        case .large: return 1.0
        case .medium: return 0.5
        case .small: return 0.1
        }
    }
    
    func scaleSize(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
    }
}

extension UIImage {
    func withQuality(_ quality: ImageQuality, size: ImageSize) -> UIImage? {
        guard
            let compressedImageData = UIImageJPEGRepresentation(self, quality.compressionRatio),
            let compressedImage = UIImage(data: compressedImageData)?.scaledToSize(size.scaleSize(self.size)) else {
                return nil
        }
        return compressedImage
    }
    
    func scaledToSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
        draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
