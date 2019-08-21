//
//  OnoardingLoginViewController.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnoardingLoginViewController: UIViewController {

    // MARK: - Properties
    var interactor: OnoardingLoginInteractorInterface?
    private var showingError = false
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet var digitTextFields: [TextField]!
    @IBOutlet weak var buttonSendCode: UIButton!

    // MARK: - Init
    init(configure: Configurator<OnoardingLoginViewController>) {
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
private extension OnoardingLoginViewController {
    func setupTextFields() {
        emailTextField.backgroundColor = .carbonNew
        emailTextField.corner(radius: .Nine, borderColor: .sand40)
        digitTextFields.forEach { (digitTextField) in
            digitTextField.backgroundColor = .carbonNew
            digitTextField.corner(radius: .Nine, borderColor: .sand40)
            digitTextField.textFieldDelegate = self
        }
    }

    func setupButtons() {
        buttonSendCode.cornerDefault()
    }

    func dismissError() {
        showingError = false
        digitTextFields.forEach { $0.text = "" }
        digitTextFields.forEach { $0.textColor = .sand }
        digitTextFields.forEach { $0.layer.borderColor = UIColor.sand40.cgColor }
    }

    func sendCodeIfPossible() {
        let active = (digitTextFields.filter { $0.hasText == false }).isEmpty == true
        if active == true {
            //send code to verify
        }
    }

    func goToNextDigitField(_ currentTextField: UITextField, nextTextField: UITextField?) {
        currentTextField.resignFirstResponder()
        if let nextTextField = nextTextField {
            nextTextField.text = ""
            nextTextField.becomeFirstResponder()
        }
    }

}

// MARK: - Actions
private extension OnoardingLoginViewController {
    @IBAction func didTapSendCode() {

    }

    @IBAction func didTapGetHelp() {

    }
}

// MARK: - UITextFieldDelegate
extension OnoardingLoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard
            let textField = textField as? TextField,
            let index = digitTextFields.index(of: textField) else { return }
        if showingError == true {
            dismissError()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        sendCodeIfPossible()
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
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
extension OnoardingLoginViewController: TextFieldDelegate {
    func textFieldDidDelete(_ textField: TextField) {
        guard let index = digitTextFields.index(of: textField) else { return }
        if index - 1 >= 0 {
            let nextTextField = digitTextFields[index - 1]
            goToNextDigitField(textField, nextTextField: nextTextField)
        }
    }
}

// MARK: - OnoardingLoginViewControllerInterface
extension OnoardingLoginViewController: OnoardingLoginViewControllerInterface {
    func setupView() {
        setupTextFields()
        setupButtons()
    }
}
