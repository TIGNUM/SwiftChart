//
//  UIGestureRecognizer+ClickableLabel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 04/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UITapGestureRecognizer {

    // Return the link that was tapped or nil if no link was tapped
    func didTapAttributedTextInLabel(label: ClickableLabel) -> String? {

        guard let labelAttributedString = label.attributedText else { return nil }

        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(attributedString: labelAttributedString)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        layoutManager.usesFontLeading = false
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        // convert location from label.bounds to textBoundingBox
        guard label.bounds.size.height > 0, label.bounds.size.width > 0 else {
            return nil
        }
        let xScaleFactor = textBoundingBox.height / label.bounds.size.height
        let yScaleFactor = textBoundingBox.width / label.bounds.size.width
        let normalizedTouch = CGPoint(
            x: locationOfTouchInLabel.x * xScaleFactor,
            y: locationOfTouchInLabel.y * yScaleFactor
        )
        
        // return link for character index
        let indexOfCharacter = layoutManager.characterIndex(
            for: normalizedTouch,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        for link in label.links where NSLocationInRange(indexOfCharacter, link.range) {
            return link.link
        }
        return nil
    }
}
