//
//  RoundedButton.swift
//  ActionSheetPicker-3.0
//
//  Created by Anais Plancoulaine on 03.07.19.
//

import UIKit

class RoundedButton: AnimatedButton, ButtonThemeable {

    // Default values are for backwards compatibility until all instances get "Themed"
    var titleAttributes: [NSAttributedStringKey: Any]? = [.font: UIFont.sfProtextSemibold(ofSize: 14), .kern: 0.2]
    var normal: ButtonTheme? = ButtonTheme(foreground: .accent, background: nil, border: .accent40)
    var highlight: ButtonTheme? = ButtonTheme(foreground: .accent70, background: nil, border: .accent10)
    var select: ButtonTheme? = nil
    var disabled: ButtonTheme? = ButtonTheme(foreground: .sand08, background: nil, border: .sand08)

    static func barButton(title: String, target: Any, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(customView: RoundedButton(title: title, target: target, action: action))
    }

    var barButton: UIBarButtonItem {
        return UIBarButtonItem(customView: self)
    }

    /// Closure used in specific cases (see `QOTAlert` implementation)
    var handler: ((UIButton) -> Void)?

    override var isEnabled: Bool {
        didSet {
            if let normal = normal?.foregroundColor, let disabled = disabled?.foregroundColor {
                tintColor = self.isEnabled ? normal : disabled
            }
            if let normal = normal?.borderColor, let disabled = disabled?.borderColor {
                self.layer.borderColor = self.isEnabled ? normal.cgColor : disabled.cgColor
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if let normal = normal?.foregroundColor, let selected = select?.foregroundColor {
                tintColor = self.isSelected ? normal : selected
            }
            if let normal = normal?.borderColor, let selected = select?.borderColor {
                self.layer.borderColor = self.isSelected ? selected.cgColor : normal.cgColor
            }
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if let normal = normal?.foregroundColor, let highlighted = highlight?.foregroundColor {
                tintColor = self.isHighlighted ? highlighted : normal
            }
            if let normal = normal?.borderColor, let highlighted = highlight?.borderColor {
                layer.borderColor = self.isHighlighted ? highlighted.cgColor : normal.cgColor
            }
        }
    }

    init(title: String?, target: Any, action: Selector) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        addTarget(target, action: action, for: .touchUpInside)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }

    override func setTitle(_ title: String?, for state: UIControlState) {
        setAttributedTitle(NSAttributedString(string: title ?? ""))
    }

    func setAttributedTitle(_ title: NSAttributedString?) {
        let normalTheme = self.normal ?? ButtonTheme(foreground: .accent, background: .clear, border: .accent40)
        tintColor = normalTheme.foregroundColor

        layer.borderColor = normalTheme.borderColor?.cgColor
        if !isEnabled, let color = disabled?.borderColor {
            layer.borderColor = color.cgColor
        }
        if isSelected, let color = select?.borderColor {
            layer.borderColor = color.cgColor
        }

        // Normal
        setTheme(normalTheme, for: .normal, with: title)

        // Highlighted
        if let highlighted = highlight {
            setTheme(highlighted, for: .highlighted, with: title)
        }

        // Selected
        if let selected = select {
            setTheme(selected, for: .selected, with: title)
        }

        // Disabled
        if let disabled = disabled {
            setTheme(disabled, for: .disabled, with: title)
        }
    }

    private func setTheme(_ theme: ButtonTheme, for state: UIControl.State, with title: NSAttributedString?) {
        var attributes: [NSAttributedStringKey: Any] = titleAttributes ?? [NSAttributedStringKey: Any]()
        attributes[.foregroundColor] = theme.foregroundColor
        let attributedTitle = NSMutableAttributedString(attributedString: title ?? NSAttributedString(string: ""))
        attributedTitle.addAttributes(attributes, range: NSRange(location: 0, length: attributedTitle.length))
        super.setAttributedTitle(attributedTitle, for: state)
        if let color = theme.backgroundColor, let image = UIImage.from(color: color) {
            super.setBackgroundImage(image, for: state)
        }
    }

    private func setup() {
        clipsToBounds = true
        layer.borderWidth = 1.0
        imageView?.contentMode = .center
        imageView?.clipsToBounds = false

        if contentEdgeInsets == .zero {
            let vertical: CGFloat = 11
            let horizontal: CGFloat = 16
            contentEdgeInsets = UIEdgeInsets(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let expectedSize = self.sizeThatFits(CGSize(width: 1000, height: 1000))
        self.frame = CGRect(origin: self.frame.origin, size: expectedSize)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = fmin(self.frame.size.width, self.frame.size.height)/2.0
    }
}
