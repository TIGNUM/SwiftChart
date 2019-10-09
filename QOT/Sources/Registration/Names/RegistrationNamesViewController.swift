//
//  RegistrationNamesViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationNamesViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var firstNameField: QotPlaceholderTextField!
    @IBOutlet private weak var lastNameField: QotPlaceholderTextField!
    @IBOutlet private weak var mandatoryLabel: UILabel!
    private var keyboardNotification: NSNotification?

    private let viewTheme = ThemeView.onboarding
    private let errorBorderColor = UIColor.redOrange.cgColor
    private let defaultBorderColor = UIColor.sand40.cgColor

    private lazy var buttonNext: RoundedButton = {
        return RoundedButton(title: interactor?.nextButtonTitle ?? "", target: self, action: #selector(didTapNextButton))
    }()

    var interactor: RegistrationNamesInteractorInterface?

    // MARK: - Init

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        startObservingKeyboard()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        buttonNext.isEnabled = !(firstNameField.text?.isEmpty ?? true)
        return [buttonNext.barButton]
    }

    override func didTapBackButton() {
        trackUserEvent(.BACK, action: .TAP)
        interactor?.resetErrors()
        firstNameField.text = nil
        lastNameField.text = nil

        interactor?.didTapBack()
    }
}

// MARK: - Private

private extension RegistrationNamesViewController {
}

// MARK: - Actions

private extension RegistrationNamesViewController {
    @objc func didTapNextButton() {
        guard let name = firstNameField.text else { return }
        interactor?.didTapNext(with: name, lastName: lastNameField.text)
        let userName = name + " " + (lastNameField.text ?? "")
        trackUserEvent(.NEXT, stringValue: userName, valueType: .USER_ANSWER, action: .TAP)
    }
}

// MARK: - RegistrationNamesViewControllerInterface

extension RegistrationNamesViewController: RegistrationNamesViewControllerInterface {
    func setupView() {
        viewTheme.apply(view)
        viewTheme.apply(firstNameField.textField)
        viewTheme.apply(lastNameField.textField)

        ThemeText.registrationNamesTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor?.firstNameTitle, to: firstNameField.placeholderLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor?.lastNameTitle, to: lastNameField.placeholderLabel)
        ThemeText.registrationNamesMandatory.apply(interactor?.mandatoryText, to: mandatoryLabel)

        firstNameField.textField.returnKeyType = .next
        firstNameField.delegate = self
        lastNameField.textField.returnKeyType = .go
        lastNameField.delegate = self
    }

    func updateView() {
        firstNameField.textField.layer.borderColor = (interactor?.hasFirstNameError ?? false) ? errorBorderColor : defaultBorderColor
        lastNameField.textField.layer.borderColor = (interactor?.hasLastNameError ?? false) ? errorBorderColor : defaultBorderColor
    }
}

// MARK: - Keyboard

extension RegistrationNamesViewController {

    override func keyboardWillAppear(notification: NSNotification) {
        keyboardNotification = notification
        animateKeyboardNotification(notification)
    }

    override func keyboardWillDisappear(notification: NSNotification) {
        animateKeyboardNotification(notification)
        keyboardNotification = nil
        refreshBottomNavigationItems()
    }

    private func animateKeyboardNotification(_ notification: NSNotification) {
        guard let activeField = firstNameField.textField.isFirstResponder ? firstNameField : lastNameField else { return }

        // Get animation curve and duration
        guard let parameters = keyboardParameters(from: notification) else { return }

        if parameters.endFrameY >= UIScreen.main.bounds.size.height || firstNameField.textField.isFirstResponder {
            // Keyboard is hiding or first name is active field
            animateOffset(0, duration: parameters.duration, animationCurve: parameters.animationCurve)
        } else {
            // Keyboard is showing
            let offset = activeField.frame.origin.y + activeField.frame.size.height - parameters.height
            animateOffset(offset, duration: parameters.duration, animationCurve: parameters.animationCurve)
        }
    }

    private func animateOffset(_ offset: CGFloat, duration: TimeInterval, animationCurve: UIViewAnimationOptions) {
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: animationCurve,
                       animations: { self.scrollView.contentOffset = CGPoint(x: 0, y: offset) },
                       completion: nil)
    }
}

extension RegistrationNamesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField.textField {
            lastNameField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapNextButton()
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        interactor?.resetErrors()
        guard lastNameField.textField.isFirstResponder, let notification = keyboardNotification else { return }
        animateKeyboardNotification(notification)
    }
}
