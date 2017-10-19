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
        case .high:
            return 1.0
        case .medium:
            return 0.5
        case .low:
            return 0.1
        }
    }
}

extension UIImage {
    func withQuality(_ quality: ImageQuality) -> UIImage? {
        guard
            let compressedImageData = UIImageJPEGRepresentation(self, quality.compressionRatio),
            let compressedImage = UIImage(data: compressedImageData) else {
                return nil
        }
        return compressedImage
    }
}
