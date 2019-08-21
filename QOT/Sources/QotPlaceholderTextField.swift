//
//  QotPlaceholderTextField.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 13/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

/// Control which consists of UITextField and a label for text field's placeholder text which gets moved above the
/// input field when the text field is active
final class QotPlaceholderTextField: UIView {

    /// Parameters which define placeholder appearance compared to it's active state
    struct PlaceholderParameters {
        private static let minScale: CGFloat = 0.75
        private static let alpha: CGFloat = 0.4

        init(minScale: CGFloat = PlaceholderParameters.minScale, alpha: CGFloat = PlaceholderParameters.alpha) {
            self.minScale = minScale
            self.alpha = alpha
        }
        var minScale: CGFloat
        var alpha: CGFloat
    }

    // MARK: Private properties
    @IBOutlet private var containerView: UIView!
    @IBOutlet private weak var placeholderSpace: UIView!

    // MARK: Public properties
    weak var delegate: UITextFieldDelegate?
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    var placeholderParameters = PlaceholderParameters() {
        didSet {
            setPlaceholderCenter(animated: false)
        }
    }

    @IBInspectable var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            setPlaceholderCenter()
        }
    }

    @IBInspectable var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
            setPlaceholderCenter()
        }
    }

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        containerView.prepareForInterfaceBuilder()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(String(describing: type(of: self)),
                                 owner: self,
                                 options: nil)
        fill(subview: containerView)
        textField.corner(radius: .Nine, borderColor: .sand40)
        setPlaceholderCenter(animated: false)
    }
}

// MARK: - Private methods

private extension QotPlaceholderTextField {
    func setPlaceholderCenter(animated: Bool = true) {
        // Properties
        var transform: CGAffineTransform = .identity
        let alpha: CGFloat
        // Values
        if textField.isFirstResponder || !(textField.text?.isEmpty ?? true) {
            // Transformations do it's black magic so the correct x translation is not 0 but 0.128 x screen width
            let xPos: CGFloat = -(UIApplication.shared.delegate?.window??.bounds.size.width ?? 375.0) * 0.128
            let yPos: CGFloat = placeholderSpace.center.y - textField.center.y
            transform = transform.translatedBy(x: xPos, y: yPos)
            transform = transform.scaledBy(x: placeholderParameters.minScale, y: placeholderParameters.minScale)
            alpha = 1
        } else {
            alpha = placeholderParameters.alpha
        }
        // Animations
        UIView.animate(withDuration: animated ? Animation.duration_03 : 0) {
            self.placeholderLabel.transform = transform
            self.placeholderLabel.alpha = alpha
        }
    }
}

// MARK: - UITextField delegate

extension QotPlaceholderTextField: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldBeginEditing?(textField) ?? true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.textFieldDidBeginEditing?(textField)
        setPlaceholderCenter()
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing?(textField)
        setPlaceholderCenter()
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate?.textFieldDidEndEditing?(textField)
        delegate?.textFieldDidEndEditing?(textField, reason: reason)
        setPlaceholderCenter()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldClear?(textField) ?? true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return delegate?.textFieldShouldReturn?(textField) ?? true
    }
}
