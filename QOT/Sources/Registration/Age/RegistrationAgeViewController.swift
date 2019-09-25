//
//  RegistrationAgeViewController.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgeViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ageInputField: QotPlaceholderTextField!
    @IBOutlet private weak var ageRestrictionLabel: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!

    private let viewTheme = ThemeView.onboarding

    private var bottomConstraintInitialValue: CGFloat = 0
    var interactor: RegistrationAgeInteractorInterface?

    lazy private var saveButton: UIBarButtonItem = {
        return RoundedButton.barButton(title: interactor?.createButtonTitle ?? "",
                                       target: self,
                                       action: #selector(didTapCreateAccountButton))
    }()

    lazy private var keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 60))
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.backgroundColor = .carbonNew

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        saveButton.isEnabled = false
        toolbar.items = [space, saveButton]
        return toolbar
    }()

    lazy private var years: [String] = {
        let currentYear = Calendar.current.component(.year, from: Date())
        let lowerBound = Date().minimumDateOfBirth.year()
        let upperBound = Date().maximumDateOfBirth.year()

        var array = [String]()
        for year in lowerBound...upperBound {
            array.append(String(year))
        }

        array.reverse()
        array.insert(R.string.localized.yearPickerTitleSelect(), at: 0)
        return array
    }()

    lazy private var yearPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .carbonNew
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    private lazy var createAccountButton: RoundedButton = {
        return RoundedButton(title: interactor?.createButtonTitle ?? "", target: self, action: #selector(didTapCreateAccountButton))
    }()

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
        bottomConstraintInitialValue = bottomConstraint.constant
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func didTapBackButton() {
        interactor?.didTapBack()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        createAccountButton.isEnabled = !(ageInputField.text?.isEmpty ?? true)
        return [createAccountButton.barButton]
    }
}

// MARK: - Private

private extension RegistrationAgeViewController {
}

// MARK: - Actions

private extension RegistrationAgeViewController {

    @objc func didTapCreateAccountButton() {
        ageInputField.textField.resignFirstResponder()
        guard let year = ageInputField.text, Int(year) != nil else { return }
        interactor?.didTapNext(with: year)
    }
}

// MARK: - RegistrationAgeViewControllerInterface

extension RegistrationAgeViewController: RegistrationAgeViewControllerInterface {

    func setupView() {
        viewTheme.apply(view)
        viewTheme.apply(ageInputField.textField)

        ThemeText.registrationAgeTitle.apply(interactor?.title, to: titleLabel)
        ThemeText.onboardingInputPlaceholder.apply(interactor?.agePlaceholder, to: ageInputField.placeholderLabel)
        ThemeText.registrationAgeDescription.apply(interactor?.descriptionText, to: descriptionLabel)
        ThemeText.registrationAgeRestriction.apply(interactor?.ageRestrictionText, to: ageRestrictionLabel)

        ageInputField.textField.inputView = yearPicker
        ageInputField.textField.inputAccessoryView = keyboardToolbar
        ageInputField.textField.tintColor = .clear
        ageInputField.delegate = self
    }
}

// MARK: - UIPickerViewDataSource

extension RegistrationAgeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
}

// MARK: - UIPickerViewDelegate

extension RegistrationAgeViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: years[row],
                                  attributes: [.font: UIFont.sfProtextRegular(ofSize: 24), .foregroundColor: UIColor.sand])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selection = years[row]
        if Int(selection) != nil {
            ageInputField.text = selection
            saveButton.isEnabled = true
        } else {
            ageInputField.text = nil
            saveButton.isEnabled = false
        }
    }
}

extension RegistrationAgeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Handle invalid text (e.g. on paste)
        if let text = textField.text, Int(text) == nil {
            textField.text = nil
        }

        refreshBottomNavigationItems()
    }
}

// MARK: - Keyboard

extension RegistrationAgeViewController {

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
            let difference = (view.frame.size.height - ageInputField.frame.origin.y - ageInputField.frame.size.height)
            let offset = parameters.height - difference
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
