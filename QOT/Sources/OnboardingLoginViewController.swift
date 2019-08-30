//
//  OnoardingLoginViewController.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import MessageUI

final class OnboardingLoginViewController: UIViewController, ScreenZLevelOverlay {

    // MARK: - Properties
    private let helpEmail = Defaults.firstLevelSupportEmail
    private var didHideEmail: Bool {
        return sendButtonYPosition.constant != 0
    }

    var interactor: OnboardingLoginInteractorInterface?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: QotPlaceholderTextField!
    @IBOutlet weak var emailInstructionsLabel: UILabel!
    @IBOutlet weak var precodeLabel: UILabel!
    @IBOutlet var digitTextFields: [TextField]!
    @IBOutlet var digitDescriptionLabel: UILabel!
    @IBOutlet var sendButtonYPosition: NSLayoutConstraint!
    @IBOutlet weak var buttonSendCode: UIButton!
    @IBOutlet weak var buttonGetHelp: UIButton!

    var preSetUserEmail: String?
    var cachedToBeVision: CachedToBeVision?

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Email has been set by registration screens
        if let email = preSetUserEmail {
            emailField.text = email
            preSetUserEmail = nil
            didTapVerifyEmail()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // There needs to be a small delay or the textfield automatically resigns first responder
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) { [weak self] in
            self?.emailField.textField.becomeFirstResponder()
        }
    }
}

