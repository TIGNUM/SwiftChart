//
//  RoundedButton.swift
//  ActionSheetPicker-3.0
//
//  Created by Anais Plancoulaine on 03.07.19.
//

import UIKit

class RoundedButton: UIButton {

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
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.kern: 0.4,
            NSAttributedStringKey.foregroundColor: UIColor.accent,
            NSAttributedStringKey.font: UIFont.sfProtextSemibold(ofSize: 14)]
        let attributedTitle = NSAttributedString(string: title ?? "", attributes: attributes)
        setAttributedTitle(attributedTitle, for: .normal)
    }

    func setup() {
        clipsToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.accent.withAlphaComponent(0.4).cgColor

        let verticalInset: CGFloat = 11
        let horizontalInset: CGFloat = 16
        contentEdgeInsets = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = fmin(self.frame.size.width, self.frame.size.height)/2.0
    }
}
