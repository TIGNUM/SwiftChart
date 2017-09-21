//
//  UINavigationBar+Style.swift
//  QOT
//
//  Created by Lee Arromba on 27/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func applyDefaultStyle() {
        titleTextAttributes = [.foregroundColor: UIColor.white,
                               .font: Font.H6NavigationTitle]
        let dummyImage = UIImage()
        setBackgroundImage(dummyImage, for: .default)
        shadowImage = dummyImage
        isTranslucent = true
    }
}
