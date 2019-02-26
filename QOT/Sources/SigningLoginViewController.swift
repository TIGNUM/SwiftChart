//
//  SigningLoginViewController.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningLoginViewController: AbstractFormViewController {

    // MARK: - Properties

    @IBOutlet private weak var emailFormContentView: UIView!
    @IBOutlet private weak var passwordFormContentView: UIView!
    @IBOutlet private weak var resetPasswordButton: UIButton!
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    private lazy var formViewEmail: FormView? = formView()
    private lazy var formViewPassword: FormView? = formView()
    var interactor: SigningLoginInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SigningLoginViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        addKeyboardObserver()
    }
}

// MARK: - Private

private extension SigningLoginViewController {

    func setupFormView() {
        guard
            let formEmail = formViewEmail,
            let formPassword = formViewPassword else { return }
        formPassword.delegate = self
        emailFormContentView.backgroundColor = .clear
        passwordFormContentView.backgroundColor = .clear
        emailFormContentView.addSubview(formEmail)
        passwordFormContentView.addSubview(formPassword)
        formEmail.configure(formType: .email(interactor?.email ?? ""), enabled: false)
        formPassword.configure(formType: .password(""))
		if #available(iOS 11.0, *) {

		} else {
			topConstraint.constant = Layout.statusBarHeight
		}
    }

    func setupResetPasswordButton() {
        let attributedTitle = NSMutableAttributedString(string: R.string.localized.signingLoginButtonTitleForgotPassword(),
                                                        letterSpacing: 0.8,
                                                        font: .apercuLight(ofSize: 16),
                                                        textColor: .white90,
                                                        alignment: .left)
        resetPasswordButton.setAttributedTitle(attributedTitle, for: .normal)
        resetPasswordButton.setAttributedTitle(attributedTitle, for: .selected)
    }
}

// MARK: - Actions

private extension SigningLoginViewController {

    @IBAction func didTapButton() {
        if bottomButton.backgroundColor != .clear {
            interactor?.didTapNext()
        } else {
            reload(errorMessage: R.string.localized.signingLoginErrorMessagePassword(), buttonActive: false)
        }
    }

    @IBAction func didTapResetPasswordButton() {
        interactor?.didTapbedForgettPasswordButton()
    }
}

// MARK: - SigningLoginViewControllerInterface

extension SigningLoginViewController: SigningLoginViewControllerInterface {

    func didResendPassword() {
        let formType = FormView.FormType.password("")
        formViewPassword?.configure(formType: formType)
        interactor?.updateWorkerValue(for: formType)
        updateBottomButton(false)
        endEditing()
    }

    override func endEditing() {
        formViewEmail?.resetPlaceholderLabelIfNeeded()
        formViewPassword?.resetPlaceholderLabelIfNeeded()
        super.endEditing()
    }

    func activateButton(_ active: Bool) {
        if active == true {
            formViewPassword?.hideError()
        }
        updateBottomButton(active)
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        if let message = errorMessage {
            formViewPassword?.showError(message: message)
        }
        updateBottomButton(buttonActive)
    }

    func setup() {
        setupView(title: R.string.localized.signingLoginTitle(),
                  subtitle: R.string.localized.signingLoginSubtitle(),
                  bottomButtonTitle: R.string.localized.signingLoginBottomButtonTitle())
        setupResetPasswordButton()
        setupFormView()
    }
}

// MARK: - FormViewDelegate

extension SigningLoginViewController: FormViewDelegate {

    func didBeginEditingTextField(formType: FormView.FormType?) {}

    func didTapReturn(formType: FormView.FormType?) {
        formViewPassword?.activateTextField(false)
        didTapButton()
    }

    func didEndEditingTextField(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }

    func didUpdateTextfield(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }
}

// MARK: - NotificationCenter

extension SigningLoginViewController {

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        titleContentView?.frame.origin.y -= Layout.padding_32
        formViewEmail?.frame.origin.y -= Layout.padding_40
        formViewPassword?.frame.origin.y -= Layout.padding_50
    }

    @objc func keyboardWillHide(notification: Notification) {
        titleContentView?.frame.origin.y += Layout.padding_32
        formViewEmail?.frame.origin.y += Layout.padding_40
        formViewPassword?.frame.origin.y += Layout.padding_50
    }
}
