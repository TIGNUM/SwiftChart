//
//  FormView.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

protocol FormViewDelegate: class {
    func didUpdateTextfield(formType: FormView.FormType?)
    func didEndEditingTextField(formType: FormView.FormType?)
    func didBeginEditingTextField(formType: FormView.FormType?)
    func didTapReturn(formType: FormView.FormType?)
}

final class FormView: UIView {

    enum FormType {
        case country(String)
        case email(String)
        case password(String)
        case firstName(String)
        case lastName(String)
        case gender(String)
        case dateOfBirth(String)
        case relationship(String)

        func update(value: String?) -> FormType? {
            guard let value = value else { return nil }
            switch self {
            case .country: return .country(value)
            case .email: return .email(value)
            case .password: return .password(value)
            case .firstName: return .firstName(value)
            case .lastName: return .lastName(value)
            case .gender: return .gender(value)
            case .dateOfBirth: return .dateOfBirth(value)
            case .relationship: return .relationship(value)
            }
        }

        var value: String {
            switch self {
            case .country(let string): return string
            case .email(let string): return string
            case .password(let string): return string
            case .firstName(let string): return string
            case .lastName(let string): return string
            case .gender(let string): return string
            case .dateOfBirth(let string): return string
            case .relationship(let string): return string
            }
        }

        var placeholder: String {
            switch self {
            case .country: return "Country"
            case .email: return "Email"
            case .password: return "Password"
            case .firstName: return "First name"
            case .lastName: return "Last name"
            case .gender: return "Gender"
            case .dateOfBirth: return "Birthdate"
            case .relationship: return "Relationship"
            }
        }

        var returnKeyType: UIReturnKeyType {
            switch self {
            case .email: return .send
            default: return .next
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            default: return .default
            }
        }

        var isSecureTextEntry: Bool {
            switch self {
            case .password: return true
            default: return false
            }
        }

        var autocapitalizationType: UITextAutocapitalizationType {
            switch self {
            case .password,
                 .email: return .none
            default: return .words
            }
        }
    }

    // MARK: - Properties

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var bottomStatusLine: UIView!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var showPasswordButton: UIButton!
    private var formType: FormType?
    weak var delegate: FormViewDelegate?

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackgrounds()
        showPasswordButton.isHidden = true
    }
}

// MARK: - Public

extension FormView {

    func activateTextField(_ active: Bool) {
        if active == true {
            textField.becomeFirstResponder()
        } else {
            endEditing(true)
        }
    }

    func configure(formType: FormType, enabled: Bool = true) {
        self.formType = formType
        setupLabels(placeholder: formType.placeholder)
        setupTextField(formType, enabled: enabled)
        setupShowPasswordButton()
    }

    func showError(message: String) {
        errorLabel.isHidden = false
        bottomStatusLine.backgroundColor = .cherryRed90
        errorLabel.attributedText = attributedString(textColor: .cherryRed90, string: message)
    }

    func hideError() {
        errorLabel.isHidden = true
        bottomStatusLine.backgroundColor = .white60
    }

    func resetPlaceholderLabelIfNeeded() {
        if textField.hasText == false {
            UIView.animate(withDuration: Animation.duration_06) { [unowned self] in
                self.placeholderLabel.transform = .identity
            }
        }
    }
}

// MARK: - Private

private extension FormView {

    func setupBackgrounds() {
        backgroundColor = .clear
        textField.backgroundColor = .clear
        bottomStatusLine.backgroundColor = .white60
    }

    func setupLabels(placeholder: String) {
        placeholderLabel.attributedText = attributedString(textColor: .white50, string: placeholder)
        errorLabel.isHidden = true
    }

    func setupTextField(_ formType: FormType, enabled: Bool) {
        textField.tintColor = .white90
        textField.textColor = .white90
        textField.keyboardType = formType.keyboardType
        textField.returnKeyType = formType.returnKeyType
        textField.autocapitalizationType = formType.autocapitalizationType
        textField.attributedText = attributedString(textColor: .white90, string: formType.value)
        textField.isSecureTextEntry = formType.isSecureTextEntry
        if textField.hasText == true {
            animatePlaceholderLabel()
        }
        textField.isUserInteractionEnabled = enabled
    }

    func attributedString(textColor: UIColor, string: String) -> NSAttributedString {
        return NSAttributedString(string: string,
                                  letterSpacing: 0.8,
                                  font: .apercuLight(ofSize: 16),
                                  textColor: textColor,
                                  alignment: .left)
    }

    func setupShowPasswordButton() {
        guard formType?.isSecureTextEntry == true else { return }
        showPasswordButton.isHidden = textField.isSecureTextEntry == true && textField.text?.count ?? 0 < 3
    }

    func animatePlaceholderLabel() {
        if textField.isEditing == false {
            let xPos = CGFloat(placeholderLabel.text?.count ?? 0) + 1
            var transform = CGAffineTransform.identity
            transform = transform.translatedBy(x: -xPos, y: -24)
            transform = transform.scaledBy(x: 0.75, y: 0.75)
            UIView.animate(withDuration: Animation.duration_06) { [unowned self] in
                self.placeholderLabel.transform = transform
            }
        }

        if textField.text?.isEmpty == true && textField.isEditing == true {
            UIView.animate(withDuration: Animation.duration_06) { [unowned self] in
                self.placeholderLabel.transform = .identity
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension FormView: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        animatePlaceholderLabel()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEditingTextField(formType: formType?.update(value: textField.text))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        animatePlaceholderLabel()
        delegate?.didTapReturn(formType: formType)
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        setupShowPasswordButton()
        delegate?.didUpdateTextfield(formType: formType?.update(value: updatedText))
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        resetPlaceholderLabelIfNeeded()
        delegate?.didEndEditingTextField(formType: formType?.update(value: textField.text))
    }
}

// MARK: - Actions

private extension FormView {

    @IBAction func didTabShowPasswordButton() {
        guard formType?.isSecureTextEntry == true else { return }
        showPasswordButton.isSelected = !showPasswordButton.isSelected
        textField.isSecureTextEntry = !textField.isSecureTextEntry
    }
}
