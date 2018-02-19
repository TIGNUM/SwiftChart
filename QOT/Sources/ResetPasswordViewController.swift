//
//  ResetPasswordViewController.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ResetPasswordViewControllerDelegate: class {
    func didTapResetPassword(withUsername username: String, completion: @escaping (NetworkError?) -> Void)
}

final class ResetPasswordViewController: UIViewController {
    // MARK: - Properties

    weak var delegate: ResetPasswordViewControllerDelegate?
    private let logoImageView: UIImageView = UIImageView(image: R.image.loginLogo())
    private let crossImageView: UIImageView = UIImageView(image: R.image.crossImage())
    private let emailCorrectImage: UIImageView = UIImageView(image: R.image.correctEmail())
    private let backgroundImageView: UIImageView = UIImageView(image: R.image.loginBackground())
    private var topConstraint: NSLayoutConstraint? {
        didSet {
            topConstraintOriginalValue = topConstraint?.constant ?? 0.0
        }
    }
    private var topConstraintOriginalValue: CGFloat = 0
    private let userView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteLight14
        return view
    }()
    private let passwordView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteLight14
        return view
    }()
    private let warningSignLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        let text = " "
        label.attributedText =  NSMutableAttributedString(
            string: text,
            letterSpacing: 1.5,
            font: Font.DPText,
            lineSpacing: 5,
            textColor: .cherryRed,
            alignment: .left
        )
        return label
    }()
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        let text = R.string.localized.resetPasswordForgottenPasswordMessage()
        label.attributedText =  NSMutableAttributedString(
            string: text,
            letterSpacing: 1.5,
            font: Font.H8Title,
            lineSpacing: 5,
            textColor: .white,
            alignment: .left
        )
        return label
    }()
    private lazy var userInput: UITextField = {
        let input = UITextField()
        let placeHolder = NSMutableAttributedString(string: R.string.localized.resetPasswordEmailPlaceHolder(), letterSpacing: 1.5, font: Font.H8Title, textColor: .white80, alignment: .left)
        input.textColor = .white
        input.tintColor = input.textColor
        input.autocorrectionType = .no
        input.font = Font.DPText
        input.contentVerticalAlignment = .center
        input.keyboardType = .emailAddress
        input.autocapitalizationType = .none
        input.keyboardAppearance = .dark
        input.returnKeyType = .send
        input.clearsOnBeginEditing = true
        input.delegate = self
        input.attributedPlaceholder = placeHolder
        return input
    }()
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressResetPassword(_:)), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.setTitle(R.string.localized.resetPasswordResetMyPassword(), for: .normal)
        button.titleLabel?.addCharactersSpacing(spacing: 1, text: R.string.localized.resetPasswordResetMyPassword())
        button.titleLabel?.font = Font.DPText
        button.titleLabel?.textAlignment = .center
        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        addHierarchy()
        setupLayout()
        hideComponents()
        hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startObservingKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        view.endEditing(true)
        stopObservingKeyboard()
    }

    // MARK: - private

    private func addHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(logoImageView)
        view.addSubview(userView)
        view.addSubview(passwordView)
        view.addSubview(resetPasswordButton)
        view.addSubview(emailCorrectImage)
        view.addSubview(warningLabel)
        view.addSubview(userInput)
        view.addSubview(warningSignLabel)
    }

    private func setupLayout() {
        backgroundImageView.horizontalAnchors == view.horizontalAnchors
        backgroundImageView.verticalAnchors == view.verticalAnchors

        topConstraint = logoImageView.topAnchor == view.topAnchor + 81
        logoImageView.heightAnchor == 35
        logoImageView.widthAnchor == 116
        logoImageView.centerXAnchor == view.centerXAnchor
        logoImageView.contentMode = .scaleAspectFit

        warningLabel.topAnchor == logoImageView.bottomAnchor + 61
        warningLabel.leadingAnchor == view.leadingAnchor + 36
        warningLabel.trailingAnchor == view.trailingAnchor - 36

        warningSignLabel.bottomAnchor == warningLabel.topAnchor
        warningSignLabel.leadingAnchor == warningLabel.leadingAnchor
        warningSignLabel.trailingAnchor == warningLabel.trailingAnchor

        userInput.topAnchor == warningLabel.bottomAnchor + 50
        userInput.leadingAnchor == view.leadingAnchor + 40
        userInput.trailingAnchor == emailCorrectImage.leadingAnchor
        userInput.heightAnchor == 33

        userView.topAnchor == userInput.bottomAnchor - 2
        userView.leadingAnchor == view.leadingAnchor + 37
        userView.trailingAnchor == view.trailingAnchor - 38
        userView.heightAnchor == 1

        emailCorrectImage.bottomAnchor == userInput.bottomAnchor - 14
        emailCorrectImage.trailingAnchor == userView.trailingAnchor - 10
        emailCorrectImage.heightAnchor == 9
        emailCorrectImage.widthAnchor == 14

        resetPasswordButton.topAnchor == userView.bottomAnchor + 65
        resetPasswordButton.centerXAnchor == view.centerXAnchor
        resetPasswordButton.widthAnchor == 242
        resetPasswordButton.heightAnchor == 45
        resetPasswordButton.layer.cornerRadius = 45/2
        resetPasswordButton.layer.borderWidth = 2
        resetPasswordButton.layer.borderColor = UIColor.azure.cgColor
        resetPasswordButton.setTitleColor(.azure, for: .normal)

        userInput.tag = 0
    }

    @objc private func didPressResetPassword(_ sender: UIButton) {
        self.resignFirstResponder()
        doPasswordReset()
    }

    private func doPasswordReset() {
        guard let username = userInput.text?.trimmingCharacters(in: .whitespacesAndNewlines), username.count > 0 else {
            return
        }

        delegate?.didTapResetPassword(withUsername: username) { error in
            if let error = error {
                switch error.type {
                case .noNetworkConnection:
                    self.showAlert(type: .noNetworkConnection)
                case .notFound:
                    self.showAlert(type: .emailNotFound)
                default:
                    self.showAlert(type: .unknown)
                }
                return
            }

            self.showAlert(type: .resetPassword, handler: {
                self.navigationController?.popViewController(animated: true)
            }, handlerDestructive: nil)
        }
    }

    private func isValidEmail(valid: Bool) {
        if !valid {
            self.emailCorrectImage.isHidden = true
            self.userView.backgroundColor = .cherryRed
        } else {
            self.emailCorrectImage.isHidden = false
            self.userView.backgroundColor = .white
        }
    }

    private func hideComponents() {
        self.emailCorrectImage.isHidden = true
        self.userView.backgroundColor = .whiteLight14
    }

    // MARK: - notification

    @objc override func keyboardWillAppear(notification: NSNotification) {
        guard
            let topConstraint = topConstraint,
            let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                return
        }
        topConstraint.constant = max(topConstraintOriginalValue - (rect.height / 2.0), 10.0)
        UIView.animate(withDuration: duration, delay: 0, options: [UIViewAnimationOptions(rawValue: curve), .beginFromCurrentState], animations: {
            self.logoImageView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }

    @objc override func keyboardWillDisappear(notification: NSNotification) {
        guard
            let topConstraint = topConstraint,
            let userInfo = notification.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                return
        }
        topConstraint.constant = topConstraintOriginalValue
        UIView.animate(withDuration: duration, delay: 0, options: [UIViewAnimationOptions(rawValue: curve), .beginFromCurrentState], animations: {
            self.logoImageView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITextFieldDelegate

extension ResetPasswordViewController: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if textField == userInput {
            userView.backgroundColor = .white
            if text.isEmpty {
                userView.backgroundColor = .whiteLight14
            }
        }
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userInput {
            hideComponents()
        }
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            doPasswordReset()
        }
        return false
    }
}
