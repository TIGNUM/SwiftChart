//
//  SettingsChangePasswordViewController.swift
//  QOT
//
//  Created by karmic on 01.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class SettingsChangePasswordViewController: UITableViewController {

    @IBOutlet private weak var oldPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var confirmNewPasswordTextField: UITextField!
    @IBOutlet private weak var oldPasswordBottomView: UIView!
    @IBOutlet private weak var newPasswordBottomView: UIView!
    @IBOutlet private weak var confirmNewPasswordBottomView: UIView!
    @IBOutlet private weak var oldPasswordShowHideButton: UIButton!
    @IBOutlet private weak var newPasswordShowHideButton: UIButton!
    @IBOutlet private weak var confirmNewPasswordShowHideButton: UIButton!
    @IBOutlet private weak var updatePasswordButton: UIButton!
    @IBOutlet private weak var forgottPasswordButton: UIButton!
    private var statusText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationItem()
        setupTableView()
        setupButtons()
        setupTextFields()
        hideKeyboardWhenTappedAround()
        resetTextFieldBottomLines()
        resetShowHideButtons()
    }

    override func dismissKeyboard() {
        super.dismissKeyboard()

        resetTextFieldBottomLines()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource 

extension SettingsChangePasswordViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 0 : 44
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if statusText == nil && section == 0 || (section > 3) {
            return 0
        }

        return 44
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerLabel = (view as? UITableViewHeaderFooterView)?.textLabel

        if let headerTitle = headerLabel?.text {
            headerLabel?.attributedText = Style.navigationTitle(headerTitle.uppercased(), .white).attributedString(lineSpacing: 2)
            (view as? UITableViewHeaderFooterView)?.backgroundView?.backgroundColor = .clear
            (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = .clear
        }

        if section == 0 {
            let color: UIColor = statusText == nil ? .clear : .cherryRed
            let attributedText = Style.headlineSmall(statusText ?? "ALL GOOD", color).attributedString(lineSpacing: 2)
            headerLabel?.attributedText = attributedText
        }
    }
}

// MARK: - Actions

extension SettingsChangePasswordViewController {

    @objc func closeView() {
        navigationController?.dismissLeftToRight()
    }

    @IBAction func showHidePassword(sender: UIButton) {
        resetShowHideButtons()
        resetTextFieldBottomLines()

        if sender == oldPasswordShowHideButton {
            oldPasswordTextField.isSecureTextEntry = oldPasswordTextField.isSecureTextEntry == false
            setOldPasswordCellActive()
        }

        if sender == newPasswordShowHideButton {
            newPasswordTextField.isSecureTextEntry = newPasswordTextField.isSecureTextEntry == false
            setNewPasswordCellActive()
        }

        if sender == confirmNewPasswordShowHideButton {
            confirmNewPasswordTextField.isSecureTextEntry = confirmNewPasswordTextField.isSecureTextEntry == false
            setConfirmNewPasswordFieldActive()
        }

        if sender.titleLabel?.text == R.string.localized.loginViewToggleShow() {
            setButtonTitle(button: sender, title: R.string.localized.loginViewToggleHide(), color: .white)
        } else if sender.titleLabel?.text == R.string.localized.loginViewToggleHide() {
            setButtonTitle(button: sender, title: R.string.localized.loginViewToggleShow(), color: .white)
        }
    }

    @IBAction func updatePasswordButtonPressed(sender: UIButton) {
        passwordCheck()
    }
}

// MARK: - Private

private extension SettingsChangePasswordViewController {

    func setupNavigationItem() {
        navigationItem.leftBarButtonItem? = UIBarButtonItem(image: R.image.ic_back(),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(closeView))
        navigationController?.navigationBar.tintColor = .white
    }

