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
    @IBOutlet private weak var ageInputField: QotPlaceholderTextField!
    @IBOutlet private weak var ageRestrictionLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mandatoryLabel: UILabel!
    private var keyboardNotification: NSNotification?

    private var bottomConstraintInitialValue: CGFloat = 0
    private let viewTheme = ThemeView.onboarding
    private let errorBorderColor = UIColor.redOrange.cgColor
    private let defaultBorderColor = UIColor.sand40.cgColor

    lazy private var createAccountButton: RoundedButton = {
        return RoundedButton(title: interactor.createButtonTitle,
                             target: self,
                             action: #selector(didTapCreateAccount))
    }()

    lazy private var createAccountBarButton: RoundedButton = {
        return RoundedButton(title: interactor.createButtonTitle,
                             target: self,
                             action: #selector(didTapCreateAccount))
    }()

    lazy private var keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.backgroundColor = .carbonNew

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        createAccountBarButton.isEnabled = false
        toolbar.items = [space, createAccountBarButton.barButton]
        return toolbar
    }()

    lazy private var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .carbonNew
        picker.minimumDate = Date().minimumDateOfBirth
        picker.maximumDate = Date().maximumDateOfBirth
        picker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: .valueChanged)
        return picker
    }()

    var interactor: RegistrationNamesInteractorInterface!

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
        interactor.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        createAccountButton.isEnabled = isEnabled()
        createAccountBarButton.isEnabled = isEnabled()
        return [createAccountButton.barButton]
    }

    override func didTapBackButton() {
        trackUserEvent(.BACK, action: .TAP)
        interactor.resetErrors()
        firstNameField.text = nil
        lastNameField.text = nil
        ageInputField.text = nil
        interactor.didTapBack()
    }
}

// MARK: - Private
private extension RegistrationNamesViewController {
    func isEnabled() -> Bool {
        return firstNameField.text?.isEmpty == false && ageInputField.text?.isEmpty == false
    }
}

// MARK: - Actions
private extension RegistrationNamesViewController {
    @objc func didTapCreateAccount() {
        guard let name = firstNameField.text, let dateOfBirth = ageInputField.text else { return }
        updateBottomNavigation([], [])
        createAccountBarButton.alpha = 0
        createAccountButton.alpha = 0
        ageInputField.textField.resignFirstResponder()
        view.endEditing(true)
        interactor.didTapNext(with: name, lastName: lastNameField.text, birthDate: ageInputField.text)
        let userName = name + " " + (lastNameField.text ?? "")
        trackUserEvent(.CREATE_ACCOUNT,
                       stringValue: "userName: " + userName + ", dateOfBirth: " + dateOfBirth,
                       valueType: .USER_ANSWER,
                       action: .TAP)
    }

    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        let formatter = DateFormatter.yyyyMMdd
        ageInputField.text = formatter?.string(from: datePicker.date)
        createAccountBarButton.isEnabled = isEnabled()
    }
}

// MARK: - RegistrationNamesViewControllerInterface
extension RegistrationNamesViewController: RegistrationNamesViewControllerInterface {
    func setupView() {
        viewTheme.apply(view)
        viewTheme.apply(firstNameField.textField)
        viewTheme.apply(lastNameField.textField)

        ThemeText.registrationNamesTitle.apply(interactor.title.uppercased(), to: titleLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor.firstNameTitle, to: firstNameField.placeholderLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor.lastNameTitle, to: lastNameField.placeholderLabel)
        ThemeText.registrationNamesMandatory.apply(interactor.mandatoryText, to: mandatoryLabel)

        firstNameField.textField.returnKeyType = .next
        firstNameField.delegate = self
        lastNameField.textField.returnKeyType = .next
        lastNameField.delegate = self

        viewTheme.apply(ageInputField.textField)
        ThemeText.registrationAgeTitle.apply(interactor.title, to: titleLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor.agePlaceholder, to: ageInputField.placeholderLabel)
        ThemeText.registrationAgeRestriction.apply(interactor.ageRestrictionText, to: ageRestrictionLabel)

        ageInputField.textField.inputView = datePicker
        ageInputField.textField.inputAccessoryView = keyboardToolbar
        ageInputField.textField.returnKeyType = .go
        ageInputField.textField.tintColor = .clear
        ageInputField.delegate = self
    }

    func updateView() {
        firstNameField.textField.layer.borderColor = (interactor.hasFirstNameError) ? errorBorderColor : defaultBorderColor
        lastNameField.textField.layer.borderColor = (interactor.hasLastNameError) ? errorBorderColor : defaultBorderColor
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

// MARK: - UITextFieldDelegate
extension RegistrationNamesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField.textField {
            lastNameField.textField.becomeFirstResponder()
        } else if textField == lastNameField.textField {
            ageInputField.textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            didTapCreateAccount()
        }
        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        interactor.resetErrors()
        guard lastNameField.textField.isFirstResponder, let notification = keyboardNotification else { return }
        animateKeyboardNotification(notification)
    }
}
