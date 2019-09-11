//
//  DecisionTreeButton.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractTreeButton: UIButton {
    func attributedString(_ title: String, _ textColor: UIColor) -> NSAttributedString {
        return NSAttributedString(string: title,
                                  letterSpacing: 0.2,
                                  font: .sfProtextSemibold(ofSize: 14),
                                  lineSpacing: 4,
                                  textColor: textColor,
                                  alignment: .center)
    }

    func setShadow(_ isHighLighted: Bool) {
        if isHighLighted {
            layer.shadowOffset = CGSize(width: 0, height: 1)
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowOpacity = 1
            layer.shadowRadius = 5
            layer.masksToBounds = false
        } else {
            layer.shadowOpacity = 0
        }
        layoutIfNeeded()
    }
}

final class AnswerButton: AbstractTreeButton {

    private var selectedBackgroundColor = UIColor.clear
    private var defaultBackgroundColor = UIColor.red

    func configure(title: String, isSelected: Bool) {
        defaultBackgroundColor = isSelected ? .accent30 : .clear
        selectedBackgroundColor = isSelected ? .clear : .accent30
        setAttributedTitle(attributedString(title, .accent), for: .normal)
        corner(radius: .Twenty, borderColor: .accent40)
    }

    func switchBackgroundColor() {
        backgroundColor = (backgroundColor == defaultBackgroundColor) ? selectedBackgroundColor : defaultBackgroundColor
    }
}

final class SelectionButton: AbstractTreeButton {

    @IBOutlet private weak var selectionLabel: UILabel!
    private var selectedBackgroundColor = UIColor.clear
    private var defaultBackgroundColor = UIColor.red

    func configure(title: String, isSelected: Bool) {
        defaultBackgroundColor = isSelected ? .accent30 : .clear
        selectedBackgroundColor = isSelected ? .clear : .accent30
        selectionLabel.attributedText = attributedString(title, .accent)
        switchBackgroundColor()
        selectionLabel.corner(radius: .Twenty, borderColor: .accent40)
    }

    func switchBackgroundColor() {
        selectionLabel.backgroundColor = (selectionLabel.backgroundColor == defaultBackgroundColor) ? selectedBackgroundColor : defaultBackgroundColor
    }
}

final class NavigationButton: AbstractTreeButton {

    // MARK: - Properties
    private var type = DecisionTreeType.mindsetShifter
    private var maxSelections = 0
    private var currentValue = 0
    private var defaultTitle = ""
    private var confirmationTitle = ""

    // MARK: - Init
    convenience init(title: String, type: DecisionTreeType, enabled: Bool) {
        self.init(frame: .Default)
        configure(title: title,
                  backgroundColor: type.barButtonBackgroundColor(enabled),
                  titleColor: type.barButtonTextColor(enabled),
                  type: type)
    }

    convenience init(title: String, backgroundColor: UIColor, titleColor: UIColor, type: DecisionTreeType) {
        self.init(frame: .Default)
        configure(title: title, backgroundColor: backgroundColor, titleColor: titleColor, type: type)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerDefault()
        addObserver()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cornerDefault()
        addObserver()
    }

    // MARK: Configuration
    func configure(title: String, backgroundColor: UIColor, titleColor: UIColor, type: DecisionTreeType) {
        setAttributedTitle(attributedString(title, titleColor), for: .normal)
        self.backgroundColor = backgroundColor
        self.type = type
    }

    func update(currentValue: Int, maxSelections: Int, defaultTitle: String, confirmationTitle: String) {
        self.currentValue = currentValue
        self.maxSelections = maxSelections
        self.defaultTitle = defaultTitle
        self.confirmationTitle = confirmationTitle
        syncButton(currentValue)
    }
}

// MARK: Event handling
private extension NavigationButton {
    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateSelectionCounter(_:)),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
    }

    @objc func didUpdateSelectionCounter(_ notification: Notification) {
        if let counter = notification.userInfo?[UserInfo.multiSelectionCounter.rawValue] as? Int {
            currentValue = counter > maxSelections ? 0 : counter
            syncButton(currentValue)
        }
    }

    func syncButton(_ currentValue: Int) {
        let isEnabled = currentValue == maxSelections
        let buttonTitle = isEnabled ? (!confirmationTitle.isEmpty ? confirmationTitle : defaultTitle) : defaultTitle
        let textColor = type.barButtonTextColor(isEnabled)
        let updatedTitle = isEnabled ? buttonTitle : R.string.localized.buttonTitlePick(maxSelections - currentValue)
        setAttributedTitle(attributedString(updatedTitle, textColor), for: .normal)
        isUserInteractionEnabled = isEnabled
        backgroundColor = type.barButtonBackgroundColor(isEnabled)
        setShadow(isEnabled)
    }
}
