//
//  RegistrationCodeViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationCodeViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    private let viewTheme = ThemeView.onboarding

    var interactor: RegistrationCodeInteractorInterface!
    private lazy var router: RegistrationCodeRouterInterface = RegistrationCodeRouter(viewController: self)
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var preCodeLabel: UILabel!
    @IBOutlet var digitTextFields: [TextField]!
    @IBOutlet var codeErrorLabel: UILabel!
    @IBOutlet var disclaimerErrorLabel: UILabel!
    @IBOutlet private weak var buttonCheckbox: UIButton!
    @IBOutlet private weak var privacyAndTermsTextView: UITextView!
    @IBOutlet private weak var codeInfoTextView: UITextView!

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideKeyboardWhenTappedAround()
        trackPage()
    }

    override func didTapBackButton() {
        trackUserEvent(.BACK, action: .TAP)
        interactor.didTapBack()
    }
}

// MARK: - Private
private extension RegistrationCodeViewController {
    func setupTextFields() {
        digitTextFields.forEach { (digitTextField) in
            viewTheme.apply(digitTextField)
            digitTextField.delegate = self
            digitTextField.corner(radius: .Nine, borderColor: .sand40)
            digitTextField.textFieldDelegate = self
            digitTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }

    func sendCodeIfPossible() {
        let active = (digitTextFields.filter { $0.hasText == false }).isEmpty == true
        guard active == true else { return }
        interactor.validateLoginCode(digitTextFields.reduce("", { $0 + ($1.text ?? "") }))
    }

    func goToNextDigitField(_ currentTextField: UITextField, nextTextField: UITextField?) {
        currentTextField.resignFirstResponder()
        if let nextTextField = nextTextField {
            nextTextField.text = ""
            nextTextField.becomeFirstResponder()
        }
    }

    func sendEmail() {
        router.presentMailComposer(recipients: [Defaults.firstLevelSupportEmail], subject: "ID: Support")
    }

    func updateCodeDefaultUI() {
        interactor.resetErrors()
        codeErrorLabel.attributedText = nil
        digitTextFields.forEach {
            $0.text = ""
            $0.textColor = .white
            $0.layer.borderColor = UIColor.white20.cgColor
        }
    }

    func updateCodeErrorUI() {
        digitTextFields.forEach {
            $0.textColor = .redOrange70
            $0.layer.borderColor = UIColor.redOrange70.cgColor
        }
    }
}

// MARK: - Actions
private extension RegistrationCodeViewController {
    @IBAction func didTapCheckboxButton() {
        buttonCheckbox.isSelected.toggle()
        buttonCheckbox.backgroundColor = buttonCheckbox.isSelected ? .white : .clear
        interactor.toggleTermsOfUse(accepted: buttonCheckbox.isSelected)
        trackUserEvent(.CHECK_TERMS_PRIVACY, valueType: buttonCheckbox.isSelected ? .SELECT : .DESELECT, action: .TAP)
        sendCodeIfPossible()
    }
}

// MARK: - RegistrationCodeViewControllerInterface
extension RegistrationCodeViewController: RegistrationCodeViewControllerInterface {
    func setupView() {
        viewTheme.apply(view)
        ThemeText.registrationCodeTitle.apply(interactor.title, to: titleLabel)
        let description = NSMutableAttributedString(attributedString:
            ThemeText.registrationCodeDescription.attributedString(interactor.description))
        description.append(ThemeText.registrationCodeDescriptionEmail.attributedString(interactor.getEmail()))
        descriptionLabel.attributedText = description

        ThemeText.registrationCodePreCode.apply(interactor.preCode, to: preCodeLabel)

        buttonCheckbox.corner(radius: .Three, borderColor: .sand40)
        buttonCheckbox.setImage(R.image.registration_checkmark(), for: .selected)

        ThemeText.registrationCodeDisclaimerError.apply(interactor.disclaimerError, to: disclaimerErrorLabel)
        // Theme applied in interactor which handles actions
        privacyAndTermsTextView.attributedText = interactor.disclaimer
        // Theme applied in interactor which handles actions
        codeInfoTextView.attributedText = interactor.codeInfo

        setupTextFields()
    }

    func update() {
        ThemeText.registrationCodeError.apply(interactor.errorMessage, to: codeErrorLabel)

        if interactor.hasDisclaimerError {
            disclaimerErrorLabel.isHidden = false
            buttonCheckbox.layer.borderColor = UIColor.redOrange70.cgColor
        } else {
            disclaimerErrorLabel.isHidden = true
            buttonCheckbox.layer.borderColor = UIColor.white.cgColor
        }

        if interactor.hasCodeError {
            updateCodeErrorUI()
        }
    }

    func presentFAQScreen() {
        trackUserEvent(.GET_HELP, action: .TAP)
        interactor.showFAQScreen()
    }
}

// MARK: - UITextViewDelegate
extension RegistrationCodeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        interactor.handleURLAction(url: URL)
        return false
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationCodeViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // On error make first field editable
        guard let field = textField as? TextField else { return true }
        if interactor.hasCodeError == true,
            let index = digitTextFields.firstIndex(of: field), index != 0 {
            digitTextFields.first?.becomeFirstResponder()
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        refreshBottomNavigationItems()

        guard let textField = textField as? TextField, digitTextFields.firstIndex(of: textField) != nil else { return }

        if interactor.hasCodeError {
            updateCodeDefaultUI()
        }
        if let text = textField.text, !text.isEmpty {
            textField.text = nil
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        sendCodeIfPossible()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        refreshBottomNavigationItems()
        let maxLength = 1
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        refreshBottomNavigationItems()
        guard
            let textField = textField as? TextField,
            let index = digitTextFields.firstIndex(of: textField),
            textField.hasText == true else { return }
        if index + 1 < digitTextFields.count {
            let nextTextField = digitTextFields[index + 1]
            goToNextDigitField(textField, nextTextField: nextTextField)
        } else {
            textField.resignFirstResponder()
        }
    }
}

// MARK: - TextFieldDelegate
extension RegistrationCodeViewController: TextFieldDelegate {
    func textFieldDidDelete(_ textField: TextField) {
        guard let index = digitTextFields.firstIndex(of: textField) else { return }
        if index - 1 >= 0 {
            let nextTextField = digitTextFields[index - 1]
            goToNextDigitField(textField, nextTextField: nextTextField)
        }
    }
}
