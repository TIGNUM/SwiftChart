//
//  DecisionTreeButton.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 12.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AbstractTreeButton: AnimatedButton {

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
        setAttributedTitle(ThemeText.chatbotButton.attributedString(title), for: .normal)
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
        selectionLabel.attributedText = ThemeText.chatbotButton.attributedString(title)
        switchBackgroundColor()
        corner(radius: .Twenty, borderColor: .accent40)
    }

    func switchBackgroundColor() {
        backgroundColor = (backgroundColor == defaultBackgroundColor) ? selectedBackgroundColor : defaultBackgroundColor
    }
}

final class NavigationButton: AbstractTreeButton {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var continueLabel: UILabel!
    @IBOutlet private weak var counterButton: UIButton!
    @IBOutlet private weak var constraintTotalWidthMin: NSLayoutConstraint!
    @IBOutlet private weak var constraintSpacerWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintLeftMargin: NSLayoutConstraint!

    private var isDark = false
    private var titleFirst = ""
    private var titleNext = ""
    private var title = ""
    private var maxCount = 1
    private var minCount = 1

    private var spacerWidth: CGFloat = 0.0
    private var completion:(() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        addObserver()
        spacerWidth = constraintSpacerWidth.constant
        containerView.cornerDefault()
        configure(title: "", minSelection: 1, isDark: isDark)
    }

    static func instantiateFromNib() -> NavigationButton {
        guard let view = R.nib.navigationButton.instantiate(withOwner: self).first as? NavigationButton else {
            fatalError("Cannot load view")
        }
        return view
    }

    func getCurrentTitle() -> String {
        if titleFirst.isEmpty == false {
            return titleFirst
        }
        if titleNext.isEmpty == false {
            return titleNext + " " + (continueLabel.text ?? "")
        }
        return title
    }

    func configure(title: String, titleNext: String = "", minSelection: Int, staticWidth: Bool = false, isDark: Bool) {
        self.titleFirst = title
        self.titleNext = titleNext.isEmpty ? titleFirst : titleNext
        self.minCount = minSelection
        self.isDark = isDark

        if staticWidth {
            let width1 = ThemeText.chatbotProgress(false, isDark).attributedString(titleFirst).size().width
            let width2 = ThemeText.chatbotProgress(false, isDark).attributedString(titleNext + "3/3").size().width + spacerWidth
            let designerMargin: CGFloat = constraintLeftMargin.constant * 2
            constraintTotalWidthMin.constant = max(width1, width2) + designerMargin
        } else {
            constraintTotalWidthMin.constant = 0.0 //small value means it will grow/shrink
        }

        update(count: 0, maxSelections: 1)
    }

    func update(count: Int, maxSelections: Int? = nil) {
        if let maxSelections = maxSelections {
            maxCount = maxSelections
        }

        isHidden = maxCount == 0

        let isEnough = count >= minCount
        counterButton.isUserInteractionEnabled = isEnough

        if count == 0 && !isEnough {
            title = substitute(titleFirst)
            ThemeText.chatbotProgress(false, isDark).apply(title, to: continueLabel)
            ThemeView.chatbotProgress(false, isDark).apply(containerView)
            counterLabel.text = ""
            constraintSpacerWidth.constant = 0.0
        } else {
            title = substitute(titleNext)
            ThemeView.chatbotProgress(isEnough, isDark).apply(containerView)
            ThemeText.chatbotProgress(isEnough, isDark).apply(title, to: continueLabel)
            let counterText = maxCount <= 1 ? "" : "\(count)/\(maxCount)"
            ThemeText.chatbotProgress(isEnough, isDark).apply(counterText, to: counterLabel)
            constraintSpacerWidth.constant = counterText.isEmpty ? 0.0 : spacerWidth
        }

        UIView.animate(withDuration: 0.25) {
            self.setShadow(isEnough)  //this already calls self.layoutIfNeeded()
        }
    }

    func setOnPressed(completion: @escaping () -> Void) {
        self.completion = completion
    }

    @IBAction func didPressButton() {
        completion?()
    }
}

extension NavigationButton {
    private func substitute(_ text: String) -> String {
        if text.contains("%d") {
            return String(format: text, maxCount)
        } else {
            return text
        }
    }

    func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didUpdateSelectionCounter(_:)),
                                               name: .didUpdateSelectionCounter,
                                               object: nil)
    }

    @objc func didUpdateSelectionCounter(_ notification: Notification) {
        if let counter = notification.userInfo?[UserInfo.multiSelectionCounter.rawValue] as? Int {
            let count = counter > maxCount ? maxCount : counter
            update(count: count)
            pulsate()
        }
    }
}
