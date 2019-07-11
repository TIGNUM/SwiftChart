//
//  RoundedButton.swift
//  ActionSheetPicker-3.0
//
//  Created by Anais Plancoulaine on 03.07.19.
//

import UIKit

class RoundedButton: UIButton {

    private let borderColorActive = UIColor.accent40
    private let borderColorInactive = UIColor.sand08

    private let activeColor = UIColor.accent
    private let inactiveColor = UIColor.sand08

    override var isEnabled: Bool {
        didSet {
            self.layer.borderColor = self.isEnabled ? borderColorActive.cgColor : borderColorInactive.cgColor
        }
    }

    init(title: String, target: Any, action: Selector) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        setAttributedTitle(NSAttributedString(string: title ?? ""), for: .normal)
    }

    override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControlState) {
        // Desired
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.kern: 0.4,
            NSAttributedStringKey.foregroundColor: activeColor,
            NSAttributedStringKey.font: UIFont.sfProtextSemibold(ofSize: 14)]
        let desiredTitle = NSMutableAttributedString(attributedString: title ?? NSAttributedString(string: ""))
        desiredTitle.addAttributes(attributes, range: NSRange(location: 0, length: desiredTitle.length))
        super.setAttributedTitle(desiredTitle, for: state)

        // Disabled
        if state != .disabled {
            let attributes: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey.kern: 0.4,
                NSAttributedStringKey.foregroundColor: inactiveColor,
                NSAttributedStringKey.font: UIFont.sfProtextSemibold(ofSize: 14)]
            let disabledTitle = NSMutableAttributedString(attributedString: title ?? NSAttributedString(string: ""))
            disabledTitle.addAttributes(attributes, range: NSRange(location: 0, length: disabledTitle.length))
            super.setAttributedTitle(disabledTitle, for: .disabled)
        }
    }

    func setup() {
        self.tintColor = activeColor

        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = borderColorActive.cgColor

        let verticalInset: CGFloat = 11
        let horizontalInset: CGFloat = 16
        contentEdgeInsets = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = fmin(self.frame.size.width, self.frame.size.height)/2.0
    }
}