    func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.backgroundView = UIImageView(image: R.image.loginBackground())
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: -20, right: 0)
    }

    func setupTextFields() {
        setPlaceholder(textField: oldPasswordTextField)
        setPlaceholder(textField: newPasswordTextField)
        setPlaceholder(textField: confirmNewPasswordTextField)
    }

    func setupButtons() {
        setButtonTitle(button: updatePasswordButton, title: updatePasswordButton.titleLabel?.text)
        setButtonTitle(button: forgottPasswordButton, title: forgottPasswordButton.titleLabel?.text)
        setButtonTitle(button: oldPasswordShowHideButton, title: oldPasswordShowHideButton.titleLabel?.text)
        setButtonTitle(button: newPasswordShowHideButton, title: newPasswordShowHideButton.titleLabel?.text)
        setButtonTitle(button: confirmNewPasswordShowHideButton, title: confirmNewPasswordShowHideButton.titleLabel?.text)
    }

    func setButtonTitle(button: UIButton, title: String?, color: UIColor = .white) {
        let style = Style.headlineSmall(title ?? "", color).attributedString(lineSpacing: 2)
        button.setAttributedTitle(style, for: .normal)
    }

    func setOldPasswordCellActive() {
        oldPasswordBottomView.backgroundColor = .white
        setButtonTitle(button: oldPasswordShowHideButton, title: oldPasswordShowHideButton.titleLabel?.text, color: .white)
        oldPasswordTextField.becomeFirstResponder()
    }

    func setNewPasswordCellActive() {
        newPasswordBottomView.backgroundColor = .white
        setButtonTitle(button: newPasswordShowHideButton, title: newPasswordShowHideButton.titleLabel?.text, color: .white)
        newPasswordTextField.becomeFirstResponder()
    }

    func setConfirmNewPasswordFieldActive() {
        confirmNewPasswordBottomView.backgroundColor = .white
        setButtonTitle(button: confirmNewPasswordShowHideButton, title: confirmNewPasswordShowHideButton.titleLabel?.text, color: .white)
        confirmNewPasswordTextField.becomeFirstResponder()
    }

    func resetTextFieldBottomLines() {
        oldPasswordBottomView.backgroundColor = .whiteLight
        newPasswordBottomView.backgroundColor = .whiteLight
        confirmNewPasswordBottomView.backgroundColor = .whiteLight
    }

    func resetShowHideButtons() {
        setButtonTitle(button: oldPasswordShowHideButton, title: oldPasswordShowHideButton.titleLabel?.text, color: .whiteLight)
        setButtonTitle(button: newPasswordShowHideButton, title: newPasswordShowHideButton.titleLabel?.text, color: .whiteLight)
        setButtonTitle(button: confirmNewPasswordShowHideButton, title: confirmNewPasswordShowHideButton.titleLabel?.text, color: .whiteLight)
    }

    func clearAllTextFields() {
        oldPasswordTextField.text = nil
        newPasswordTextField.text = nil
        confirmNewPasswordTextField.text = nil
    }

    private func newPasswordsMatching() -> String? {
        guard
            let newPassword = newPasswordTextField.text,
            let confirmPassword = confirmNewPasswordTextField.text else {
                return nil
        }

        let equal = newPassword == confirmPassword

        return equal == true ? nil : R.string.localized.changePasswordIssueConfirmNotMatch()
    }

    private func oldPasswordIsValid() -> String? {
        guard let oldPassword = oldPasswordTextField.text else {
            return R.string.localized.changePasswordIssueOldPasswordNotValid()
        }

        let equal = CredentialsManager.shared.loginCredentials()?.password == oldPassword

        return equal == true ? nil : R.string.localized.changePasswordIssueOldPasswordNotValid()
    }

    func passwordCheck() {
        if
            let matchingIssueText = newPasswordsMatching(),
            let oldPasswordIssueText = oldPasswordIsValid() {
                statusText = String(format: "%@ and %@", matchingIssueText, oldPasswordIssueText)
        } else if let matchingIssueText = newPasswordsMatching() {
            statusText = matchingIssueText
        } else if let oldPasswordIssueText = oldPasswordIsValid() {
            statusText = oldPasswordIssueText
        } else {
            statusText = nil
            tableView.reloadData()
        }

        if statusText != nil {
            tableView.reloadData()
            clearAllTextFields()
        }
    }

    private func setPlaceholder(textField: UITextField) {
        textField.attributedPlaceholder = Style.tag(textField.placeholder ?? "", .whiteLight).attributedString(lineSpacing: 2)
    }
}

extension SettingsChangePasswordViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        resetTextFieldBottomLines()
        resetShowHideButtons()

        if textField == oldPasswordTextField {
            setOldPasswordCellActive()
        }

        if textField == newPasswordTextField {
            setNewPasswordCellActive()
        }

        if textField == confirmNewPasswordTextField {
            setConfirmNewPasswordFieldActive()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resetTextFieldBottomLines()
        resetShowHideButtons()

        if textField == oldPasswordTextField {
            setNewPasswordCellActive()
        }

        if textField == newPasswordTextField {
            setConfirmNewPasswordFieldActive()
        }

        if textField == confirmNewPasswordTextField {
            textField.resignFirstResponder()
            passwordCheck()
        }

        return true
    }
}
