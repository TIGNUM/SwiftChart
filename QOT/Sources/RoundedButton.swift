//
//  RoundedButton.swift
//  ActionSheetPicker-3.0
//
//  Created by Anais Plancoulaine on 03.07.19.
//

import UIKit

class RoundedButton: AnimatedButton, ButtonThemeable {

    // MARK: - Properties
    // Default values are for backwards compatibility until all instances get "Themed"
    var titleAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextSemibold(ofSize: 14), .kern: 0.2]
    var normal: ButtonTheme? = ButtonTheme(foreground: .white, background: nil, border: .white)
    var highlight: ButtonTheme? = ButtonTheme(foreground: .accent70, background: nil, border: .accent10)
    var select: ButtonTheme?
    var disabled: ButtonTheme? = ButtonTheme(foreground: .sand08, background: nil, border: .sand08)
    var ctaState: ButtonTheme.State?
    var ctaAction: ButtonTheme.Action?

    /// Closure used in specific cases (see `QOTAlert` implementation)
    var handler: ((UIButton) -> Void)?

    // MARK: - Observers for UI appearance
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

    // MARK: - Initializers and overrides
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

// MARK: - Public methods
extension RoundedButton {
    func setTitle(_ title: String?) {
        setTitle(title, for: .normal)
    }

    override func setTitle(_ title: String?, for state: UIControl.State) {
        setAttributedTitle(NSAttributedString(string: title ?? ""))
    }

    func setAttributedTitle(_ title: NSAttributedString?) {
        let normalTheme = self.normal ?? ButtonTheme(foreground: .white, background: .clear, border: .white)
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
}

// MARK: - Bar button helpers
extension RoundedButton {
    var barButton: UIBarButtonItem {
        return UIBarButtonItem(customView: embeddedInView(self))
    }
}

// MARK: - Private methods
private extension RoundedButton {
    func setTheme(_ theme: ButtonTheme, for state: UIControl.State, with title: NSAttributedString?) {
        var attributes: [NSAttributedString.Key: Any] = titleAttributes ?? [NSAttributedString.Key: Any]()
        attributes[.foregroundColor] = theme.foregroundColor
        let attributedTitle = NSMutableAttributedString(attributedString: title ?? NSAttributedString(string: ""))
        attributedTitle.addAttributes(attributes, range: NSRange(location: 0, length: attributedTitle.length))
        super.setAttributedTitle(attributedTitle, for: state)
        if let color = theme.backgroundColor, let image = UIImage.from(color: color) {
            super.setBackgroundImage(image, for: state)
        } else {
            super.setBackgroundImage(nil, for: state)
        }
    }

    func setup() {
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

    func embeddedInView(_ button: RoundedButton) -> UIView {
        let view = UIView()
        view.fill(subview: button)
        return view
    }
}
