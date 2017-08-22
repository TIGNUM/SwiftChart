//
//  ResetPasswordViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ResetPasswordViewCellDelegate: class {
    func keyboardAppeared(viewHeight: CGFloat)
    func didTapResetPassword(withUserName: String, successCompletion: @escaping () -> Void)
}

class ResetPasswordViewCell: UITableViewCell, Dequeueable {

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

    fileprivate weak var delegate: ResetPasswordViewControllerDelegate?
    fileprivate weak var cellDelegate: ResetPasswordViewCellDelegate?
    fileprivate weak var parentViewController: UIViewController?

    fileprivate let logoImageView: UIImageView = UIImageView(image: R.image.loginLogo())
//    fileprivate let crossImageView: UIImageView = UIImageView(image: R.image.crossImage())
    fileprivate let emailCorrectImage: UIImageView = UIImageView(image: R.image.correctEmail())

    fileprivate let warningSignLabel: UILabel = {
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

    fileprivate let warningLabel: UILabel = {
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

    fileprivate lazy var userInput: UITextField = {
        let input = UITextField()
        let placeHolder = NSMutableAttributedString(string: R.string.localized.resetPasswordEmailPlaceHolder(), letterSpacing: 1.5, font: Font.H8Title, textColor: .white80, alignment: .left)
        input.textColor = .white
        input.tintColor = input.textColor
        input.autocorrectionType = .no
        input.font = Font.DPText
        input.contentVerticalAlignment = .center
        input.keyboardType = .emailAddress
        input.keyboardAppearance = .dark
        input.returnKeyType = .send
        input.clearsOnBeginEditing = true
        input.delegate = self
        input.attributedPlaceholder = placeHolder
        return input
    }()

    fileprivate lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didPressResetPassword(_:)), for: .touchUpInside)
        button.setTitleColor(.white40, for: .normal)
        button.setTitle(R.string.localized.resetPasswordResetMyPassword(), for: .normal)
        button.titleLabel?.addCharactersSpacing(spacing: 1, text: R.string.localized.resetPasswordResetMyPassword())
        button.titleLabel?.font = Font.DPText
        button.titleLabel?.textAlignment = .center
        return button
    }()

    @objc func didPressResetPassword(_ sender: UIButton) {
        self.resignFirstResponder()
        doPasswordReset()
    }

    func doPasswordReset() {
        guard let username = userInput.text?.trimmingCharacters(in: .whitespacesAndNewlines), username.characters.count > 0 else { return }

        cellDelegate?.didTapResetPassword(withUserName: username) { [weak self] in
            guard let strongSelf = self else { return }

            UIView.transition(with: strongSelf.resetPasswordButton,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: { [weak self] in
                                self?.resetPasswordButton.titleLabel?.addCharactersSpacing(spacing: 1, text: R.string.localized.resetPasswordEmailSent())
                }, completion: nil)
        }
    }

    func configure(delegate: ResetPasswordViewControllerDelegate?, cellDelegate: ResetPasswordViewCellDelegate?, parentViewController: UIViewController) {
        self.delegate = delegate
        self.cellDelegate = cellDelegate
        self.parentViewController = parentViewController
        backgroundColor = .clear
        selectionStyle = .none
    }

    let checkEmailQueue = DispatchQueue(label: "TEMP") // FIXME: REMOVE

    func checkEmail(_ email: String, completion: @escaping (Bool) -> Void) {
        checkEmailQueue.async { [weak self] in
            self?.delegate?.checkIfEmailAvailable(email: email) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }

    func keyboardWillAppear() {
        cellDelegate?.keyboardAppeared(viewHeight: resetPasswordButton.frame.origin.y + resetPasswordButton.frame.height)
    }
}

private extension ResetPasswordViewCell {

    func addHierarchy() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(userView)
        contentView.addSubview(passwordView)
        contentView.addSubview(resetPasswordButton)
        addSubview(emailCorrectImage)
        contentView.addSubview(warningLabel)
        contentView.addSubview(userInput)
        contentView.addSubview(warningSignLabel)

        hideComponents()
    }

    func setupLayout() {
        logoImageView.topAnchor == contentView.topAnchor + 20
        logoImageView.heightAnchor == 21
        logoImageView.widthAnchor == 63
        logoImageView.centerXAnchor == contentView.centerXAnchor

        warningSignLabel.bottomAnchor == warningLabel.topAnchor
        warningSignLabel.leadingAnchor == contentView.leadingAnchor + 37

        warningLabel.leadingAnchor == contentView.leadingAnchor + 36
        warningLabel.trailingAnchor == contentView.trailingAnchor - 57
        warningLabel.heightAnchor == 53
        warningLabel.bottomAnchor == userInput.topAnchor - 44

        userInput.topAnchor == contentView.topAnchor + 207
        userInput.leadingAnchor == contentView.leadingAnchor + 40
        userInput.trailingAnchor == emailCorrectImage.leadingAnchor
        userInput.heightAnchor == 33

        userView.topAnchor == userInput.bottomAnchor - 2
        userView.leadingAnchor == contentView.leadingAnchor + 37
        userView.trailingAnchor == contentView.trailingAnchor - 38
        userView.heightAnchor == 1

        emailCorrectImage.bottomAnchor == userInput.bottomAnchor - 14
        emailCorrectImage.trailingAnchor == userView.trailingAnchor - 10
        emailCorrectImage.heightAnchor == 9
        emailCorrectImage.widthAnchor == 14

        resetPasswordButton.topAnchor == userView.bottomAnchor + 65
        resetPasswordButton.horizontalAnchors == contentView.horizontalAnchors

        userInput.tag = 0

        layoutIfNeeded()
    }

    func isValidEmail(valid: Bool) {
        if !valid {
            self.emailCorrectImage.isHidden = true
            self.userView.backgroundColor = .cherryRed
        } else {
            self.emailCorrectImage.isHidden = false
            self.userView.backgroundColor = .white
        }
    }

    func hideComponents() {
        self.emailCorrectImage.isHidden = true
        self.userView.backgroundColor = .whiteLight14
    }
}

extension ResetPasswordViewCell: UITextFieldDelegate {

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if textField == userInput {
            userView.backgroundColor = .white
            if text.isEmpty {
                userView.backgroundColor = .whiteLight14
            }
//            if !text.isEmpty {
//                checkEmail(text, completion: { (bool) in
//                    self.isValidEmail(valid: bool)
//                })
//            }
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
