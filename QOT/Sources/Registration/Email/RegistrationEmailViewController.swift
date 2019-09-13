//
//  RegistrationEmailViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationEmailViewController: UIViewController, ScreenZLevel3 {

    // MARK: - Properties
    let viewTheme = ThemeView.onboarding

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emailField: QotPlaceholderTextField!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    private var bottomConstraintInitialValue: CGFloat = 0

    private lazy var buttonNext: UIBarButtonItem = {
        let button = RoundedButton.barButton(title: interactor?.nextButtonTitle ?? "",
                                             target: self,
                                             action: #selector(didTapNextButton))
        button.isEnabled = false
        return button
    }()

    var interactor: RegistrationEmailInteractorInterface?

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        refreshBottomNavigationItems()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bottomConstraintInitialValue = bottomConstraint.constant
        interactor?.viewDidLoad()
        startObservingKeyboard()
        hideKeyboardWhenTappedAround()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        buttonNext.isEnabled = emailField.textField.isFirstResponder ? false : (interactor?.isNextButtonEnabled ?? false)
        return [buttonNext]
    }

    override func didTapBackButton() {
        interactor?.didTapBack()
    }

    override func dismissKeyboard() {
        if !emailField.textField.isFirstResponder {
            return
        }
        super.dismissKeyboard()
        interactor?.setEmail(emailField.text)
    }
}

// MARK: - Actions

private extension RegistrationEmailViewController {

    @objc private func didTapNextButton() {
        interactor?.setEmail(emailField.textField.text)
        interactor?.didTapNext()
    }
}

// MARK: - RegistrationEmailViewControllerInterface

extension RegistrationEmailViewController: RegistrationEmailViewControllerInterface {

    func setupView() {
        viewTheme.apply(view)
        viewTheme.apply(emailField.textField)

        buttonNext.isEnabled = interactor?.isNextButtonEnabled ?? false

        ThemeText.registrationEmailTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor?.emailPlaceholder, to: emailField.placeholderLabel)
        emailField.delegate = self
        emailField.textField.corner(radius: .Nine, borderColor: .sand40)
        emailField.textField.autocapitalizationType = .none
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.autocorrectionType = .no
        emailField.textField.enablesReturnKeyAutomatically = true
        emailField.textField.returnKeyType = .go
    }

    func updateView() {
        buttonNext.isEnabled = interactor?.isNextButtonEnabled ?? false
        updateMessageUI(message: interactor?.descriptionMessage, isError: interactor?.isDisplayingError ?? false)
    }
}

// MARK: - Private

private extension RegistrationEmailViewController {
    func updateMessageUI(message: String?, isError: Bool) {
        if isError {
            emailField.textField.layer.borderColor = UIColor.redOrange.cgColor
            ThemeText.registrationEmailError.apply(message, to: descriptionLabel)
        } else {
            emailField.textField.layer.borderColor = UIColor.sand40.cgColor
            ThemeText.registrationEmailMessage.apply(message, to: descriptionLabel)
        }
    }
}

// MARK: - UITextField delegate

extension RegistrationEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didTapNextButton()
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        interactor?.resetError()
        buttonNext.isEnabled = false
    }
}

// MARK: - Keyboard

extension RegistrationEmailViewController {

    override func keyboardWillAppear(notification: NSNotification) {
        animateKeyboardNotification(notification)
    }

    override func keyboardWillDisappear(notification: NSNotification) {
        animateKeyboardNotification(notification)
        refreshBottomNavigationItems()
    }

    private func animateKeyboardNotification(_ notification: NSNotification) {
        // Get animation curve and duration
        guard let parameters = keyboardParameters(from: notification) else { return }

        if parameters.endFrameY >= UIScreen.main.bounds.size.height {
            // Keyboard is hiding
            animateOffset(bottomConstraintInitialValue, duration: parameters.duration, animationCurve: parameters.animationCurve)
        } else {
            // Keyboard is showing
            let offset = parameters.height - bottomConstraintInitialValue
            animateOffset(offset, duration: parameters.duration, animationCurve: parameters.animationCurve)
        }
    }

    private func animateOffset(_ offset: CGFloat, duration: TimeInterval, animationCurve: UIViewAnimationOptions) {
        bottomConstraint.constant = offset
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}
