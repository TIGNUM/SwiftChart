//
//  DecisionTreeButton.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DecisionTreeButton: UIButton {

    // MARK: - Properties
    private var selectedBackgroundColor: UIColor? = .clear
    private var defaultBackgroundColor: UIColor? = .red
    private var maxPossibleSelections: Int = 0

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}

// MARK: - Configure
extension DecisionTreeButton {

    func configure(with title: String,
                   attributedTitle: NSAttributedString? = nil,
                   selectedBackgroundColor: UIColor,
                   defaultBackgroundColor: UIColor,
                   borderColor: UIColor?,
                   titleColor: UIColor) {
        if let attributedTitle = attributedTitle {
            setAttributedTitle(attributedTitle, for: .normal)
        } else {
            setTitle(title, for: .normal)
            setTitleColor(titleColor, for: .normal)
        }
        self.layer.borderColor = borderColor?.cgColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.defaultBackgroundColor = defaultBackgroundColor
        self.backgroundColor = defaultBackgroundColor
    }

    func update() {
        backgroundColor = (backgroundColor == defaultBackgroundColor) ? selectedBackgroundColor : defaultBackgroundColor
    }

    func update(with value: Int, defaultTitle: String, confirmationTitle: String, maxSelections: Int) {
        let result = maxSelections - value
        let title = value == maxSelections ? confirmationTitle : R.string.localized.buttonTitlePick(result)
        backgroundColor = value == maxSelections ? selectedBackgroundColor : defaultBackgroundColor
        let titleColor: UIColor = value == maxSelections ? .accent : .carbon30
        setAttributedTitle(NSAttributedString(string: title,
                                              letterSpacing: 0.2,
                                              font: .sfProtextSemibold(ofSize: 14),
                                              lineSpacing: 8,
                                              textColor: titleColor),
                           for: .normal)
        if value == 4 {
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOpacity = 1
            layer.shadowRadius = 5
            layer.masksToBounds = false
        } else {
            layer.shadowOpacity = 0
        }
    }

    func toBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(customView: self)
    }
}

// MARK: - Setup
private extension DecisionTreeButton {
    func setupView() {
        layer.borderWidth = 1.4
        titleLabel?.numberOfLines = 0
        titleEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    }
}
