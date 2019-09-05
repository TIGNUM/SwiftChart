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

    convenience init(from button: UIButton) {
        self.init(customView: button)
    }

    static var info: UIBarButtonItem {
        let button = UIBarButtonItem(withImage: R.image.explainer_ico()?.withRenderingMode(.alwaysTemplate))
        button.tintColor = .white60
        return button
    }

    static var close: UIBarButtonItem {
        let button = UIBarButtonItem(withImage: R.image.ic_close()?.withRenderingMode(.alwaysTemplate))
        button.tintColor = .white60
        return button
    }

    static var burger: UIBarButtonItem {
        let button = UIBarButtonItem(withImage: R.image.ic_menu()?.withRenderingMode(.alwaysTemplate))
        button.tintColor = .white60
        return button
    }
}
