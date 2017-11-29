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

    private(set) var placeholderText: String?
    private(set) var plachholderTextColor: UIColor?
    private var originalTextColor: UIColor?
    private var isPlaceholderShowing: Bool = false
    weak var placeholderDelegate: PlaceholderTextViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        originalTextColor = textColor
        tintColor = .white
    }

    func didBeginEditing() {
        if isPlaceholderShowing {
            showPlaceholder(false)
        }
    }

    func didEndEditing() {
        if text.isEmpty {
            showPlaceholder(true)
        }
    }

    func set(placeholderText: String?, placeholdeColor: UIColor?) {
        self.placeholderText = placeholderText
        self.plachholderTextColor = placeholdeColor
        if text.isEmpty {
            showPlaceholder(true)
        }
    }
}

// MARK: - Private

private extension PlaceholderTextView {

    func showPlaceholder(_ isShowing: Bool) {
        isPlaceholderShowing = isShowing
        if isShowing {
            text = placeholderText
            textColor = plachholderTextColor
        } else {
            text = nil
            textColor = originalTextColor
        }
        placeholderDelegate?.placeholderDidChange(self)
    }
}
