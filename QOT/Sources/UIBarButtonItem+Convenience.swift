//
//  UIBarButtonItem+TopTabBar.swift
//  QOT
//
//  Created by Lee Arromba on 28/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(withImage image: UIImage?, tintColor: UIColor = .white) {
        self.init(image: image, style: .plain, target: nil, action: nil)
        self.tintColor = tintColor
    }

    static var info: UIBarButtonItem {
        let button = UIBarButtonItem(withImage: R.image.explainer_ico())
      /// button.tintColor = .white40
        return button
    }
}
