//
//  LoginViewCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 7/5/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol LoginViewCellDelegate: class {
    func keyboardAppeared(viewHeight: CGFloat)
    func didTapLogin(withEmail email: String, password: String, completion: @escaping (Error?) -> Void)
}

class LoginViewCell: UITableViewCell, Dequeueable {

    // MARK: - Lifecycle

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addHierarchy()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

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

    fileprivate weak var delegate: LoginViewControllerDelegate?
    fileprivate weak var cellDelegate: LoginViewCellDelegate?
    fileprivate weak var parentViewController: UIViewController?

    fileprivate var isPasswordHidden = true
    fileprivate let logoImageView: UIImageView = UIImageView(image: R.image.loginLogo())
    fileprivate let crossImageView: UIImageView = UIImageView(image: R.image.crossImage())
    fileprivate let emailCorrectImage: UIImageView = UIImageView(image: R.image.correctEmail())

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

    fileprivate lazy var logoTopConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.logoImageView,
                                  attribute: .top,
                                  relatedBy: .equal,
                                  toItem: self.contentView,
                                  attribute: .top,
                                  multiplier: 1,
                                  constant: 73)
    }()

    fileprivate lazy var logoHeightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.logoImageView,
                                  attribute: .height,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .height,
                                  multiplier: 1,
                                  constant: 34)
    }()

    fileprivate lazy var logoWidthConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: self.logoImageView,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: nil,
                                  attribute: .height,
                                  multiplier: 1,
                                  constant: 97)
    }()

    @objc func didPressLogin(_ sender: UIButton) {
        self.resignFirstResponder()
        doLogin()
    }

    @objc func didPressShow(_ sender: UIButton) {
        if isPasswordHidden {
            passwordInput.isSecureTextEntry = false
            passwordToggle.setTitle(R.string.localized.loginViewToggleHide(), for: .normal)
        } else {
            passwordInput.isSecureTextEntry = true
            passwordToggle.setTitle(R.string.localized.loginViewToggleShow(), for: .normal)
        }
        isPasswordHidden = !isPasswordHidden
    }

    @objc func didPressForgotPassword(_ sender: UIButton) {
        self.resignFirstResponder()
        guard let viewController = parentViewController else { return }
        delegate?.didTapResetPassword(viewController: viewController)
    }

    func doLogin() {
        guard let email = userInput.text else { return }
        guard let password = passwordInput.text else { return }

        cellDelegate?.didTapLogin(withEmail: email, password: password) {_ in }
    }

    func configure(delegate: LoginViewControllerDelegate?, cellDelegate: LoginViewCellDelegate?, parentViewController: UIViewController) {
        self.delegate = delegate
        self.cellDelegate = cellDelegate
        self.parentViewController = parentViewController
        backgroundColor = .clear
        selectionStyle = .none
    }

    func keyboardWillAppear() {
        self.logoTopConstraint.constant = 20
        self.logoHeightConstraint.constant = 21
        self.logoWidthConstraint.constant = 63
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.4, animations: { [unowned self] in
            self.layoutIfNeeded()
        })

        cellDelegate?.keyboardAppeared(viewHeight: loginButton.frame.origin.y + loginButton.frame.height)
    }
}

private extension LoginViewCell {

    func addHierarchy() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(userView)
        contentView.addSubview(passwordView)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(loginButton)
        contentView.addSubview(passwordToggle)
        addSubview(emailCorrectImage)
        contentView.addSubview(warningLabel)
        contentView.addSubview(userInput)
        contentView.addSubview(passwordInput)
        contentView.addSubview(crossImageView)

        hideComponents()
    }

    func setupLayout() {

        contentView.addConstraint(logoTopConstraint)
        contentView.addConstraint(logoHeightConstraint)
        contentView.addConstraint(logoWidthConstraint)

        logoImageView.centerXAnchor == contentView.centerXAnchor

        crossImageView.bottomAnchor == warningLabel.topAnchor
        crossImageView.heightAnchor == 10
        crossImageView.widthAnchor == 10
        crossImageView.leadingAnchor == contentView.leadingAnchor + 38

        warningLabel.leadingAnchor == contentView.leadingAnchor + 36
        warningLabel.trailingAnchor == contentView.trailingAnchor - 57
        warningLabel.heightAnchor == 53
        warningLabel.bottomAnchor == userInput.topAnchor - 50

        userInput.topAnchor == contentView.topAnchor + 205
        userInput.leadingAnchor == contentView.leadingAnchor + 40
        userInput.trailingAnchor == emailCorrectImage.leadingAnchor
        userInput.heightAnchor == 33

        userView.topAnchor == userInput.bottomAnchor
        userView.leadingAnchor == contentView.leadingAnchor + 37
        userView.trailingAnchor == contentView.trailingAnchor - 38
        userView.heightAnchor == 1

        emailCorrectImage.bottomAnchor == userInput.bottomAnchor - 12
        emailCorrectImage.trailingAnchor == userView.trailingAnchor - 10
        emailCorrectImage.heightAnchor == 9
        emailCorrectImage.widthAnchor == 14

        passwordInput.topAnchor == userView.bottomAnchor + 29
        passwordInput.leadingAnchor == contentView.leadingAnchor + 40
        passwordInput.trailingAnchor == passwordToggle.leadingAnchor
        passwordInput.heightAnchor == 33

        passwordView.topAnchor == passwordInput.bottomAnchor
        passwordView.leadingAnchor == contentView.leadingAnchor + 37
        passwordView.trailingAnchor == contentView.trailingAnchor - 38
        passwordView.heightAnchor == 1

        passwordToggle.bottomAnchor == passwordInput.bottomAnchor - 5
        passwordToggle.trailingAnchor == passwordView.trailingAnchor
        passwordToggle.heightAnchor == 23
        passwordToggle.widthAnchor == 43

        forgotPasswordButton.topAnchor == passwordView.bottomAnchor
        forgotPasswordButton.trailingAnchor == contentView.trailingAnchor
        forgotPasswordButton.widthAnchor == 197
        forgotPasswordButton.heightAnchor == 53

        loginButton.topAnchor == passwordView.bottomAnchor + 135
        loginButton.horizontalAnchors == contentView.horizontalAnchors

        userInput.tag = 0
        passwordInput.tag = 1

        layoutIfNeeded()
    }

    func isValidEmail(valid: Bool) {
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

    func hideComponents() {
        self.warningLabel.isHidden = true
        self.crossImageView.isHidden = true
        self.emailCorrectImage.isHidden = true
        self.userView.backgroundColor = .whiteLight14
    }
}

extension LoginViewCell: UITextFieldDelegate {

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }

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
            doLogin()
        }
        return false
    }
}
