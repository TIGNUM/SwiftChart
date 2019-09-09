//
//  DecisionTreeButton.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractTreeButton: UIButton {

    var maxPossibleSelections: Int = 0

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

    private var type = DecisionTreeType.mindsetShifter

    convenience init(title: String, backgroundColor: UIColor, titleColor: UIColor, type: DecisionTreeType) {
        self.init(frame: .Default)
        configure(title: title, backgroundColor: backgroundColor, titleColor: titleColor, type: type)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerDefault()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cornerDefault()
    }

    func configure(title: String, backgroundColor: UIColor, titleColor: UIColor, type: DecisionTreeType) {
        setAttributedTitle(attributedString(title, titleColor), for: .normal)
        self.backgroundColor = backgroundColor
        self.type = type
    }

    func update(currentValue: Int, maxSelections: Int, defaultTitle: String, confirmationTitle: String) {
        isHidden = confirmationTitle.isEmpty && defaultTitle.isEmpty
        guard !isHidden else { return }

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
