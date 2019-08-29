//
//  UISegmentedControl+Underline.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 29/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func underline() -> (xCentre: CGFloat, width: CGFloat) {
        if numberOfSegments == 0 {
            return (0, 0)
        }

        let currentIndex = selectedSegmentIndex
        let widthSegment = bounds.width / CGFloat(numberOfSegments)
        let xCentre = CGFloat(currentIndex) * widthSegment + widthSegment / 2

        var width = widthSegment
        if let font = titleTextAttributes(for: .normal)?[NSAttributedStringKey.font] as? UIFont {
            let text = titleForSegment(at: currentIndex)
            width = text?.size(with: font).width ?? widthSegment
        }
        return (xCentre, width)
    }
}
