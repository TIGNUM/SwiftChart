//
//  SigningDigitViewController.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningDigitViewController: SigningAbstractViewController {

    // MARK: - Properties

    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var centerContentView: UIView!
    @IBOutlet private weak var resendCodeButton: UIButton!
    @IBOutlet private var digitTextFields: [UITextField]!
    @IBOutlet private var digitLines: [UIView]!
    private var showingError = false
    var interactor: SigningDigitInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SigningDigitViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension SigningDigitViewController {

    func setupFormView() {
        resetDigitLines()
        digitTextFields.forEach { textField in
            textField.tintColor = .white
            textField.delegate = self
            textField.addTarget(self,
                                action: #selector(textFieldDidChange),
                                for: .editingChanged)
            textField.attributedText = NSMutableAttributedString(string: "",
                                                                 letterSpacing: 2,
                                                                 font: .simpleFont(ofSize: 32),
                                                                 textColor: .white,
                                                                 alignment: .center)
        }
    }

    func setupResendCodeButton() {
        let attributedTitle = NSMutableAttributedString(string: R.string.localized.signingDigitCheckButtonTitleResendCode(),
                                                        letterSpacing: 1,
                                                        font: .apercuRegular(ofSize: 16),
                                                        textColor: .white90,
                                                        alignment: .center)
        resendCodeButton.setAttributedTitle(attributedTitle, for: .normal)
        resendCodeButton.setAttributedTitle(attributedTitle, for: .selected)
    }

    func resetDigitLines() {
        digitLines.forEach { $0.backgroundColor = .white40 }
    }

    func showError(errorMessage: String) {
        showingError = true
        errorLabel.isHidden = false
        digitTextFields.forEach { $0.textColor = .coral }
        digitLines.forEach { $0.backgroundColor = .coral }
        errorLabel.attributedText = NSMutableAttributedString(string: errorMessage,
                                                              letterSpacing: 1,
                                                              font: .apercuRegular(ofSize: 16),
                                                              textColor: .coral,
                                                              alignment: .center)
        updateBottomButton(false)
    }

    func dismissError() {
        showingError = false
        errorLabel.isHidden = true
        digitTextFields.forEach { $0.text = "" }
        digitTextFields.forEach { $0.textColor = .white }
        digitLines.forEach { $0.backgroundColor = .white40 }
    }

    func updateButtonState() {
        let active = (digitTextFields.filter { $0.hasText == false }).isEmpty == true
        updateBottomButton(active)
        if active == true {
            didTabVerifyButton()
        }
    }
}

// MARK: - Actions

private extension SigningDigitViewController {

    @IBAction func didTabVerifyButton() {
        let code = (digitTextFields.compactMap { $0.text }).joined()
        interactor?.verify(code: code)
    }

    @IBAction func didTabResendButton() {
        interactor?.resendCode()
    }
}

// MARK: - SigningDigitViewControllerInterface

extension SigningDigitViewController: SigningDigitViewControllerInterface {

    func setup() {
        errorLabel.isHidden = true
        centerContentView.backgroundColor = .clear
        setupResendCodeButton()
        setupFormView()
        setupView(title: R.string.localized.signingDigitCheckTitle(),
                  subtitle: R.string.localized.signingDigitCheckSubtitle(interactor?.email ?? ""),
                  bottomButtonTitle: R.string.localized.signingDigitCheckBottomButtonTitle())
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        if let errorMessage = errorMessage {
            showError(errorMessage: errorMessage)
        }
        updateBottomButton(buttonActive)
    }

    func activateButton(_ active: Bool) {
        updateBottomButton(active)
    }

    func goToNextDigitField(_ currentTextField: UITextField, nextTextField: UITextField?) {
        currentTextField.resignFirstResponder()
        if let nextTextField = nextTextField {
            nextTextField.text = ""
            nextTextField.becomeFirstResponder()
        }
    }

    override func endEditing() {
        resetDigitLines()
        super.endEditing()
    }
}

// MARK: - UITextFieldDelegate

extension SigningDigitViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let index = digitTextFields.index(of: textField) else { return }
        if showingError == true {
            dismissError()
        }
        resetDigitLines()
        digitLines[index].backgroundColor = .white60
        updateButtonState()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        resetDigitLines()
        updateButtonState()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let index = digitTextFields.index(of: textField), textField.hasText == true else { return }
        if index + 1 < digitTextFields.count {
            let nextTextField = digitTextFields[index + 1]
            goToNextDigitField(textField, nextTextField: nextTextField)
        } else {
            textField.resignFirstResponder()
        }
    }
}
