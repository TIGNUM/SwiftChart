//
//  LoginViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/5/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol LoginViewControllerDelegate: class {
    func loginViewController(_ viewController: UIViewController, didTapLoginWithEmail email: String, password: String)
    func loginViewControllerDidTapResetPassword(_ viewController: UIViewController)
}

final class LoginViewController: UIViewController {
    // MARK: - Properties
    
    fileprivate weak var delegate: LoginViewControllerDelegate?
    fileprivate var isPasswordHidden = true
    fileprivate let logoImageView: UIImageView = UIImageView(image: R.image.loginLogo())
    fileprivate let crossImageView: UIImageView = UIImageView(image: R.image.crossImage())
    fileprivate let emailCorrectImage: UIImageView = UIImageView(image: R.image.correctEmail())
    fileprivate let backgroundImageView: UIImageView = UIImageView(image: R.image.loginBackground())
    fileprivate var topConstraint: NSLayoutConstraint? {
        didSet {
            topConstraintOriginalValue = topConstraint?.constant ?? 0.0
        }
    }
    fileprivate var topConstraintOriginalValue: CGFloat = 0
    fileprivate let userView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteLight14
        return view
    }()
    fileprivate let passwordView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteLight14
        return view
    }()
    fileprivate let warningLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        let text = R.string.localized.loginViewUnknowEmailMessage()
        label.attributedText =  NSMutableAttributedString(
            string: text,
            letterSpacing: 1.5,
            font: Font.H8Title,
            textColor: .cherryRed,
            alignment: .left
        )
        return label
    }()
    fileprivate lazy var userInput: UITextField = {
        let input = UITextField()
        let placeHolder = NSMutableAttributedString(string: R.string.localized.loginViewInputPlaceHolder(), letterSpacing: 1.5, font: Font.H8Title, textColor: .white80, alignment: .left)
        input.textColor = .white
        input.tintColor = input.textColor
        input.autocorrectionType = .no
        input.autocapitalizationType = .none
        input.font = Font.DPText
        input.contentVerticalAlignment = .center
        input.keyboardType = .emailAddress
        input.keyboardAppearance = .dark
        input.returnKeyType = .next
        input.delegate = self
        input.attributedPlaceholder = placeHolder
        return input
    }()
    fileprivate lazy var passwordInput: UITextField = {
        let input = UITextField()
        let placeHolder = NSMutableAttributedString(string: R.string.localized.loginViewPasswordPlaceHolder(), letterSpacing: 1.5, font: Font.H8Title, textColor: .white80, alignment: .left)
        input.isSecureTextEntry = true
        input.textColor = .white
        input.tintColor = input.textColor
        input.autocorrectionType = .no
        input.font = Font.DPText
        input.keyboardType = .default
        input.keyboardAppearance = .dark
        input.returnKeyType = .send
        input.delegate = self
        input.attributedPlaceholder = placeHolder
        return input
    }()
    fileprivate lazy var loginButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressLogin(_:)), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.setTitle(R.string.localized.loginViewLoginButton(), for: .normal)
        button.titleLabel?.addCharactersSpacing(spacing: 1, text: R.string.localized.loginViewLoginButton())
        button.titleLabel?.font = Font.DPText
        button.titleLabel?.textAlignment = .center
        return button
    }()
    fileprivate lazy var passwordToggle: UIButton = {
        let button = UIButton()
        button.setTitle(R.string.localized.loginViewToggleShow(), for: .normal)
        button.addTarget(self, action: #selector(didPressShow(_:)), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.titleLabel?.font = Font.H8Title
        return button
    }()
    fileprivate lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressForgotPassword(_:)), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.setTitle(R.string.localized.loginViewForgotButton(), for: .normal)
        button.titleLabel?.addCharactersSpacing(spacing: 1.5, text: R.string.localized.loginViewForgotButton())
        button.titleLabel?.font = Font.H8Title
        return button
    }()
    
    // MARK: - Initialisation

    init(delegate: LoginViewControllerDelegate?) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
    
    @objc private func didPressLogin(_ sender: UIButton) {
        resignFirstResponder()
        doLogin()
    }
    
    @objc private func didPressShow(_ sender: UIButton) {
        if isPasswordHidden {
            passwordInput.isSecureTextEntry = false
            passwordToggle.setTitle(R.string.localized.loginViewToggleHide(), for: .normal)
        } else {
            passwordInput.isSecureTextEntry = true
            passwordToggle.setTitle(R.string.localized.loginViewToggleShow(), for: .normal)
        }
        isPasswordHidden = !isPasswordHidden
    }
    
    @objc private func didPressForgotPassword(_ sender: UIButton) {
        resignFirstResponder()
        delegate?.loginViewControllerDidTapResetPassword(self)
    }
    
    private func doLogin() {
        guard let email = userInput.text, let password = passwordInput.text else {
            return
        }
        delegate?.loginViewController(self, didTapLoginWithEmail: email, password: password)
    }
    
    private func addHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(logoImageView)
        view.addSubview(userView)
        view.addSubview(passwordView)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(passwordToggle)
        view.addSubview(emailCorrectImage)
        view.addSubview(warningLabel)
        view.addSubview(userInput)
        view.addSubview(passwordInput)
        view.addSubview(crossImageView)
    }
    
    private func setupLayout() {
        backgroundImageView.horizontalAnchors == view.horizontalAnchors
        backgroundImageView.verticalAnchors == view.verticalAnchors
        
        topConstraint = logoImageView.topAnchor == view.topAnchor + 81
        logoImageView.heightAnchor == 35
        logoImageView.widthAnchor == 116
        logoImageView.centerXAnchor == view.centerXAnchor
        logoImageView.contentMode = .scaleAspectFit
        
        crossImageView.bottomAnchor == warningLabel.topAnchor
        crossImageView.heightAnchor == 10
        crossImageView.widthAnchor == 10
        crossImageView.leadingAnchor == view.leadingAnchor + 38
        
        warningLabel.leadingAnchor == view.leadingAnchor + 36
        warningLabel.trailingAnchor == view.trailingAnchor - 57
        warningLabel.heightAnchor == 53
        warningLabel.bottomAnchor == userInput.topAnchor - 50
        
        userInput.topAnchor == logoImageView.bottomAnchor + 61
        userInput.leadingAnchor == view.leadingAnchor + 40
        userInput.trailingAnchor == emailCorrectImage.leadingAnchor
        userInput.heightAnchor == 33
        
        userView.topAnchor == userInput.bottomAnchor
        userView.leadingAnchor == view.leadingAnchor + 37
        userView.trailingAnchor == view.trailingAnchor - 38
        userView.heightAnchor == 1
        
        emailCorrectImage.bottomAnchor == userInput.bottomAnchor - 12
        emailCorrectImage.trailingAnchor == userView.trailingAnchor - 10
        emailCorrectImage.heightAnchor == 9
        emailCorrectImage.widthAnchor == 14
        
        passwordInput.topAnchor == userView.bottomAnchor + 29
        passwordInput.leadingAnchor == view.leadingAnchor + 40
        passwordInput.trailingAnchor == passwordToggle.leadingAnchor
        passwordInput.heightAnchor == 33
        
        passwordView.topAnchor == passwordInput.bottomAnchor
        passwordView.leadingAnchor == view.leadingAnchor + 37
        passwordView.trailingAnchor == view.trailingAnchor - 38
        passwordView.heightAnchor == 1
        
        passwordToggle.bottomAnchor == passwordInput.bottomAnchor - 5
        passwordToggle.trailingAnchor == passwordView.trailingAnchor
        passwordToggle.heightAnchor == 23
        passwordToggle.widthAnchor == 43
        
        forgotPasswordButton.topAnchor == passwordView.bottomAnchor
        forgotPasswordButton.trailingAnchor == view.trailingAnchor
        forgotPasswordButton.widthAnchor == 197
        forgotPasswordButton.heightAnchor == 53
        
        loginButton.topAnchor == passwordView.bottomAnchor + 75
        loginButton.centerXAnchor == view.centerXAnchor
        loginButton.widthAnchor == 242
        loginButton.heightAnchor == 45
        loginButton.layer.cornerRadius = 45/2
        loginButton.layer.borderWidth = 2
        loginButton.layer.borderColor = UIColor.azure.cgColor
        loginButton.setTitleColor(.azure, for: .normal)
        
        userInput.tag = 0
        passwordInput.tag = 1        
    }
    
    private func isValidEmail(valid: Bool) {
        if !valid {
            self.emailCorrectImage.isHidden = true
            self.warningLabel.isHidden = false
            self.crossImageView.isHidden = false
            self.userView.backgroundColor = .cherryRed
        } else {
            self.warningLabel.isHidden = true
            self.crossImageView.isHidden = true
            self.emailCorrectImage.isHidden = false
            self.userView.backgroundColor = .white
        }
    }
    
    private func hideComponents() {
        self.warningLabel.isHidden = true
        self.crossImageView.isHidden = true
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
        topConstraint.constant = topConstraintOriginalValue - (rect.height / 2.0)
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
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
        UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if textField == userInput {
            userView.backgroundColor = .white
            if text.isEmpty {
                userView.backgroundColor = .whiteLight14
            }
        } else if textField == passwordInput {
            passwordView.backgroundColor = .white
            if text.isEmpty {
                passwordView.backgroundColor = .whiteLight14
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userInput {
            hideComponents()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            doLogin()
        }
        return false
    }
}
