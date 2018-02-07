//
//  PlaceholderTextView.swift
//  QOT
//
//  Created by Lee Arromba on 05/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PlaceholderTextViewDelegate: class {

    func placeholderDidChange(_ placeholderTextView: PlaceholderTextView)
}

final class PlaceholderTextView: UITextView {

    private var placeholderText: String?
    private var plachholderTextColor: UIColor?
    private var originalTextColor: UIColor?
    private var isPlaceholderShowing: Bool = false
    weak var placeholderDelegate: PlaceholderTextViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        originalTextColor = textColor
    }

    func didBeginEditing() {
        if isPlaceholderShowing == true {
            showPlaceholder(false)
        }
    }

    func didEndEditing() {
        if text.isEmpty == true {
            showPlaceholder(true)
        }
    }

    func set(placeholderText: String?, placeholdeColor: UIColor?) {
        self.placeholderText = placeholderText
        self.plachholderTextColor = placeholdeColor
        if text.isEmpty == true {
            showPlaceholder(true)
        }
    }

    lazy var numberOfLines: Float = {
        guard let font = font else { return text.isEmpty == true ? 0 : 1 }
        return floorf(Float(contentSize.height / font.lineHeight))
    }()
}

// MARK: - Private

private extension PlaceholderTextView {

    func showPlaceholder(_ isShowing: Bool) {
        isPlaceholderShowing = isShowing
        text = isShowing == true ? placeholderText : nil
        textColor = isShowing == true ? plachholderTextColor : originalTextColor
        placeholderDelegate?.placeholderDidChange(self)
    }
}
