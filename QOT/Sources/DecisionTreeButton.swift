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
                   selectedBackgroundColor: UIColor,
                   defaultBackgroundColor: UIColor,
                   borderColor: UIColor?,
                   titleColor: UIColor,
                   maxPossibleSelections: Int? = nil) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.layer.borderColor = borderColor?.cgColor
        self.selectedBackgroundColor = selectedBackgroundColor
        self.defaultBackgroundColor = defaultBackgroundColor
        self.backgroundColor = defaultBackgroundColor
        self.maxPossibleSelections = maxPossibleSelections ?? 0
    }

    func update() {
        backgroundColor = backgroundColor == defaultBackgroundColor ? selectedBackgroundColor : defaultBackgroundColor
    }

    func update(with value: Int, defaultTitle: String, confirmationTitle: String, questionKey: String, maxSelections: Int) {
        let title = value == maxSelections ? confirmationTitle : "Pick \(maxSelections - value) to continue"
        backgroundColor = value == maxPossibleSelections ? selectedBackgroundColor : defaultBackgroundColor
        setTitle(title, for: .normal)
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
}

// MARK: - Setup

private extension DecisionTreeButton {

    func setupView() {
        layer.borderWidth = 1.4
    }
}
