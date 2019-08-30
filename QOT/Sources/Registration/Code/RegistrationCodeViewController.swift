//
//  RegistrationCodeViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class RegistrationCodeViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    private let helpEmail = Defaults.firstLevelSupportEmail

    var interactor: RegistrationCodeInteractorInterface?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
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
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func didTapBackButton() {
        interactor?.didTapBack()
    }
}

// MARK: - Private

private extension RegistrationCodeViewController {
    func setupTextFields() {
        digitTextFields.forEach { (digitTextField) in
            digitTextField.delegate = self
            digitTextField.backgroundColor = .carbon
            digitTextField.corner(radius: .Nine, borderColor: .sand40)
            digitTextField.textFieldDelegate = self
            digitTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }

    func sendCodeIfPossible() {
        let active = (digitTextFields.filter { $0.hasText == false }).isEmpty == true
        guard active == true else { return }
        interactor?.validateLoginCode(digitTextFields.reduce("", { $0 + ($1.text ?? "") }))
    }

    func goToNextDigitField(_ currentTextField: UITextField, nextTextField: UITextField?) {
        currentTextField.resignFirstResponder()
        if let nextTextField = nextTextField {
            nextTextField.text = ""
            nextTextField.becomeFirstResponder()
        }
    }

    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() == true else {
            return
        }

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients([helpEmail])
        present(mail, animated: true)
    }

    func updateCodeDefaultUI() {
        interactor?.resetErrors()
        codeErrorLabel.text = nil
        digitTextFields.forEach {
            $0.text = ""
            $0.textColor = .sand
            $0.layer.borderColor = UIColor.sand20.cgColor
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
        buttonCheckbox.backgroundColor = buttonCheckbox.isSelected ? .sand15 : .clear
        interactor?.toggleTermsOfUse(accepted: buttonCheckbox.isSelected)
        sendCodeIfPossible()
    }
}

// MARK: - RegistrationCodeViewControllerInterface

extension RegistrationCodeViewController: RegistrationCodeViewControllerInterface {
    func setupView() {
        titleLabel.text = interactor?.title
        descriptionLabel.attributedText = interactor?.description
        buttonCheckbox.corner(radius: .Three, borderColor: .sand40)
        buttonCheckbox.setImage(R.image.registration_checkmark(), for: .selected)
        privacyAndTermsTextView.attributedText = interactor?.disclaimer ?? NSAttributedString()
        codeInfoTextView.attributedText = interactor?.codeInfo ?? NSAttributedString()

        setupTextFields()
    }

    func update() {
        codeErrorLabel.text = interactor?.errorMessage

        if interactor?.hasDisclaimerError ?? false {
            disclaimerErrorLabel.isHidden = false
            buttonCheckbox.layer.borderColor = UIColor.redOrange70.cgColor
        } else {
            disclaimerErrorLabel.isHidden = true
            buttonCheckbox.layer.borderColor = UIColor.sand40.cgColor
        }

        if interactor?.hasCodeError ?? false {
            updateCodeErrorUI()
        }
    }

    func presentGetHelpView() {
        sendEmail()
    }
}

// MARK: - UITextViewDelegate

extension RegistrationCodeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        interactor?.handleURLAction(url: URL)
        return false
    }
}

// MARK: - UITextFieldDelegate
extension RegistrationCodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        refreshBottomNavigationItems()

        guard
            let textField = textField as? TextField,
            digitTextFields.index(of: textField) != nil else { return }

        if interactor?.hasCodeError ?? true {
            updateCodeDefaultUI()
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
            let index = digitTextFields.index(of: textField),
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
        guard let index = digitTextFields.index(of: textField) else { return }
        if index - 1 >= 0 {
            let nextTextField = digitTextFields[index - 1]
            goToNextDigitField(textField, nextTextField: nextTextField)
        }
    }
}
