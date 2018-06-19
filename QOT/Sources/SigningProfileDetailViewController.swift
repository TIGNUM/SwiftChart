//
//  SigningProfileDetailViewController.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

final class SigningProfileDetailViewController: SigningAbstractViewController {

    // MARK: - Properties

    @IBOutlet private weak var firstNameContentView: UIView!
    @IBOutlet private weak var lastNameContentView: UIView!
    @IBOutlet private weak var genderContentView: UIView!
    @IBOutlet private weak var dateOfBirthContentView: UIView!
    @IBOutlet private weak var checkBoxContentView: UIView!
    @IBOutlet private weak var checkBoxButton: UIButton!
    @IBOutlet private weak var checkBoxLabel: ClickableLabel!
    @IBOutlet private weak var checkBoxErrorLabel: UILabel!
    private lazy var firstNameFormView: FormView? = formView()
    private lazy var lastNameFormView: FormView? = formView()
    private lazy var genderFormView: FormView? = formView()
    private lazy var dateOfBirthFormView: FormView? = formView()
    var interactor: SigningProfileDetailInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SigningProfileDetailViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension SigningProfileDetailViewController {

    func setupFormViews() {
        if let firstNameFormView = firstNameFormView {
            firstNameFormView.configure(formType: .firstName(""))
            firstNameContentView.addSubview(firstNameFormView)
            firstNameContentView.backgroundColor = .clear
            firstNameFormView.delegate = self
        }
        if let lastNameFormView = lastNameFormView {
            lastNameFormView.configure(formType: .lastName(""))
            lastNameContentView.addSubview(lastNameFormView)
            lastNameContentView.backgroundColor = .clear
            lastNameFormView.delegate = self
        }
        if let genderFormView = genderFormView {
            genderFormView.configure(formType: .gender(""), enabled: false)
            genderContentView.addSubview(genderFormView)
            genderContentView.sendSubview(toBack: genderFormView)
            genderContentView.backgroundColor = .clear
            genderFormView.delegate = self
        }
        if let dateOfBirthFormView = dateOfBirthFormView {
            dateOfBirthFormView.configure(formType: .dateOfBirth(""), enabled: false)
            dateOfBirthContentView.addSubview(dateOfBirthFormView)
            dateOfBirthContentView.sendSubview(toBack: dateOfBirthFormView)
            dateOfBirthContentView.backgroundColor = .clear
            dateOfBirthFormView.delegate = self
        }
    }

    func setupCheckView() {
        let checkBoxText = R.string.localized.signingProfileCheckBoxText()
        let errorText = R.string.localized.signingProfileCheckBoxError()
        checkBoxLabel.attributedText = attrString(checkBoxText, color: .white60)
        checkBoxLabel.delegate = self
        checkBoxErrorLabel.attributedText = attrString(errorText, color: .cherryRed60)
        checkBoxErrorLabel.isHidden = true
    }

    func attrString(_ text: String, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: text,
                                  letterSpacing: 0.6,
                                  font: .apercuLight(ofSize: 11),
                                  textColor: color,
                                  alignment: .left)
    }
}

// MARK: - Actions

private extension SigningProfileDetailViewController {

    @IBAction func didTabGenderField() {
        endEditing()
        showStringPicker(title: "Gender", items: ["FEMALE", "MALE", "OTHER", "PREFER NOT TO SAY"])
    }

    @IBAction func didTabDateOfBirthField() {
        endEditing()
        showDatePicker(title: "Birthdate", selectedDate: Date().twentyOneYearsAgo)
    }

    @IBAction func didTabCheckBox() {
        checkBoxButton.isSelected = !checkBoxButton.isSelected
        interactor?.updateCheckBox(checkBoxButton.isSelected)
        if checkBoxErrorLabel.isHidden == false {
            checkBoxErrorLabel.isHidden = checkBoxButton.isSelected
        }
    }