// MARK: - Private
private extension OnboardingLoginViewController {
    func setupTextFields() {
        emailField.delegate = self
        emailField.textField.autocapitalizationType = .none
        emailField.textField.backgroundColor = .carbonNew
        emailField.textField.keyboardType = .emailAddress
        emailField.placeholderParameters.alpha = 0.6
        emailField.textField.corner(radius: .Nine, borderColor: .sand20)
        emailField.textField.enablesReturnKeyAutomatically = true
        emailField.textField.returnKeyType = .go

        digitTextFields.forEach { (digitTextField) in
            digitTextField.delegate = self
            digitTextField.backgroundColor = .carbonNew
            digitTextField.corner(radius: .Nine, borderColor: .sand20)
            digitTextField.textFieldDelegate = self
            digitTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }

    func loadEmailTextFieldDefaultUI() {
        interactor?.resetEmailError()

        emailField.textField.layer.borderColor = UIColor.sand20.cgColor
        emailInstructionsLabel.text = interactor?.emailInstructions
    }

    func loadDigitTextFieldsDefaultUI() {
        interactor?.resetCodeError()

        digitTextFields.forEach {
            $0.text = ""
            $0.textColor = .sand
            $0.layer.borderColor = UIColor.sand20.cgColor
        }
        digitDescriptionLabel.text = interactor?.digitDescription
    }

    func setupButtons() {
        buttonSendCode.cornerDefault()
        buttonGetHelp.cornerDefault()
    }

    func sendCodeIfPossible() {
        let active = (digitTextFields.filter { $0.hasText == false }).isEmpty == true
        guard active == true else { return }
        interactor?.validateLoginCode(digitTextFields.reduce("", { $0 + ($1.text ?? "") }),
                                      for: emailField.text,
                                      toBeVision: cachedToBeVision)
    }

    func goToNextDigitField(_ currentTextField: UITextField, nextTextField: UITextField?) {
        currentTextField.resignFirstResponder()
        if let nextTextField = nextTextField {
            nextTextField.text = ""
            nextTextField.becomeFirstResponder()
        }
    }

    func moveCodeInputToTop() {
        sendButtonYPosition.constant = -250
        UIView.animate(withDuration: Animation.duration_02) {
            self.view.layoutIfNeeded()
            self.buttonSendCode.alpha = 0
            self.emailField.alpha = 0
            self.emailInstructionsLabel.alpha = 0
        }
    }

    func resetCodeInputPosition() {
        sendButtonYPosition.constant = 0
        UIView.animate(withDuration: Animation.duration_02) {
            self.view.layoutIfNeeded()
            self.buttonSendCode.alpha = 1
            self.emailField.alpha = 1
            self.emailInstructionsLabel.alpha = 1
        }

        buttonGetHelp.setTitle(R.string.localized.onboardingLoginButtonGetHelp(), for: .normal)
        buttonGetHelp.removeTarget(self, action: nil, for: .touchUpInside)
        buttonGetHelp.addTarget(self, action: #selector(didTapGetHelp), for: .touchUpInside)
    }

    func presentEmailError(_ error: String) {
        emailField.textField.layer.borderColor = UIColor.redOrange.cgColor
        ThemeText.loginEmailErrorMessage.apply(error, to: emailInstructionsLabel)
    }

    func presentCodeError(_ error: String) {
        digitTextFields.forEach {
            $0.textColor = .redOrange
            $0.layer.borderColor = UIColor.redOrange.cgColor
        }
        ThemeText.loginEmailCodeErrorMessage.apply(error, to: digitDescriptionLabel)

        buttonGetHelp.setTitle(R.string.localized.onboardingLoginButtonResendCode(), for: .normal)
        buttonGetHelp.removeTarget(self, action: nil, for: .touchUpInside)
        buttonGetHelp.addTarget(self, action: #selector(didTapSendCode), for: .touchUpInside)
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
}

// MARK: - Actions
private extension OnboardingLoginViewController {

    @IBAction func didTapVerifyEmail() {
        emailField.textField.resignFirstResponder()
        emailField.textField.text = emailField.text?.replacingOccurrences(of: " ", with: "")
        interactor?.didTapVerify(email: emailField.text)
    }

    @objc func didTapSendCode() {
        interactor?.didTapSendCode(to: emailField.text)
    }

    @IBAction func didTapGetHelp() {
        interactor?.didTapGetHelpButton()
    }

    // Superclass already has a `didTapBackButton()` method
    @IBAction func didTapBack() {
        loadDigitTextFieldsDefaultUI()
        if didHideEmail {
            resetCodeInputPosition()
            emailField.textField.becomeFirstResponder()
        } else {
            loadEmailTextFieldDefaultUI()
            emailField.text = nil
            interactor?.didTapBack()
        }
    }
}

// MARK: - UITextFieldDelegate
extension OnboardingLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailField.textField {
            if interactor?.viewModel.emailError != nil {
                loadEmailTextFieldDefaultUI()
            }
            return
        }

        guard
            let textField = textField as? TextField,
            digitTextFields.index(of: textField) != nil else { return }
        if sendButtonYPosition.constant == 0 {
            moveCodeInputToTop()
        }
        if interactor?.viewModel.codeError != nil {
            loadDigitTextFieldsDefaultUI()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        sendCodeIfPossible()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == emailField.textField {
            return true
        }
        let maxLength = 1
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != emailField.textField {
            return false
        }
        didTapVerifyEmail()
        return false
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
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
extension OnboardingLoginViewController: TextFieldDelegate {
    func textFieldDidDelete(_ textField: TextField) {
        guard let index = digitTextFields.index(of: textField) else { return }
        if index - 1 >= 0 {
            let nextTextField = digitTextFields[index - 1]
            goToNextDigitField(textField, nextTextField: nextTextField)
        }
    }
}

// MARK: - OnoardingLoginViewControllerInterface
extension OnboardingLoginViewController: OnboardingLoginViewControllerInterface {
    func setupView() {
        ThemeText.loginEmailTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.loginEmailMessage.apply(interactor?.emailInstructions, to: emailInstructionsLabel)
        ThemeText.loginEmailCode.apply(interactor?.preCode, to: precodeLabel)
        ThemeText.loginEmailCodeMessage.apply(interactor?.digitDescription, to: digitDescriptionLabel)

        setupTextFields()
        setupButtons()
    }

    func updateView() {
        // Errors
        if let error = interactor?.viewModel.emailError {
            presentEmailError(error)
            resetCodeInputPosition()
        } else {
            loadEmailTextFieldDefaultUI()
        }
        if let error = interactor?.viewModel.codeError {
            presentCodeError(error)
        }

        let canSendCode = interactor?.viewModel.sendCodeEnabled ?? true
        emailField.textField.isUserInteractionEnabled = canSendCode
        buttonSendCode.isUserInteractionEnabled = canSendCode
    }

    func beginCodeEntry() {
        emailField.textField.resignFirstResponder()
        digitTextFields.first?.becomeFirstResponder()
    }

    func presentGetHelpView() {
        sendEmail()
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension OnboardingLoginViewController {
    override internal func mailComposeController(_ controller: MFMailComposeViewController,
                                                 didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
