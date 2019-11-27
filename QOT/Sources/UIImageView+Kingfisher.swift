//
//  UIImageView+Kingfisher.swift
//  QOT
//
//  Created by Sanggeon Park on 31.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {

    func setImage(url: URL?,
                  placeholder: UIImage? = R.image.preloading(),
                  skeletonManager: SkeletonManager? = nil, _ completion: @escaping (UIImage?) -> Void) {
        if let localImageURL = url, localImageURL.isFileURL {
            // To load local Image file with Kingfisher, we have to use LocalFileImageDataProvider.
            let provider = LocalFileImageDataProvider(fileURL: localImageURL)
            self.kf.setImage(with: provider, placeholder: placeholder, options: nil, progressBlock: nil) { (result) in
                skeletonManager?.hide()
                switch result {
                case .success(let value): completion(value.image)
                default: completion(nil)
                }

            }
        } else {
            self.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil) { (result) in
                skeletonManager?.hide()
                switch result {
                case .success(let value): completion(value.image)
                default: completion(nil)
                }
            }
        }
    }
}