    @IBAction func didTabCreateAccount() {
        guard let interactor = interactor else { return }
        if interactor.firstName.isEmpty == true {
            firstNameFormView?.showError(message: R.string.localized.signingProfileErrorFirstName())
        } else {
            firstNameFormView?.hideError()
        }
        if interactor.lastName.isEmpty == true {
            lastNameFormView?.showError(message: R.string.localized.signingProfileErrorLastName())
        } else {
            lastNameFormView?.hideError()
        }
        if interactor.gender.isEmpty == true {
            genderFormView?.showError(message: R.string.localized.signingProfileErrorGender())
        } else {
            genderFormView?.hideError()
        }
        if interactor.dateOfBirth.isEmpty == true {
            dateOfBirthFormView?.showError(message: R.string.localized.signingProfileErrorBirthdate())
        } else {
            dateOfBirthFormView?.hideError()
        }
        checkBoxErrorLabel.isHidden = checkBoxButton.isSelected
        interactor.didTapNext()
    }
}

// MARK: - SigningProfileDetailViewControllerInterface

extension SigningProfileDetailViewController: SigningProfileDetailViewControllerInterface {

    func setup() {
        checkBoxContentView.backgroundColor = .clear
        setupFormViews()
        setupView(title: R.string.localized.signingProfileTitle(),
                  subtitle: R.string.localized.signingProfileSubtitle(),
                  bottomButtonTitle: R.string.localized.signingProfileBottomButtonTitle())
        setupCheckView()
    }

    func activateButton(_ active: Bool) {
        updateBottomButton(active)
    }

    override func endEditing() {
        super.endEditing()
        firstNameFormView?.resetPlaceholderLabelIfNeeded()
        lastNameFormView?.resetPlaceholderLabelIfNeeded()
        genderFormView?.resetPlaceholderLabelIfNeeded()
        dateOfBirthFormView?.resetPlaceholderLabelIfNeeded()
    }
}

// MARK: - FormViewDelegate

extension SigningProfileDetailViewController: FormViewDelegate {

    func didUpdateTextfield(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
    }

    func didEndEditingTextField(formType: FormView.FormType?) {
        interactor?.updateWorkerValue(for: formType)
        interactor?.didTapNext()
    }

    func didBeginEditingTextField(formType: FormView.FormType?) {}
}

// MARK: - Private PickerView

private extension SigningProfileDetailViewController {

    func showDatePicker(title: String, selectedDate: Date) {
        ActionSheetDatePicker(title: title,
                              datePickerMode: .date,
                              selectedDate: selectedDate,
                              doneBlock: { [unowned self] (_, value, _) in
                                if let date = value as? Date {
                                    let dateOfBirth = DateFormatter.settingsUser.string(from: date)
                                    self.interactor?.updateWorkerValue(for: .dateOfBirth(dateOfBirth))
                                    self.dateOfBirthFormView?.configure(formType: .dateOfBirth(dateOfBirth))
                                    self.endEditing()
                                }
            }, cancel: { [unowned self] _ in
                self.endEditing()
                return
        }, origin: view).show()
    }

    func showStringPicker(title: String, items: [String]) {
        ActionSheetStringPicker(title: title, rows: items, initialSelection: 0, doneBlock: { [unowned self] (_, index, _) in
            self.interactor?.updateWorkerValue(for: .gender(items[index]))
            self.genderFormView?.configure(formType: .gender(items[index]))
            self.endEditing()
            }, cancel: { [unowned self] _ in
                self.endEditing()
                return
        }, origin: view).show()
    }
}

// MARK: - ClickableLabelDelegate

extension SigningProfileDetailViewController: ClickableLabelDelegate {

    func openLink(withURL url: URL) {
        if url.scheme == "termsOfUse" {
            interactor?.showTermsOfUse()
        }
        if url.scheme == "privacyPolicy" {
            interactor?.showPrivacyPolicy()
        }
    }
}
